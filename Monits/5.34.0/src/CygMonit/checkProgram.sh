#! /bin/sh
set -e #"set -e" in the main script causes any function returning 1 (or exiting with it) to abort the whole execution
##############################################################################
# Created by: KPorta 
# On Date: 1/12/2014
# License: GPL v3
##############################################################################

##############################################################################
function fPrepare(){

	if [ -e $ATTACHMENT_FILE ]; then 
		/usr/bin/rm $ATTACHMENT_FILE -f 
		/usr/bin/echo $HEADER > $ATTACHMENT_FILE
		/usr/bin/echo "OlD ATTACHMENT_FILE removed" >> $ATTACHMENT_FILE	
		/usr/bin/echo "New ATTACHMENT_FILE - $START_DATE - $ATTACHMENT_FILE " >> $ATTACHMENT_FILE
	else 
		/usr/bin/echo $HEADER > $ATTACHMENT_FILE
		/usr/bin/echo "New ATTACHMENT_FILE - $START_DATE - $ATTACHMENT_FILE " >> $ATTACHMENT_FILE	
	fi

	if [ -e $WINPID_FILE ]; then 
		/usr/bin/rm $WINPID_FILE -f >> $ATTACHMENT_FILE 
		/usr/bin/echo "OlD WINPID_FILE removed" >> $ATTACHMENT_FILE	
	else 
		/usr/bin/echo "OlD WINPID_FILE doesn't exist. It should." >> $ATTACHMENT_FILE	
		/usr/bin/echo $HEADER >> $ATTACHMENT_FILE
	fi	
	
	if [ -e $EXIT_VALUE_FILE ]; then 
		/usr/bin/rm $EXIT_VALUE_FILE -f >> $ATTACHMENT_FILE 
		/usr/bin/echo "OlD EXIT_VALUE_FILE=$EXIT_VALUE_FILE removed" >> $ATTACHMENT_FILE	
	else 
		/usr/bin/echo "OlD EXIT_VALUE_FILE=$EXIT_VALUE_FILE doesn't exist. It should." >> $ATTACHMENT_FILE	
		/usr/bin/echo $HEADER >> $ATTACHMENT_FILE
	fi	
	
}
##############################################################################
#RESULT=`editrights -u $USER -t $RIGHT; echo $?`

function fQuery(){
	/usr/bin/ps -W | /usr/bin/grep -i $PROGRAM_NAME | /usr/bin/awk '{print $4}' > $WINPID_FILE
	WINPID=`/usr/bin/cat $WINPID_FILE`
	OK="The $PROGRAM_NAME is started with WINPID:$WINPID"
	KO="The $PROGRAM_NAME is not started. WINPID value should be null. WINPID: $WINPID"
	if [ -z $WINPID ]; then 				
		/usr/bin/echo $HEADER >> $ATTACHMENT_FILE
		/usr/bin/echo "$KO"
		/usr/bin/echo "$KO" >> $ATTACHMENT_FILE
		/usr/bin/echo 9 > $EXIT_VALUE_FILE						
	else 
		/usr/bin/echo $HEADER >> $ATTACHMENT_FILE
		/usr/bin/echo "$OK" 
		/usr/bin/echo "$OK" >> $ATTACHMENT_FILE				
		/usr/bin/echo 0 > $EXIT_VALUE_FILE
	fi				
}

function fExit(){ #exit $? We get the exit value needed by monit.
	if [ -e $EXIT_VALUE_FILE ]; then 
		EXIT_VALUE=`/usr/bin/cat $EXIT_VALUE_FILE`
		echo "EXIT_VALUE = $EXIT_VALUE"
		echo "EXIT_VALUE = $EXIT_VALUE" >> $ATTACHMENT_FILE
	fi
	if [ -z $EXIT_VALUE ]; then
		echo $ERROREV >> $ATTACHMENT_FILE
		exit 1
	else 		
		exit $EXIT_VALUE		
	fi		
}

function fParameters(){ #$1 Action , $2 PROGRAM_NAME
	if [ -z $1 ]; then
		echo "$NO_PARAMS"
		exit 1
	else 
		WINPID_FILE=/tmp/$PROGRAM_NAME.pid
		ATTACHMENT_FILE=/tmp/$PROGRAM_NAME.attach
		EXIT_VALUE_FILE=/tmp/$PROGRAM_NAME.ev
	fi		
}

function fAction(){ #$1 Action , $2 PROGRAM_NAME
#Examples: service.sh start $PROGRAM_NAME, service.sh stop $PROGRAM_NAME, service.sh restart $PROGRAM_NAME
	if [ "$ACTION" == "restart" ]; then #Restart -> Stop & Start
		fRestart $PROGRAM_NAME
	elif [ "$ACTION" == "start" ]; then  #Start		
		fStart $PROGRAM_NAME
	elif [ "$ACTION" == "stop" ]; then  #stop
		fStop $PROGRAM_NAME
	fi		
}
##############################################################################
#MAIN: 
HEADER="##############################################################################"
PROGRAM_NAME=$1
ERROREV="#ERROR: Exit Value not Coded"
NO_PARAMS="#ERROR: We need one parameter. \$1=PROGRAM_NAME"
START_DATE=`/usr/bin/date` 
SLEEP_TIME=1

main(){
	fParameters $PROGRAM_NAME #Check both parameters
	fPrepare #Prepare output fiels $ATTACHMENT_FILE ...
	fQuery $PROGRAM_NAME #Check Service
	fExit
}	


main $PROGRAM_NAME

