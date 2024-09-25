; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define CgywinVersion "3.3.6.1"
#define CgywinArchitecture "x64"

#define AppName "CygMonit"
#define AppVersion "5.25.1"

#define AppGUID "{8FF3C209-0B67-4E03-BE30-DE970F43BC4C}"

#define AppURL "https://github.com/kfeina/Cygmonit"


[Setup]
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{#AppGUID}
AppName={#AppName}
AppVersion={#AppVersion}-{#CgywinArchitecture}
AppPublisherURL={#AppURL}

UsePreviousAppDir=false
DefaultDirName={autopf64}\{#AppName}\{#CgywinArchitecture}-{#AppVersion}
Uninstallable=true

DefaultGroupName={#AppName}
DisableDirPage=No

OutputDir=..\..\..\InnoSetups
OutputBaseFilename={#AppName}_{#AppVersion}_Setup-{#CgywinArchitecture}
LicenseFile=license.txt

AllowNoIcons=yes
Compression=lzma
SolidCompression=yes
WizardStyle=modern
AlwaysRestart=no 
RestartIfNeededByRun=no
SetupLogging=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; 

[Files]
; Note: I add Attribs: System for every file (*). Why? Cause Cygwin creates link files in many files that Inno loses at compile time. 
; for example: ls -la /etc/crypto-policies/back-ends/openssl.config
; lrwxrwxrwx 1 Administrators None 46 Aug 29 12:44 /etc/crypto-policies/back-ends/openssl.config -> /usr/share/crypto-policies/DEFAULT/openssl.txt
; Not having these attributes result in errors like: openssl ciphers
; 2147483656:error:0E079065:configuration file routines:def_load_bio:missing equal sign:crypto/conf/conf_def.c:407:line 40
; 2147483656:error:140E6118:SSL routines:ssl_cipher_process_rulestr:invalid command:ssl/ssl_ciph.c:1030:
; 2147483656:error:140A90A1:SSL routines:SSL_CTX_new:library has no ciphers:ssl/ssl_lib.c:3091:
; I know this is a brute force solve problem but for now couldn't find easier one. 
Source: "installMonitService.bat"; DestDir: "{app}\Setup"; Flags: ignoreversion; BeforeInstall: StopService('CygMonitSvc')
Source: "removeMonitService.bat"; DestDir: "{app}\Setup"; Flags: ignoreversion
Source: "..\..\..\PRODUCTION\{#CgywinArchitecture}-{#CgywinVersion}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs; Attribs: System


[Icons]
Name: "{autoprograms}\{#AppName}"; Filename: "{app}\Cygwin.bat"
Name: "{autodesktop}\{#AppName}"; Filename: "{app}\Cygwin.bat"; Tasks: desktopicon

[Run]
;Filename: "{app}\bin\bash.exe"; Parameters: "-l -c ""/Setup/buildMonitService.sh"""; Flags: runascurrentuser shellexec waituntilterminated; Description: "This package is self explanatory"
Filename: "{app}\Setup\removeMonitService.bat";  Flags: runascurrentuser shellexec waituntilterminated; Description: "This package is self explanatory"
Filename: "{app}\bin\ash.exe"; Parameters: "-c ""/bin/rebaseall"""; Flags: runascurrentuser shellexec waituntilterminated; Description: "Rebaseall to avoid fork() problems"
Filename: "{app}\Setup\installMonitService.bat";  Flags: runascurrentuser shellexec waituntilterminated; Description: "This package is self explanatory"

[UninstallRun]
Filename: "{sys}\sc.exe"; Parameters: "stop CygMonitSvc"; Flags: runhidden
Filename: "{app}\Setup\removeMonitService.bat";  Flags: runhidden

[Code]
procedure StopService(serviceName: String);
var
    resultCode: Integer;
begin
    Log('Trying sc stop CygMonitSvc');
    Exec(ExpandConstant('sc.exe'), 'stop' + ' ' + serviceName, '', SW_HIDE, ewWaitUntilTerminated, resultCode);    
end;