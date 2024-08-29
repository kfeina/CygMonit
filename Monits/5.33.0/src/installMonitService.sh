#! /bin/sh
set -e #"set -e" in the main script causes any function returning 1 (or exiting with it) to abort the whole execution

##############################################################################
# Created by: KPorta
# On Date: 1/12/2014
# License: GPL v3
##############################################################################

##############################################################################
#GLOBAL VARIABLES:


##############################################################################
# Note that owner permissions will be System and that home\SYSTEM (monit.id) will be created!
/bin/chown System /usr/local/bin/monit.exe
/bin/chown System /etc/monitrc
/bin/chmod 0700 /usr/local/bin/monit.exe
/bin/chmod 0700 /etc/monitrc

/bin/cygrunsrv -Q CygMonitSvc && /bin/cygrunsrv --remove CygMonitSvc
/bin/cygrunsrv --install CygMonitSvc --path /bin/bash.exe --args '--login -c /usr/local/bin/monit.exe' --interactive --nohide --desc "Cygwin Monit Service Daemon" 
/bin/cygrunsrv --start CygMonitSvc