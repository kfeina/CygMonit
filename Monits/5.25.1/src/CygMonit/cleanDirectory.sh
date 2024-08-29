#! /bin/sh
set -e #"set -e" in the main script causes any function returning 1 (or exiting with it) to abort the whole execution

##############################################################################
# Created by: KPorta
# On Date: 1/12/2014
# License: GPL v3
##############################################################################

##############################################################################
#GLOBAL VARIABLES:
_HEADER="##############################################################################"
_DIRECTORY_NAME="$1"
_OLDER_THAN="$2"
_EXTRA_PARAM="$3"
_START_DATE=`/usr/bin/date`

_PARAMS_KO="#ERROR: We need at least one parameter. \$1=_DIRECTORY_NAME"
_USAGE01="#USAGE: $0 _DIRECTORY_NAME (_OLDER_THAN). Don't use spaces in directories, use 8+3 notation!"
_USAGE02="#EXAMPLE: ./cleanDirectory.sh /cygdrive/c/WINDOWS/system32/spool/PRINTERS"
_USAGE03="#EXAMPLE: ./cleanDirectory.sh /cygdrive/c/WINDOWS/system32/spool/PRINTERS +8"

_OK="Some Files has been deleted."
_KO="Some error has occurred or there are no files to delete."
_ERROREV="#ERROR: Exit Value not Coded"
_EXIT_VALUE=0


##############################################################################
function fPrepare(){
	CLEANED_DIRECTORY=`/usr/bin/echo "$_DIRECTORY_NAME" | /usr/bin/tr / _ `
    ATTACHMENT_FILE=/tmp/"$CLEANED_DIRECTORY".attach

    if [ -e "$ATTACHMENT_FILE" ]; then
        /usr/bin/rm "$ATTACHMENT_FILE" -f
    fi

    /usr/bin/echo "$_HEADER" > "$ATTACHMENT_FILE"
    /usr/bin/echo "$_STARTDATE - New ATTACHMENT_FILE: $ATTACHMENT_FILE" >> "$ATTACHMENT_FILE"
	/usr/bin/echo "Command executed: "$0" "$@"" >> "$ATTACHMENT_FILE"
}

function fParameters(){
    if ! [ -z "$_EXTRA_PARAM" ]  || [ "$_ACTION" == "--help" ] ; then
        /usr/bin/echo "$_HEADER"
        /usr/bin/echo "$_PARAMS_KO"
        /usr/bin/echo "$_USAGE01"
        /usr/bin/echo "$_USAGE02"
        /usr/bin/echo "$_USAGE03"
        /usr/bin/echo "$_HEADER"
        _EXIT_VALUE=1
        fExit
    fi

    if [ -z "$_DIRECTORY_NAME" ]; then
        /usr/bin/echo "$_HEADER"
        /usr/bin/echo "$_PARAMS_KO"
        /usr/bin/echo "$_USAGE01"
        /usr/bin/echo "$_USAGE02"
        /usr/bin/echo "$_USAGE03"
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
function fCleanDirectory(){ #http://www.unix.com/unix-for-advanced-and-expert-users/162080-find-files-older-than-30-days-old.htm

	if [ -z $_OLDER_THAN ]; then
			OLD_DAYS="" #To delete files older than today use -mtime +0 , -mtime +1 deletes older than last 48 hours!
	else
			OLD_DAYS="-mtime $_OLDER_THAN"
	fi

	/usr/bin/echo "$_HEADER" >> "$ATTACHMENT_FILE"
	RESULT=`/usr/bin/find "$_DIRECTORY_NAME" -type f $OLD_DAYS -delete; echo $?`
		if [ $RESULT -eq 0 ]; then
			/usr/bin/echo "$_OK"
			/usr/bin/echo "$_OK" >> "$ATTACHMENT_FILE"
			_EXIT_VALUE=0
		elif [ $RESULT -eq 1 ]; then
			/usr/bin/echo "$_KO"
			/usr/bin/echo "$_KO" >> "$ATTACHMENT_FILE"
			_EXIT_VALUE=1
		else
			/usr/bin/echo "$_ERROREV: $RESULT"
			_EXIT_VALUE=2
		fi
}


##############################################################################
#MAIN:

main(){
	fPrepare "$_DIRECTORY_NAME" "$_OLDER_THAN" #Prepare out log files
	fParameters "$_DIRECTORY_NAME" "$_OLDER_THAN" #Check parameters
	fCleanDirectory "$_DIRECTORY_NAME" "$_OLDER_THAN" #Clean Directory Service
	fExit $_EXIT_VALUE
}

main "$_DIRECTORY_NAME" "$_OLDER_THAN"

