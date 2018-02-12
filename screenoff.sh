#!/bin/bash

laststate=$(cat /home/user/.scripts/screenstate)

getid=$(xinput list | grep NT | grep -v "Pen" | cut -d'=' -f2 | cut -d'[' -f1)

getid2=$(xinput list | grep Buttons | cut -d'=' -f2 | cut -d'[' -f1)

if [ "$laststate" = "off" ]; then

				xset dpms force on
				xinput enable $getid
				xinoput enable $getid2
				echo "on" > /home/user/.scripts/screenstate
				
           else
           
           xset dpms force off
           xinput disable $getid
           xinput disable $getid2
           echo "off" > /home/user/.scripts/screenstate
           
           fi

