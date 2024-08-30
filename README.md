# CygMonit - Monit for Windows

CygMonit is a port of monit for Windows. Ready to use, as it comes with an installer. 

Find the latest release here:

[Latest Version - CygMonit 5.34 (x64)](https://github.com/kfeina/CygMonit/releases/download/Monit-5.34.0(x64)-for-Windows/CygMonit_5.34.0_Setup-x64.exe)

## Installation instructions:

**Download and install** 

![license](./png/license.png "Accept License") \
![folder](./png/folder.png "Install Folder") \
![menu](./png/menu.png "Menu Folder") \
![shortcut](./png/shortcut.png "Create desktop shortcut") \
![install](./png/install.png "Install") \
![finish](./png/finish.png "Finish") \

Acces monit through the broswer. 

https//localhost:2812
user: admin
password: CygMonit

![localhost](./png/localhost.png "Browser Access") \


Monit is working an new service called **CygMonitSvc** has been created: 
![service](./png/service.png "CygMonit Service") \






It comes with two feautures: 


CygMonit includes an installable setup.exe package. 



This project compiles Monit with Cygwin, and wraps everything with an installable setup.exe package (created with InnoSetup) plus an automated **Monit Service** installer. 

Once installed, a new service called **CygMonitSvc** will be created and monit will run as a service in your windows platform. 
Try it with https://localhost:2812, user: admin, pwd: CygMonit

You will also have a cygiwn bash environement ready shortcut.

To **install** CygMonit download the latest monit version: 

[Latest Version - CygMonit 5.34 (x64)](https://github.com/kfeina/CygMonit/releases/download/Monit-5.34.0(x64)-for-Windows/CygMonit_5.34.0_Setup-x64.exe)

Older releases: 

[CygMonit 5.33 (x64)](https://github.com/kfeina/CygMonit/releases/download/Monit-5.33.0(x64)-for-Windows/CygMonit_5.33.0_Setup-x64.exe)\
[CygMonit 5.25.1 (x64)](https://github.com/kfeina/CygMonit/releases/download/Monit-5.25.1(x64)-for-Windows/CygMonit_5.25.1_Setup-x64.exe)\
[CygMonit 5.25.1 (x86)](https://github.com/kfeina/CygMonit/releases/download/Monit-5.25.1-for-Windows/CygMonit_5.25.1_Setup-x86.exe)\
[CygMonit 5.14 (x86)](https://github.com/kfeina/CygMonit/releases/download/Monit-5.14-for-Windows/CygMonit_5.14_Setup-x86.exe)\
[CygMonit 5.10 (x86)](https://github.com/kfeina/CygMonit/releases/download/Monit-5.10-for-Windows/CygMonit_5.10_Setup-x86.exe)\


Developer info:
To create de development environments, I followed the latest cygwin.dll branch version by the latest setup version, where criteria is found in: 
http://ctm.crouchingtigerhiddenfruitbat.org/pub/cygwin/circa/



Older releases: 
[CygMonit 5.33 (x64)](https://github.com/kfeina/CygMonit/releases/download/Monit-5.33.0(x64)-for-Windows/CygMonit_5.33.0_Setup-x64.exe)

[CygMonit 5.25.1 (x64)](https://github.com/kfeina/CygMonit/releases/download/Monit-5.25.1(x64)-for-Windows/CygMonit_5.25.1_Setup-x64.exe)

[CygMonit 5.25.1 (x86)](https://github.com/kfeina/CygMonit/releases/download/Monit-5.25.1-for-Windows/CygMonit_5.25.1_Setup-x86.exe)

[CygMonit 5.14 (x86)](https://github.com/kfeina/CygMonit/releases/download/Monit-5.14-for-Windows/CygMonit_5.14_Setup-x86.exe)

[CygMonit 5.10 (x86)](https://github.com/kfeina/CygMonit/releases/download/Monit-5.10-for-Windows/CygMonit_5.10_Setup-x86.exe)
