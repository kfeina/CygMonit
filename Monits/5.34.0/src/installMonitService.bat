REM rm -rf /home/SYSTEM/
REM chown Administrator /etc/monitrc
REM chown Administrator /usr/local/bin/monit.exe

set "ROOT=%~dp0"

"%ROOT%..\bin\bash" -l -c "/Setup/installMonitService.sh"	