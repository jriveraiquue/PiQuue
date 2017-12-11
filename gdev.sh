#!/bin/bash

## COPYRIGHT IQUUE 2017 ##
## PRIMARY AUTHOR: FRANK A. LOTURCO ##
## INTENDED FOR USE WITH IQUUE EQUIPMENT ##
## THIS SCRIPT COMES WITH ABSOLUTLY NO WARRANTY ##
## PLEASE REFER TO THE LICENSE FILE FOR MORE INFORMATION ##

#Set Global Vars
package="gdev"
filtername=0

while test $# -gt 0
do
	case "$1" in
			-h|--help)
				echo "$package - Get List of Available Devices From Smartthings"
				echo " "
				echo "$package [options] application [arguments]"
				echo " "
				echo "options:"
				echo "-h, --help                Show This Menu."
				echo "-q                        Filter Output [id, name]."
				exit 0
				;;
			-q)
				shift
				if [ $1 == "name" ]
				then
					export filtername=1
				elif [ $1 == "id" ]
				then
					export filterid=1
				else
					echo "[ERROR] The Query Flag was Set but no Valid Filter Provided"
					exit 1
				fi
				shift
				;;
			*)
				break
				;;
	esac
done


#Begin Main Logic
if [ $filtername -eq 1 ]
then
	echo "[INFO] Gathering List of all Names of Paired Devices"
	curl -s -H "Authorization: Bearer eb4dde41-c09f-4fa9-a1c6-7e3c8177daef" -X GET "https://graph-na04-useast2.api.smartthings.com:443/api/smartapps/installations/beac5852-0ee5-4751-a162-3b5e1ace6931/devices/" | grep -Po '"(name|id|battery)":.*?[^\\]",' | tr -d '"' | awk '!seen[$0]++' | sed -r 's/(name)/\n\1/g' | grep "name"
elif [ $filterid -eq 1 ]
then
	echo "[INFO] Gathering List of Paired Devices IDs"
	curl -s -H "Authorization: Bearer eb4dde41-c09f-4fa9-a1c6-7e3c8177daef" -X GET "https://graph-na04-useast2.api.smartthings.com:443/api/smartapps/installations/beac5852-0ee5-4751-a162-3b5e1ace6931/devices/" | grep -Po '"(name|id|battery)":.*?[^\\]",' | tr -d '"' | awk '!seen[$0]++' | sed -r 's/(name)/\n\1/g' | grep "id"
else
	echo "[INFO] Gathering List of all Currently Paired Devices From Smartthings..."
	curl -s -H "Authorization: Bearer eb4dde41-c09f-4fa9-a1c6-7e3c8177daef" -X GET "https://graph-na04-useast2.api.smartthings.com:443/api/smartapps/installations/beac5852-0ee5-4751-a162-3b5e1ace6931/devices/" | grep -Po '"(name|id|battery)":.*?[^\\]",' | tr -d '"' | awk '!seen[$0]++' | sed -r 's/(name)/\n\1/g'
fi
echo " "
