#!/bin/bash

# ./display_grid.sh -d 2020-01-01 -n 366 -s random -c 10
# ./display_grid.sh -d 2020-01-01 -n 366 -s fixed -c 5

# number of consecutive days to make commits for
DAYS=5

# default date to start making commits from
START_DATE="2020-01-01"

# fixed number of commits per day, or random, therefore, different shades of green on the GitHub grid
STYLE="fixed"

# number of default commits per day
NC=5

# prints to stdout how to use this script
print_usage() {
	printf 'Usage: ./display_grid.sh -d "2020-01-01" -n 366 -s random -c 10
	-h help;
	-d specify date to start from in the format YYYY-MM-DD;\n\t   default: "2020-01-01";
	-c specify number of commits per day\n\t   if used with flag "-s random", will specify the max value of the range;\n\t   default: 5; maximum; 59;
	-n number of consecutive days to make commits for; default: 5;
	-s style of the grid colour\n\t   style options:\n\t   fixed - same colour for every square;\n\t   random - in the range from 1 and number specified with flag "-n";\n';
}

# makes N amount of commits on specified date
# expects 2 parameters:
# $1 - number of commits
# $2 - the date to make commits on
make_commit() {
CMT=$1
WORK_DATE=$2
	Y=$(date -d $WORK_DATE +%Y)
	M=$(date -d $WORK_DATE +%m)
	D=$(date -d $WORK_DATE +%d)

	for i in $(seq 1 $CMT); do
		echo "commit $WORK_DATE-$i for full grid" > commits
		export GIT_COMMITTER_DATE="$Y-$M-$D 12:0$i:00"
		export GIT_AUTHOR_DATE="$Y-$M-$D 12:0$i:00"
		git add commits
		git commit --date="$Y-$M-$D 12:0$i:00" -m "add commit $WORK_DATE-$i to build full coverage GitHub grid"
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
			exit 1
			;;
	esac
done

END_DATE=$(date -d "$START_DATE +$DAYS days" +%Y-%m-%d) 

# confirm user is okay to proceed
if [ "$STYLE" == "fixed" ]; then
	read -p "Would you like to make $NC commits per day from $START_DATE until $END_DATE? y/n: " response
else
	read -p "Would you like to make a random number of commits in the range from 1 to $NC from $START_DATE until $END_DATE? y/n: " response
fi

case "$response" in
	[yY][eE][sS]|[yY])
		echo "Excellent! Making commits shortly!"
		;;
	*)	echo "Bye then!"
		exit 0
		;;
esac

# make a backup of start date in case referenced in the future
WORK_DATE=$START_DATE

for DAY in $(seq 1 $DAYS); do
	if [ "$STYLE" == "random" ]; then
		CMT=$(( 1 + $RANDOM % $NC ))
	else
		CMT=$NC
	fi
	make_commit $CMT $WORK_DATE
   	WORK_DATE=$(date -d "$WORK_DATE +1 days" +%Y-%m-%d)
done


