#! /bin/sh

##############################################################################
# Created by: KPorta 
# On Date: 1/12/2014
# License: GPL v3
##############################################################################

USER="DOMAIN\SAM"
RIGHT="SeServiceLogonRight" 

OK="#OK: The $USER has the right: $RIGHT "
KO="#KO: The $USER doesn't have the right: $RIGHT"
ERROR="#ERROR: editrights program error; Check if user exists on local SAM: editrights -u $USER -l or Consult Sys Admin"
ERROREC="#ERROR: Exit Value not Coded"

RESULT=`editrights -u $USER -t $RIGHT; echo $?`
#Return values:    0 - Success or YES. 1 - Error.  2 NO.

if [ $RESULT -eq 0 ]; then 
	echo $OK
elif [ $RESULT -eq 1 ]; then 
	echo $ERROR
elif [ $RESULT -eq 2 ]; then 
	echo $KO 
	. ./checkPolicy.sh "$USER"	#Check if policy is applied.
	. ./mail.sh "$KO" 
else
	echo $ERROREC
fi

