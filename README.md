# CygMonit - Monit for Windows

** CygMonit is a port of monit for Windows.**

Find the latest release here:

[Latest Version - CygMonit 5.34 (x64)](https://github.com/kfeina/CygMonit/releases/download/Monit-5.34.0(x64)-for-Windows/CygMonit_5.34.0_Setup-x64.exe)

## Installation instructions:

**Download and install** 

![license](./png/license.png "Accept License") \
![folder](./png/folder.png "Install Folder") \
![menu](./png/menu.png "Menu Folder") \
![shortcut](./png/shortcut.png "Create desktop shortcut") \
![install](./png/install.png "Install") \
![finish](./png/finish.png "Finish")

Acces monit through the broswer. 

**https//localhost:2812**
user: admin
password: CygMonit

For versions older than 5.25.1 type:
**http//localhost:2812**
user: admin
password: CygMonit


![localhost](./png/localhost.png "Browser Access")


Check Monit is installed and that a new service **CygMonitSvc** is created
 
![service](./png/service.png "CygMonit Service")


**Configuration** 

The fastest way to configure CygMonit is to start CygMonit bash and use vim. Edit any monit file you need, as no problem permissions arise. The restart the service:

`/bin/cygrunsrv --stop CygMonitSvc`\
`/bin/cygrunsrv --start CygMonitSvc`


Ohterwise use a unix compatible editor like **Notepad++** (or the included VIM). 

As Cygmonit is executed as **LocalSystem**, you won't have permissions to modify the main /etc/monitrc file. 

First you will have to execute the following:


Start the CygMonit bash application. 

![start](./png/start.png "CygMonit bash")\


Stop the service manually with: 

`/bin/cygrunsrv --stop CygMonitSvc`


Execute:

`chown Administrator /usr/local/bin/monit.exe`\
`chown Administrator /etc/monitrc`\
`chown Administrator /usr/ssl/certs/monit.pem`


Now you can edit /etc/monitrc with Notepad++ and configure it as you need. 

For example add your M/Monit instance (set mmonit https://monit:monit@192.168.1.10:8443/collector)

Once finished, before starting **CygMonitSvc** remember to undo your changes:

`chown SYSTEM /usr/local/bin/monit.exe`\
`chown SYSTEM /etc/monitrc`\
`chown SYSTEM /usr/ssl/certs/monit.pem`

Start the service manually with: 

`/bin/cygrunsrv --start CygMonitSvc`

Find log information of the service in: 

/var/log/CygMonitSvc.log



**Older releases**

[CygMonit 5.33 (x64)](https://github.com/kfeina/CygMonit/releases/download/Monit-5.33.0(x64)-for-Windows/CygMonit_5.33.0_Setup-x64.exe)\
[CygMonit 5.25.1 (x64)](https://github.com/kfeina/CygMonit/releases/download/Monit-5.25.1(x64)-for-Windows/CygMonit_5.25.1_Setup-x64.exe)\
[CygMonit 5.25.1 (x86)](https://github.com/kfeina/CygMonit/releases/download/Monit-5.25.1-for-Windows/CygMonit_5.25.1_Setup-x86.exe)\
[CygMonit 5.14 (x86)](https://github.com/kfeina/CygMonit/releases/download/Monit-5.14-for-Windows/CygMonit_5.14_Setup-x86.exe)\
[CygMonit 5.10 (x86)](https://github.com/kfeina/CygMonit/releases/download/Monit-5.10-for-Windows/CygMonit_5.10_Setup-x86.exe)


**Developer info**

To create de development environments, I followed the latest cygwin.dll branch version by the latest setup version, which criteria is found in: 
http://ctm.crouchingtigerhiddenfruitbat.org/pub/cygwin/circa/

