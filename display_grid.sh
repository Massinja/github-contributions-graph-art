#!/bin/bash

#./display_grid.sh -d 2020-01-01 -n 366 -s random -c 10
#./display_grid.sh -d 2020-01-01 -n 366 -s fixed -c 5
 
DAYS=5
START_DATE="2020-01-01"
STYLE=fixed
NC=5

WORK_DATE=$START_DATE
for DAY in $(seq 1 $DAYS)
do
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
   	WORK_DATE=$(date -d "$WORK_DATE +1 days" +%Y-%m-%d)

done


