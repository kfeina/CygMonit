#! /bin/sh
set -e #"set -e" in the main script causes any function returning 1 (or exiting with it) to abort the whole execution
##############################################################################
# Created by: KPorta
# On Date: 1/12/2014
# License: GPL v3
##############################################################################

##############################################################################
function fPrepare(){
	if [ -e $EXIT_VALUE_FILE ]; then
		/usr/bin/rm $EXIT_VALUE_FILE -f
		/usr/bin/echo "OlD EXIT_VALUE_FILE=$EXIT_VALUE_FILE removed"
	else
		/usr/bin/echo "OlD EXIT_VALUE_FILE=$EXIT_VALUE_FILE doesn't exist. It should."
		/usr/bin/echo $HEADER
	fi

}
##############################################################################
#RESULT=`editrights -u $USER -t $RIGHT; echo $?`

function fQuery(){
	if [ -e $MONIT_LOG ]; then
		/usr/bin/rm $MONIT_LOG;
		/usr/bin/echo $HEADER >> $MONIT_LOG
		/usr/bin/echo "New Monit File; The last monit.log was to big. monitReload.sh executed" >> $MONIT_LOG
		/usr/bin/echo $HEADER >> $MONIT_LOG
		/usr/bin/echo 0 > $EXIT_VALUE_FILE
	else
		/usr/bin/echo $HEADER >> $MONIT_LOG
		/usr/bin/echo "New Monit File %START_DATE%; monitReload.sh executed" >> $MONIT_LOG
		/usr/bin/echo 9 > $EXIT_VALUE_FILE
	fi

	/usr/local/bin/monit reload

}

function fExit(){ #exit $? We get the exit value needed by monit.
	if [ -e $EXIT_VALUE_FILE ]; then
		EXIT_VALUE=`/usr/bin/cat $EXIT_VALUE_FILE`
		echo "EXIT_VALUE = $EXIT_VALUE"
	fi
	if [ -z $EXIT_VALUE ]; then
		echo $ERROREV
		exit 1
	else
		exit $EXIT_VALUE
	fi
}


##############################################################################
#MAIN:
HEADER="##############################################################################"
ERROREV="#ERROR: Exit Value not Coded"
START_DATE=`/usr/bin/date`
SLEEP_TIME=1
MONIT_LOG="/var/log/monit.log"
EXIT_VALUE_FILE=/tmp/monitReload.ev
main(){
	fPrepare #Prepare output fiels $ATTACHMENT_FILE ...
	fQuery 	#Check Service
	fExit
}

main

