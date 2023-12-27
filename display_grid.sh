#!/bin/bash

#./display_grid.sh -d 2020-01-01 -n 366 -s random -c 10
#./display_grid.sh -d 2020-01-01 -n 366 -s fixed -c 5

#number of consecutive days to make commits for
DAYS=5

#default date to start making commits from
START_DATE="2020-01-01"

#fixed number of commits per day, or random, therefore, different shades of green on the github grid
STYLE="fixed"

#number of default commits per day
NC=5

# print to stdout how to use this script
print_usage() {
	printf 'Usage: ./display_grid.sh -d "2020-01-01" -n 366 -s random -c 10
	-h help;
	-d specify date to start from in the format YYYY-MM-DD;\ndefault: "2020-01-01"
	-c specify number of commits per day\nif used with flag "-s" random, specifies the max limit;\ndefault: 5
	-n number of consecutive days to make commits for;\ndefault: 7
	-s style of the grid color\noptions:\nfixed - same colour for every square;\nrandom - in the range from 1 and number specified with flag "-n";\ndefault: 5'
}

#make N amount of commits on specified date
#expects 2 parameters:
#CMT - number of commits
#WORK_DATE - the date to make commits on



make_commit($CMT, $DAY, $WORK_DATE) {

	Y=$(date -d $WORK_DATE +%Y)
	M=$(date -d $WORK_DATE +%m)
	D=$(date -d $WORK_DATE +%d)

	for i in $(seq 1 $CMT)
	do
		echo "commit $DAY-$i for full grid" > commits
		export GIT_COMMITTER_DATE="$Y-$M-$D 12:0$i:00"
		export GIT_AUTHOR_DATE="$Y-$M-$D 12:0$i:00"
		git add commits
		git commit --date="$Y-$M-$D 12:0$i:00" -m "add commit $DAY-$i to build full coverage github grid"
	done
}

while getopts 'd:n:s:c:h' flag; do
	case "${flag}" in
		d) START_DATE=$(date -d "$OPTARG" +%Y-%m-%d 2> /dev/null)
		if [ $? -ne 0 ]; then 
			echo "Check your date format. Try again, please!"
			echo "Expected: YYYY-MM-DD. Received: $OPTARG"
			exit 1 
		fi
		;;
		c) NC="${OPTARG}"
		if [ "$NC" -ge 1 2> /dev/null ] && [ "$NC" -le 59 2> /dev/null ]; then
			continue
		else
			echo "Invalid number of commits! Try again, please!"
			echo "Expected: a number from 1 to 59. Received: $OPTARG"
			exit 1
		fi
		;;
		n) DAYS="${OPTARG}"
		if [ "$DAYS" -ge 1 2> /dev/null ] && [ "$DAYS" -le 366  2> /dev/null ]; then
			continue
		else
			echo "Invalid number of days! Try again, please!"
			echo "Expected: a number from 1 to 366. Received: $OPTARG"
			exit 1
		fi
		;;
		s) STYLE="${OPTARG}" 
		if [ "$STYLE" != "random" ] && [ "$STYLE" != "fixed" ]; then 
			echo "Expected: \"-s random\" or \"-s fixed\". Received: \"-s $OPTARG\"" 
			exit 1
		fi
		;;
		*) print_usage
			exit 1 ;;
	esac
done
WORK_DATE=$START_DATE

for DAY in $(seq 1 $DAYS)
do

	#number of commits(CM) on the same day is random or fixed
	
	if [ "$STYLE" == "random" ]; 
	then 
		CMT=$(( 1 + $RANDOM % $NC ))
	else
		CMT=$NC
	fi

	make_commit($CMT, $DAY, $WORK_DATE)

   	WORK_DATE=$(date -d "$WORK_DATE +1 days" +%Y-%m-%d)

done


