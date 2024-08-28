REM ##############################################################################
REM # Created by: KPorta
REM # On Date: 1/12/2014
REM # License: GPL v3
REM ##############################################################################

REM ##############################################################################
REM #GLOBAL VARIABLES:

setlocal

@echo off

echo CYGWIN TIME MACHINE URL http://www.crouchingtigerhiddenfruitbat.org/Cygwin/timemachine.html

set "_PROJECT_NAME=CygMonit_Dev"
set "_PROJECT_DRIVE=C:\"
set "_PROJECT_FOLDER=%_PROJECT_DRIVE%%_PROJECT_NAME%"

set "_MONIT_VERSION=5.14"
set "_MONIT_FILE=monit-%_MONIT_VERSION%.tar.gz"

set "_CYGWIN_ARCHITECTURE=x86"
set "_CYGWIN_VERSION=2.6.0.1"

set "_SETUP_VERSION=2.874"
set "_SETUP_EXE=CygwinSetups\setup-%_CYGWIN_ARCHITECTURE%-%_SETUP_VERSION%.exe"

set "_LOCALPACKAGEDIR=%_PROJECT_FOLDER%\DOWNLOADED\%_CYGWIN_ARCHITECTURE%-%_CYGWIN_VERSION%-%_SETUP_VERSION%"

set "_PROXY="
set "_SITE= http://ctm.crouchingtigerhiddenfruitbat.org/pub/cygwin/circa/2016/09/08/194229"


REM ##############################################################################
REM #Main: 

:main  	
	goto :development
	
:development

	echo Preparing development environment %_SETUP_EXE% 	
	
	set "_ENVIRONMENT=DEVELOPMENT"
	set "_ROOTDIR_DEV=%_PROJECT_FOLDER%\%_ENVIRONMENT%\%_CYGWIN_ARCHITECTURE%-%_CYGWIN_VERSION%"

	set "_PACKAGES=autoconf,diff,diffutils,patch,xz,automake,make,gcc-core,m4,bison,libtool,flex,openssl-devel,cygwin-devel,libcrypt-devel"
	
	call :fInstallCygwin %_ROOTDIR_DEV%	
	call :fSetup %_ROOTDIR_DEV%

	goto :buildMonit

:buildMonit
	copy /Y %_PROJECT_FOLDER%\Monits\%_MONIT_VERSION%\src\buildMonit.sh  %_ROOTDIR_DEV%\tmp\buildMonit.sh		
	
	REM Note: bash --login makes mYPWD /home/Administrator instead of cygwin windows path /cygdrive/c/CygMonit_Dev/
	%_ROOTDIR_DEV%\bin\bash -l -c "/tmp/buildMonit.sh"			
	goto :production

:production
	echo Preparing production environment (minimal) %_SETUP_EXE% 	
	
	set "_ENVIRONMENT=PRODUCTION"
	set "_ROOTDIR_PRO=%_PROJECT_FOLDER%\%_ENVIRONMENT%\%_CYGWIN_ARCHITECTURE%-%_CYGWIN_VERSION%"
	
	set "_PACKAGES=crypt,cygrunsrv"	

	call :fInstallCygwin %_ROOTDIR_PRO%
	call :fSetup %_ROOTDIR_PRO%

	goto :monit
		
:monit
	echo "Cleaning old install in case it exists" 
	%_ROOTDIR_PRO%\bin\bash -l -c "rm -f /usr/local/bin/monit.exe"
	%_ROOTDIR_PRO%\bin\bash -l -c "rm -f /etc/monitrc"
	%_ROOTDIR_PRO%\bin\bash -l -c "rm -rf /usr/local/bin/CygMonit"
	%_ROOTDIR_PRO%\bin\bash -l -c "rm -rf /home/SYSTEM/"
	%_ROOTDIR_PRO%\bin\bash -l -c "rm -rf /tmp/monitqueue/"
	
	copy /Y %_PROJECT_FOLDER%\Monits\%_MONIT_VERSION%\exe\monit.exe %_ROOTDIR_PRO%\usr\local\bin		
	copy /Y %_PROJECT_FOLDER%\Monits\%_MONIT_VERSION%\exe\monitrc %_ROOTDIR_PRO%\etc
	xcopy /F /R /Y /I %_PROJECT_FOLDER%\Monits\%_MONIT_VERSION%\exe\CygMonit %_ROOTDIR_PRO%\usr\local\bin\CygMonit

	%_ROOTDIR_PRO%\bin\bash -l -c "chown Administrator /usr/local/bin/monit.exe"	
	%_ROOTDIR_PRO%\bin\bash -l -c "chown Administrator /etc/monitrc"	
	%_ROOTDIR_PRO%\bin\bash -l -c "chmod 0700 /usr/local/bin/monit.exe"
	%_ROOTDIR_PRO%\bin\bash -l -c "chmod 0700 /etc/monitrc"
	
	goto :buildService
		
: buildService	
	copy /Y %_PROJECT_FOLDER%\Monits\%_MONIT_VERSION%\src\buildMonitService.sh  %_ROOTDIR_PRO%\Setup\buildMonitService.sh		
	copy /Y %_PROJECT_FOLDER%\Monits\%_MONIT_VERSION%\src\installMonitService.bat  %_ROOTDIR_PRO%\Setup\installMonitService.bat		
	copy /Y %_PROJECT_FOLDER%\Monits\%_MONIT_VERSION%\src\removeMonitService.bat  %_ROOTDIR_PRO%\Setup\removeMonitService.bat	
	
	REM buildMonitService.sh will be called by the innosetup.exe program
	REM %_ROOTDIR_PRO%\bin\bash -l -c "/Setup/buildMonitService.sh"	
		
	goto :innosetup

:innosetup
	copy /Y %_ROOTDIR_PRO%\Cygwin.bat  %_ROOTDIR_PRO%\Cygwin.bat.original
	copy /Y %_PROJECT_FOLDER%\Monits\%_MONIT_VERSION%\src\CygMonit.bat  %_ROOTDIR_PRO%\Cygwin.bat

	"C:\Program Files (x86)\Inno Setup 6\iscc" %_PROJECT_FOLDER%\Monits\%_MONIT_VERSION%\src\buildSetup.iss

:eof
	exit /b 1
		

REM ##############################################################################
REM #FUCNTIONS:

:fInstallCygwin
	if "%~1" == "" goto :fparamRequired
	
	set "_ROOTDIR=%~1"	
	set "_COMMAND=%_SETUP_EXE% --verbose --quiet-mode --no-verify --no-shortcuts --site %_SITE% --only-site --root "%_ROOTDIR%" --local-package-dir "%_LOCALPACKAGEDIR%" --packages %_PACKAGES%"
	%_COMMAND%	
	
	exit /b 0
	
:fSetup 
	if "%~1" == "" goto :fparamRequired
	
	set "_ROOTDIR=%~1"
	
	mkdir %_ROOTDIR%\Setup		
	copy /Y %_SETUP_EXE% %_ROOTDIR%\Setup		
	echo %_COMMAND% > %_ROOTDIR%\Setup\setup_url.env
	
	exit /b 0	
	
:fparamRequired
	echo "Param is required for the calling funcion"
	
	exit /b 1	
	