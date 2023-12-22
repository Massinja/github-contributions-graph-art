#!/bin/bash
#Asks a user for a Sunday date

get_the_date(){
	exit_code=1
	until [ $exit_code -eq 0 ]
	do
		read -p "Give a Sunday date you'd like to start on. In a format YYYY-MM-DD: " user_start_date	
		weekday=`date -d $user_start_date +%A`
		exit_code=$?
	done		
}

weekday="unknown"

until [ "$weekday" == "Sunday" ]
do
	get_the_date
	if [ "$weekday" != "Sunday" ]; then
		echo $user_start_date is $weekday
	fi
done


