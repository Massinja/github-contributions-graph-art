#!/bin/bash

#./display_grid.sh -d 2020-01-01 -dd 366 -s random -n 10
#./display_grid.sh -d 2020-01-01 -dd 366 -s fixed -n 5

#hardcoded for now for testing 
PATRN=full
FILE=display$PATRN
DAYS=5
START_DATE="2020-01-01"
STYLE=random
NC=5
UL=12

WORK_DATE=$START_DATE
for DAY in $(seq 1 $DAYS)
do
	Y=$(date -d $WORK_DATE +%Y)
	M=$(date -d $WORK_DATE +%m)
	D=$(date -d $WORK_DATE +%d)

	#number of commits(NC) on the same day is random or fixed
	
	if [ "$STYLE" == "random" ]; then
		NC=$(( 1 + $RANDOM % $UL ))
	fi

	for i in $(seq 1 $NC)
	do
		echo "commit $DAY-$i for $PATRN grid" > $FILE
		export GIT_COMMITTER_DATE="$Y-$M-$D 12:0$i:00"
		export GIT_AUTHOR_DATE="$Y-$M-$D 12:0$i:00"
		git add $FILE
		git commit --date="$Y-$M-$D 12:0$i:00" -m "add commit $DAY-$i to build $PATRN coverage github grid"
	done
   	WORK_DATE=$(date -d "$WORK_DATE +1 days" +%Y-%m-%d)

done


