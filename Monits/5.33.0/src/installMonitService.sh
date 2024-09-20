#! /bin/sh

##############################################################################
# Created by: KPorta
# On Date: 1/12/2014
# License: GPL v3
##############################################################################

##############################################################################
#GLOBAL VARIABLES:


##############################################################################
/cygdrive/c/Windows/system32/SC.exe stop CygMonitSvc && /cygdrive/c/Windows/system32/SC.exe delete CygMonitSvc

/usr/bin/sleep 5
/bin/chown `whoami` /usr/local/bin/monit.exe

#/bin/cygrunsrv --install CygMonitSvc --path /bin/bash.exe --args '--login -c /usr/local/bin/monit.exe -v' --nohide --desc "Cygwin Monit Service Daemon" 
/bin/cygrunsrv --install CygMonitSvc --neverexits --path /usr/local/bin/monit.exe --args '-v' --nohide --desc "Cygwin Monit Service Daemon" 

/cygdrive/c/Windows/system32/SC.exe failure CygMonitSvc actions= restart/60000ms/restart/60000/restart/60000ms// reset= 0

/bin/chown System /usr/local/bin/monit.exe
/bin/chown System /etc/monitrc
/bin/chmod 0700 /usr/local/bin/monit.exe
/bin/chmod 0700 /etc/monitrc

/bin/chown System /usr/ssl/certs/monit.pem
/bin/chmod 0700 /usr/ssl/certs/monit.pem

/cygdrive/c/Windows/system32/SC.exe start CygMonitSvc