#!/bin/bash
# test
# make commits from April to June, from 25 to 31st, 5 times

for M in {04..06}
do
	#TO-DO: what about months without 29-31st days
	for D in {25..31}
	do
		# TO-DO: regulate number of commits for the colour shades. 5 commits per day at the momment
		for i in {01..05}
		do
			com_date="2020-$M-$D 12:$i:00"
			auth_date="2020-$M-$D 12:$i:00"
			echo $com_date and $auth_date
			date -d "2020-$M-$D 12:0$i:00"
		done
	done
done
