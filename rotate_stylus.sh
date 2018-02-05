#!/bin/sh

# Find the line in "xrandr -q --verbose" output that contains current 
#screen orientation and "strip" out current orientation.

i="0"

while [ $i -lt 1 ]
do

rotation="$(xrandr -q --verbose | grep 'connected' | head -n 1 | cut -d' ' -f6)"

# Using current screen orientation proceed to rotate screen and input 
#devices.

case "$rotation" in
    left)
    # rotate to the left
    #xrandr -o left
    xsetwacom set "NTRG0001:01 1B96:1B05 Pen stylus" rotate ccw
    xsetwacom set "NTRG0001:01 1B96:1B05 Pen eraser" rotate ccw
    #xsetwacom set touch rotate ccw
    ;;
    inverted)
    # rotate to inverted
    #xrandr -o inverted
    xsetwacom set "NTRG0001:01 1B96:1B05 Pen stylus" rotate half
    xsetwacom set "NTRG0001:01 1B96:1B05 Pen eraser" rotate half
    #xsetwacom set touch rotate half
    ;;
    right)
    # rotate to the right
    #xrandr -o right
    xsetwacom set "NTRG0001:01 1B96:1B05 Pen stylus" rotate cw
    xsetwacom set "NTRG0001:01 1B96:1B05 Pen eraser" rotate cw
    #xsetwacom set touch rotate cw
    ;;
    normal)
    # rotate to normal
    #xrandr -o normal
    xsetwacom set "NTRG0001:01 1B96:1B05 Pen stylus" rotate none
    xsetwacom set "NTRG0001:01 1B96:1B05 Pen eraser" rotate none
    #xsetwacom set touch rotate none
    ;;
esac

sleep 1

done
