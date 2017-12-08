#!/bin/bash

## COPYRIGHT IQUUE 2017 ##
## PRIMARY AUTHOR: FRANK A. LOTURCO ##
## INTENDED FOR USE WITH IQUUE EQUIPMENT ##
## THIS SCRIPT COMES WITH ABSOLUTLY NO WARRANTY ##
## PLEASE REFER TO THE LICENSE FILE FOR MORE INFORMATION ##

#Define Global Vars
package="smtbt"
x=1
currentbat=0
keeprunning=1
debugstatus=0

#Test For Arguments Before Executing Main Logic
while test $# -gt 0
do
	case "$1" in
			-h|--help)
				echo "$package - Test the Battery Usage of Z-Wave Locks"
				echo " "
				echo "$package [options] application [arguments]"
				echo " "
				echo "options:"
				echo "-h, --help                Show this menu."
				echo "-d, --device=DEVICEID     Changes the Device Stressed."
				echo "-b, --battery=TARGET      Changes the Battery Threshold Before Killing the Program."
				echo "--debug                   Toggles The Display of Debug Information."
				exit 0
				;;
			-d)
				shift
				if test $# -gt 0
				then
					export device=$1
				else
					echo "No Device Specified"
					exit 1
				fi
				shift
				;;
			--device*)
				export device=`echo $1 | sed -e 's/^[^=]*=//g'`
				shift
				;;
			-b)
				shift
				if test $# -gt 0;
				then
					export batterythreshold=$1
				else
					echo "No Minimum Battery Threshold Specified"
					exit 1
				fi
				shift
				;;
			--battery*)
				export batterythreshold=`echo $1 | sed -e 's/^[^=]*=//g'`
				shift
				;;
			--debug)
				export debugstatus=1
				shift
				;;
			*)
				break
				;;
	esac
done

#Clear the Screen
clear

#Make Sure Required Variables Exist
if [[ ${device+1} ]]
then
	echo "[INFO] Performing Battery Test on Device: $device"
else
	echo "[ERROR] Missing DeviceID, use the -h or --help Argument for Help."
	exit 2
fi

if [[ ${batterythreshold+1} ]]
then
	echo "[INFO] Program Will Terminate Upon Reaching $batterythreshold% Battery Remaining"
else
	echo "[ERROR] Missing Minimum Battery Threshold, use the -h or --help Argument for Help."
	exit 2
fi

if [[ ${debugstatus+1} ]]
then
	echo "[INFO] Debugging is Enabled Debug Information Will be Prefixed With [DEBUG]"
fi

# Divide Output for Easier Viewing
echo "==============================="

#Begin Main Logic Loop
while [ $keeprunning -eq 1 ]
do
	#Send API Call to Toggle Lock State
	if [ $debugstatus -eq 1 ]
	then
		echo "[DEBUG] Sending Toggle Request to Smartthings"
	fi
	curl -H "Authorization: Bearer eb4dde41-c09f-4fa9-a1c6-7e3c8177daef" -X GET "https://graph-na04-useast2.api.smartthings.com:443/api/smartapps/installations/beac5852-0ee5-4751-a162-3b5e1ace6931/devices/$device/toggle"

	#Halt Process for 5 Seconds to let Deadbolt Toggle State
	sleep 5

	#Log to Stdout the Numbers of Times Toggled and Export to count.txt
	echo "[INFO] Unlocked/Locked $x Time(s)"
	echo "[INFO] Number of Time(s) State has Toggled: $x" > count.txt
	x=$(( $x + 1 ))	

	#Send API Call to Retreive Current Battery Information Then Output to bat.txt
	if [ $debugstatus -eq 1 ]
	then
		echo "[DEBUG] Sending Battery Request to Smartthings"
	fi
	curl -s -H "Authorization: Bearer eb4dde41-c09f-4fa9-a1c6-7e3c8177daef" -X GET "https://graph-na04-useast2.api.smartthings.com:443/api/smartapps/installations/beac5852-0ee5-4751-a162-3b5e1ace6931/devices/$device/batterystats" | tr -d '[ ]' > bat.txt

	#Set Var currentbat Equal to Content of bat.txt Then Convert currentbat to an Int
	currentbat="$(cat ./bat.txt)"
	currentbatint=$(( ${currentbat#0} ))
	
	#Debug Information Regarding Battery Satistics
	if [ $debugstatus -eq 1 ]
	then
		echo "[DEBUG] Battery at $currentbatint% After $x Toggle(s)"
	fi

	#Perform Check on Battery, Testing if currentbatint is Less Than or Equal to the First Argument Passed.
	if [ $currentbatint -le $batterythreshold ]
	then
		$x=$x+1
		echo "[INFO] Battery depleted to or below $batterythreshold% after $x toggle(s)"
		keeprunning=0
	fi

	#Divide Output for Easier Viewing
	echo "==============================="

done
