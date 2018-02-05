#!/bin/bash

# the mac adress of your pen
blueMAC="EB:DD:F0:62:CF:6B"
# command to execute
command="xournalpp"


####################################
####################################
####################################


while read line
do
#echo "$line"
 
	if [[ $line = *"bluetoothd: No cache for $blueMAC"* ]];
	then
		# echo "inside!"
		# echo "$line"
		# test if running
		ps -ef | grep "$command" | grep -v grep
		if [ $? -eq 1 ]
		then
			echo "not running starting"
			$command &
			continue
		fi
	fi
done < "${1:-/dev/stdin}"

