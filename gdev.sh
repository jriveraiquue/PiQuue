#!/bin/bash

## COPYRIGHT IQUUE 2017 ##
## PRIMARY AUTHOR: FRANK A. LOTURCO ##
## INTENDED FOR USE WITH IQUUE EQUIPMENT ##
## THIS SCRIPT COMES WITH ABSOLUTLY NO WARRANTY ##
## PLEASE REFER TO THE LICENSE FILE FOR MORE INFORMATION ##

#Set Global Vars
package="gdev"

while test $# -gt 0
do
	case "$1" in
			-h|--help)
				echo "$package - Get List of Available Devices From Smartthings"
				echo " "
				echo "$package [options] application [arguments]"
				echo " "
				echo "options:"
				echo "-h, --help                Show this menu."
				exit 0
				;;
			*)
				break
				;;
	esac
done


#Begin Main Logic
echo "[INFO] Gathering List of Currently Paired Devices From Smartthings..."
curl -s -H "Authorization: Bearer eb4dde41-c09f-4fa9-a1c6-7e3c8177daef" -X GET "https://graph-na04-useast2.api.smartthings.com:443/api/smartapps/installations/beac5852-0ee5-4751-a162-3b5e1ace6931/devices/" | grep -Po '"(name|id|battery|deviceType)":.*?[^\\]",' | tr -d '"' | sed -r 's/(name)/\n\1/g'
echo " "
