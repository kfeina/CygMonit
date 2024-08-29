#! /bin/sh
set -e #"set -e" in the main script causes any function returning 1 (or exiting with it) to abort the whole execution

##############################################################################
# Created by: KPorta
# On Date: 1/12/2014
# License: GPL v3
##############################################################################

##############################################################################
#GLOBAL VARIABLES:
_ACTION="$1"
_SERVICE_NAME="$2"
_BINARY_NAME="$3"
_EXTRA_PARAM="$4"

_PARAMS_KO="#ERROR: We need three parameters only. \$1=_ACTION and \$2=_SERVICE_NAME \$3=_BINARY_NAME"
_USAGE="#USAGE: $0 _ACTION={query|start|stop|restart} _SERVICE_NAME _BINARY_NAME; For example: $0 start spooler spoolsv.exe"

_HEADER="##############################################################################"

_STARTED="The service is started."
_STOPPED="The service is stopped."
_START="Starting the service  ..."
_STOP="Stopping the service ..."
_RESTART="Restarting the service (stop & start):"

_STARTDATE=`/usr/bin/date`
_SLEEPTIME=3

_ERROREV="#ERROR: Exit Value not Coded"
_ERROR_STOP="#ERROR: Some error has happened when stopping ... We exit".
_ERROR_START="#ERROR: Some error has happened when starting... We exit".
_EXIT_VALUE=0

##############################################################################
function fPrepare(){
    WINPID_FILE=/tmp/"$_SERVICE_NAME".pid
    ATTACHMENT_FILE=/tmp/"$_SERVICE_NAME".attach

    if [ -e "$ATTACHMENT_FILE" ]; then
        /usr/bin/rm "$ATTACHMENT_FILE" -f
    fi

    if [ -e "$WINPID_FILE" ]; then
        /usr/bin/rm "$WINPID_FILE" -f
    fi

    /usr/bin/echo "$_HEADER" > "$ATTACHMENT_FILE"
    /usr/bin/echo "$_STARTDATE - New ATTACHMENT_FILE: "$ATTACHMENT_FILE"" >> "$ATTACHMENT_FILE"
    /usr/bin/echo "Command executed: "$0" "$@"" >> "$ATTACHMENT_FILE"
}

function fParameters(){
    if ! [ -z "$_EXTRA_PARAM" ]  || [ "$_ACTION" == "--help" ] ; then
        /usr/bin/echo "$_HEADER"
        /usr/bin/echo "$_PARAMS_KO"
        /usr/bin/echo "$_USAGE"
        /usr/bin/echo "$_HEADER"
        _EXIT_VALUE=1
        fExit
    fi

    if [ -z "$_ACTION" ] || [ -z "$_SERVICE_NAME" ] || [ -z "$_BINARY_NAME" ]; then
        /usr/bin/echo "$_HEADER"
        /usr/bin/echo "$_PARAMS_KO"
        /usr/bin/echo "$_USAGE"
        /usr/bin/echo "$_HEADER"
        _EXIT_VALUE=1
        fExit
    fi
}

function fExit(){ #exit $? We get the exit value needed by monit.
    if [ -z $_EXIT_VALUE ]; then
        /usr/bin/echo "$_ERROREV" >> "$ATTACHMENT_FILE"
        /usr/bin/echo "$_HEADER" >> "$ATTACHMENT_FILE"
        _EXIT_VALUE=1
        exit $_EXIT_VALUE
    else
        /usr/bin/echo "$_HEADER" >> "$ATTACHMENT_FILE"
        exit $_EXIT_VALUE
    fi
}

##############################################################################
function fRestart(){
    /usr/bin/echo "$_RESTART"
    /usr/bin/echo "$_RESTART" >> "$ATTACHMENT_FILE"
    fStop
    fStart
}

function fStop(){
    fQuery "$_SERVICE_NAME"
    if [ "$RESULT_QUERY" != "Stopped" ]; then
        /usr/bin/echo "$_STOP"
        /usr/bin/echo "$_STOP" >> "$ATTACHMENT_FILE"
        /usr/bin/cygrunsrv --stop "$_SERVICE_NAME" &&
        (
            /usr/bin/sleep "$_SLEEPTIME"
        )                                       ||
        (
            /usr/bin/echo "$_ERROR_STOP; Try: /usr/bin/cygrunsrv --stop "$_SERVICE_NAME"" >> "$ATTACHMENT_FILE"
        )
    fQuery "$_SERVICE_NAME" #We update _EXIT_VALUE (the status must be changed to stopped")
    fi
}

function fStart(){
    fQuery "$_SERVICE_NAME"
    if [ "$RESULT_QUERY" != "Running" ]; then
        /usr/bin/echo "$_START"
        /usr/bin/echo "$_START" >> "$ATTACHMENT_FILE"
        /usr/bin/cygrunsrv --start "$_SERVICE_NAME" &&
        (
            /usr/bin/sleep "$_SLEEPTIME"
            fGetWPID
        )                                       ||
        (
            /usr/bin/echo "$_ERROR_START; Try: /usr/bin/cygrunsrv --start "$_SERVICE_NAME"" >> "$ATTACHMENT_FILE"
        )
    fQuery "$_SERVICE_NAME" #We update _EXIT_VALUE (the status must be changed to running")
    fi
}

function fGetWPID(){
    RESULT_WPID=`/usr/bin/ps -W | /usr/bin/grep -i "$_BINARY_NAME" | /usr/bin/awk '{print $4}'`
    RESULT_WPID=${RESULT_WPID//[[:blank:]]/} #Removing leading and traling spaces (trim) -> /usr/bin/echo "fGetWPID RESULT_WPID=x-$RESULT_WPID-x"

    if [ -z $RESULT_WPID ]; then
        WINPID_KO="#ERROR: WINPID is null. Some problem has occurred. Try: /usr/bin/ps -W | /usr/bin/grep -i \"$_BINARY_NAME\" | /usr/bin/awk '{print $4}'"
        /usr/bin/echo "$WINPID_KO"
        /usr/bin/echo "$WINPID_KO" >> "$ATTACHMENT_FILE"
    else
        /usr/bin/echo "The new WINPID is: $RESULT_WPID"
        /usr/bin/echo "The new WINPID is: $RESULT_WPID" >> "$ATTACHMENT_FILE"
    fi
}

function fQuery(){
    RESULT_QUERY=`/usr/bin/cygrunsrv --query "$_SERVICE_NAME" | /usr/bin/grep -a -i "State" | /usr/bin/cut -d ':' -f2`
    RESULT_QUERY=${RESULT_QUERY//[[:blank:]]/} #Removing leading and traling spaces (trim) -> /usr/bin/echo "fQuery RESULT_QUERY=x-$RESULT_QUERY-x"
    if [ "$RESULT_QUERY" == "Running" ]; then
        /usr/bin/echo "$_STARTED"
        /usr/bin/echo "$_STARTED" >> "$ATTACHMENT_FILE"
        _EXIT_VALUE=0
    elif [ "$RESULT_QUERY" == "Stopped" ]; then
        /usr/bin/echo "$_STOPPED"
        /usr/bin/echo "$_STOPPED" >> "$ATTACHMENT_FILE"
        _EXIT_VALUE=11
    else
        SEVICE_KO="#ERROR: probably the SERVICENAME doesn't exist. Try: /usr/bin/cygrunsrv --query \"$_SERVICE_NAME\""
        /usr/bin/echo "$_HEADER" >> "$ATTACHMENT_FILE"
        /usr/bin/echo "$SERVICE_KO"
        /usr/bin/echo "$SERVICE_KO" >> "$ATTACHMENT_FILE"
        _EXIT_VALUE=12
    fi
}

function fAction(){ #$1 _ACTION , $2 _SERVICE_NAME
    if [ "$_ACTION" == "restart" ]; then #Restart -> Stop & Start
        fRestart "$_SERVICE_NAME"
    elif [ "$_ACTION" == "start" ]; then  #Start
        fStart "$_SERVICE_NAME" "$_BINARY_NAME"
    elif [ "$_ACTION" == "stop" ]; then  #stop
        fStop "$_SERVICE_NAME"
    elif [ "$_ACTION" == "query" ]; then  #stop
        fQuery "$_SERVICE_NAME"
    fi
}


##############################################################################
#MAIN:

main(){
    fPrepare "$_ACTION" "$_SERVICE_NAME" "$_BINARY_NAME" #Prepare out log files
    fParameters "$_ACTION" "$_SERVICE_NAME" "$_BINARY_NAME" "$_EXTRA_PARAM" #Check parameters
    fAction "$_ACTION" "$_SERVICE_NAME" "$_BINARY_NAME" #Do the action
    fExit $_EXIT_VALUE
}

main "$_ACTION" "$_SERVICE_NAME" "$_BINARY_NAME" "$_EXTRA_PARAM"


