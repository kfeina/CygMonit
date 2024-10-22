; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

; https://github.com/Bill-Stewart/UninsIS/blob/main/UninsIS-Sample.iss
#if Ver < EncodeVer(6,0,0,0)
  #error This script requires Inno Setup 6 or later
#endif

#define CgywinVersion "3.3.6.1"
#define CgywinArchitecture "x86"

#define AppName "CygMonit"
#define AppVersion "5.25.1"

#define AppGUID "{260E52AA-CE7E-43CD-B211-37F3B38F278D}"

#define AppURL "https://github.com/kfeina/Cygmonit"


[Setup]
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{#AppGUID}
AppName={#AppName}
AppVersion={#AppVersion}
AppPublisherURL={#AppURL}

UsePreviousAppDir=false
DefaultDirName={autopf}\{#AppName}\{#AppVersion}
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
; https://github.com/Bill-Stewart/UninsIS UninsIS.dll is a Windows DLL (dynamically linked library) to facilitate detection and uninstallation of applications installed by Inno Setup 6 and later.
;Flags: dontcopy
Source: "UninsIS-1.5.0\i386\UninsIS.dll"; DestDir: {app} 

Source: "..\..\..\PRODUCTION\{#CgywinArchitecture}-{#CgywinVersion}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

Source: "installMonitService.bat"; DestDir: "{app}\Setup"; Flags: ignoreversion
Source: "removeMonitService.bat"; DestDir: "{app}\Setup"; Flags: ignoreversion

[Icons]
Name: "{autoprograms}\{{AppName}"; Filename: "{app}\Cygwin.bat"
Name: "{autodesktop}\{{AppName}"; Filename: "{app}\Cygwin.bat"; Tasks: desktopicon

[Run]
;Filename: "{app}\bin\bash.exe"; Parameters: "-l -c ""/Setup/buildMonitService.sh"""; Flags: runascurrentuser shellexec waituntilterminated; Description: "This package is self explanatory"
Filename: "{app}\Setup\removeMonitService.bat";  Flags: runascurrentuser shellexec waituntilterminated; Description: "This package is self explanatory"
Filename: "{app}\Setup\installMonitService.bat";  Flags: runascurrentuser shellexec waituntilterminated; Description: "This package is self explanatory"

[UninstallRun]
Filename: "{sys}\sc.exe"; Parameters: "stop CygMonitSvc"; Flags: runhidden
Filename: "{app}\Setup\removeMonitService.bat";  Flags: runhidden


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
[Code]
// Import IsISPackageInstalled() function from UninsIS.dll at setup time
function DLLIsISPackageInstalled(AppId: string; Is64BitInstallMode,
  IsAdminInstallMode: DWORD): DWORD;
  external 'IsISPackageInstalled@files:UninsIS.dll stdcall setuponly';

// Import CompareISPackageVersion() function from UninsIS.dll at setup time
function DLLCompareISPackageVersion(AppId, InstallingVersion: string;
  Is64BitInstallMode, IsAdminInstallMode: DWORD): Integer;
  external 'CompareISPackageVersion@files:UninsIS.dll stdcall setuponly';

// Import GetISPackageVersion() function from UninsIS.dll at setup time
function DLLGetISPackageVersion(AppId, Version: string;
  NumChars, Is64BitInstallMode, IsAdminInstallMode: DWORD): DWORD;
  external 'GetISPackageVersion@files:UninsIS.dll stdcall setuponly';

// Import UninstallISPackage() function from UninsIS.dll at setup time
function DLLUninstallISPackage(AppId: string; Is64BitInstallMode,
  IsAdminInstallMode: DWORD): DWORD;
  external 'UninstallISPackage@files:UninsIS.dll stdcall setuponly';

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Wrapper for UninsIS.dll IsISPackageInstalled() function
// Returns true if package is detected as installed, or false otherwise
function IsISPackageInstalled(): Boolean;
begin
  result := DLLIsISPackageInstalled('{#AppGUID}',  // AppId
    DWORD(Is64BitInstallMode()),                   // Is64BitInstallMode
    DWORD(IsAdminInstallMode())) = 1;              // IsAdminInstallMode
  if result then
    Log('UninsIS.dll - Package detected as installed')
  else
    Log('UninsIS.dll - Package not detected as installed');
end;

// Wrapper for UninsIS.dll GetISPackageVersion() function
function GetISPackageVersion(): string;
var
  NumChars: DWORD;
  OutStr: string;
begin
  result := '';
  // First call: Get number of characters needed for version string
  NumChars := DLLGetISPackageVersion('{#AppGUID}',  // AppId
    '',                                             // Version
    0,                                              // NumChars
    DWORD(Is64BitInstallMode()),                    // Is64BitInstallMode
    DWORD(IsAdminInstallMode()));                   // IsAdminInstallMode
  // Allocate string to receive output
  SetLength(OutStr, NumChars);
  // Second call: Get version number string
  if DLLGetISPackageVersion('{#AppGUID}',  // AppID
    OutStr,                                // Version
    NumChars,                              // NumChars
    DWORD(Is64BitInstallMode()),           // Is64BitInstallMode
    DWORD(IsAdminInstallMode())) > 0 then  // IsAdminInstallMode
  begin
    result := OutStr;
  end;
end;

// Wrapper for UninsIS.dll CompareISPackageVersion() function
// Returns:
// < 0 if version we are installing is < installed version
// 0   if version we are installing is = installed version
// > 0 if version we are installing is > installed version
function CompareISPackageVersion(): Integer;
begin
  result := DLLCompareISPackageVersion('{#AppGUID}',  // AppId
    '{#AppVersion}',                                  // InstallingVersion
    DWORD(Is64BitInstallMode()),                      // Is64BitInstallMode
    DWORD(IsAdminInstallMode()));                     // IsAdminInstallMode
  if result < 0 then
    Log('UninsIS.dll - This version {#AppVersion} older than installed version')
  else if result = 0 then
    Log('UninsIS.dll - This version {#AppVersion} same as installed version')
  else
    Log('UninsIS.dll - This version {#AppVersion} newer than installed version');
end;

// Wrapper for UninsIS.dll UninstallISPackage() function
// Returns 0 for success, non-zero for failure
function UninstallISPackage(): DWORD;
begin
  result := DLLUninstallISPackage('{#AppGUID}',  // AppId
    DWORD(Is64BitInstallMode()),                 // Is64BitInstallMode
    DWORD(IsAdminInstallMode()));                // IsAdminInstallMode
  if result = 0 then
    Log('UninsIS.dll - Installed package uninstall completed successfully')
  else
    Log('UninsIS.dll - installed package uninstall did not complete successfully');
end;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function PrepareToInstall(var NeedsRestart: Boolean): string;
var
  Version: string;
begin
  result := '';
  if IsISPackageInstalled() then
  begin
    Version := GetISPackageVersion();
    MsgBox('Package installed; version = ' + Version, mbInformation, MB_OK);
  end;
  // If package installed, uninstall it automatically if the version we are
  // installing does not match the installed version; If you want to
  // automatically uninstall only...
  // ...when downgrading: change <> to <
  // ...when upgrading:   change <> to >
  //I uninstall if installed even the same version cause is not possible to overwrite cygwin.dll's. So I always overwrite! Cautin: everything will be lost
  //if IsISPackageInstalled() and (CompareISPackageVersion() <> 0) then
  if IsISPackageInstalled() then	
    UninstallISPackage();
end;