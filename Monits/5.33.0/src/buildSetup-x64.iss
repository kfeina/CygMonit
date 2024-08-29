; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define CgywinVersion "3.4.10.1"
#define CgywinArchitecture "x64"

#define AppName "CygMonit"
#define AppVersion "5.33.0"

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
Source: "..\..\..\PRODUCTION\{#CgywinArchitecture}-{#CgywinVersion}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "installMonitService.bat"; DestDir: "{app}\Setup"; Flags: ignoreversion
Source: "removeMonitService.bat"; DestDir: "{app}\Setup"; Flags: ignoreversion

[Icons]
Name: "{autoprograms}\{#AppName}"; Filename: "{app}\Cygwin.bat"
Name: "{autodesktop}\{#AppName}"; Filename: "{app}\Cygwin.bat"; Tasks: desktopicon

[Run]
;Filename: "{app}\bin\bash.exe"; Parameters: "-l -c ""/Setup/buildMonitService.sh"""; Flags: runascurrentuser shellexec waituntilterminated; Description: "This package is self explanatory"
Filename: "{app}\Setup\removeMonitService.bat";  Flags: runascurrentuser shellexec waituntilterminated; Description: "This package is self explanatory"
Filename: "{app}\Setup\installMonitService.bat";  Flags: runascurrentuser shellexec waituntilterminated; Description: "This package is self explanatory"

[UninstallRun]
Filename: "{sys}\sc.exe"; Parameters: "stop CygMonitSvc"; Flags: runhidden
Filename: "{app}\Setup\removeMonitService.bat";  Flags: runhidden

