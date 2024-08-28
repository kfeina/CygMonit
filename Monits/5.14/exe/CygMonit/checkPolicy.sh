#! /bin/sh
# set -vx

##############################################################################
# Created by: KPorta 
# On Date: 1/12/2014
# License: GPL v3
##############################################################################

#Check if $1 is null: no user passed as parameter.
if [ "x$1" == "x" ]; then USER="$USERNAME"  
else USER="$1"; fi

POLICY="ServiceLogonRight" #Policy setting to search. 
POLICY_LOG="checkPolicy.log"

OK="#OK: The $POLICY has been found on the User Policies"
KO="#KO: The $POLICY has not been found on the User Policies !!!"
ERROR="#ERROR: gpresult program error; Consult Sys Admin"
ERROREC="#ERROR: Exit Value not Coded"

echo "Processing gpresult ..."
RESULT=`gpresult /USER "$USER" /z | grep -i $POLICY -B 1 -A 2`
RESULT_COUNT=`gpresult /USER "$USER" /z | grep -i $POLICY -B 1 -A 2 | wc -l`
#Return values: 0 - Policy not found, >0 Policy found (Word Count). 

if [ $RESULT_COUNT -eq 0 ]; then #Policy not found
	ATTACHMENT="checkPolicy.log"
	if [ -f "$POLICY_LOG" ]; then rm $POLICY_LOG; fi
	
elif [ $RESULT_COUNT -gt 1 ]; then #Policy found, we log
	echo "##############################################################################"
	echo "$OK" 
	echo "$OK" > $POLICY_LOG
	echo `date` >> $POLICY_LOG	
	echo "$RESULT" >> $POLICY_LOG
	echo "##############################################################################"	
else
	echo $ERROREC
fi

