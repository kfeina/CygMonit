This is the CygMonit development project

This project compiles Monit with cygwin, and wraps everything with an installable setup.exe (created with Inno) plus an automated Monit service install. 

Once installed, a new service called CygMonitSvc will be created and monit will run on your windows platform. 
Try it with https://localhost:2812, user: admin, pwd: CygMonit

You will also have a cygiwn bash environement ready shortcut.

To install CygMonit download from InnoSetups folder your preferred monit version. 

Available versions: 

https://github.com/kfeina/CygMonit/tree/main/InnoSetups/CygMonit_5.14_Setup-x86.exe
https://github.com/kfeina/CygMonit/tree/main/InnoSetups/CygMonit_5.10_Setup-x86.exe


Developer info:
To create de development environments, I followed the latest cygwin.dll branch version by the latest setup version, where criteria is found in: 
http://ctm.crouchingtigerhiddenfruitbat.org/pub/cygwin/circa/

