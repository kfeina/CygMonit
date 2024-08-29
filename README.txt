# This is the CygMonit development project

This project compiles Monit with Cygwin, and wraps everything with an installable setup.exe package (created with InnoSetup) plus an automated **Monit Service** installer. 

Once installed, a new service called **CygMonitSvc** will be created and monit will run as a service in your windows platform. 
Try it with https://localhost:2812, user: admin, pwd: CygMonit

You will also have a cygiwn bash environement ready shortcut.

To **install** CygMonit download from **InnoSetups folder** your preferred monit version. 

[Download CygMonit_5.25.1_Setup-x64.exe](https://github.com/kfeina/CygMonit/tree/main/InnoSetups/CygMonit_5.25.1_Setup-x64.exe)
[CygMonit_5.25.1_Setup-x86.exe](https://github.com/kfeina/CygMonit/tree/main/InnoSetups/CygMonit_5.25.1_Setup-x86.exe)
[CygMonit_5.14_Setup-x86.exe](https://github.com/kfeina/CygMonit/tree/main/InnoSetups/CygMonit_5.14_Setup-x86.exe)
[CygMonit_5.10_Setup-x86.exe](https://github.com/kfeina/CygMonit/tree/main/InnoSetups/CygMonit_5.10_Setup-x86.exe)


Developer info:
To create de development environments, I followed the latest cygwin.dll branch version by the latest setup version, where criteria is found in: 
http://ctm.crouchingtigerhiddenfruitbat.org/pub/cygwin/circa/

