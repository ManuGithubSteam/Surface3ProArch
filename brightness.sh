#!/bin/bash
MaxBr="99"
MinBr="3"
JumpVal="20"

actValue=$(gdbus call --session --dest org.gnome.SettingsDaemon.Power --object-path /org/gnome/SettingsDaemon/Power --method org.freedesktop.DBus.Properties.Get org.gnome.SettingsDaemon.Power.Screen Brightness | cut -d'<' -f2 | cut -d'>' -f1)


echo "ActValue: $actValue"

value=$actValue


if [ "$value" -lt 50 ]; then

JumpVal="10"

fi

if [ "$value" -gt 20 ]; then

JumpVal="10"

fi

if [ "$value" -gt 50 ]; then

JumpVal="20"

fi

if [ "$value" -lt 20 ]; then

JumpVal="5"

fi


if [ "$1" == "u" ]; then

value=$((value+$JumpVal*2))

else

value=$((value-$JumpVal))

fi


if [ "$value" -ge $MaxBr ]; then

value=$MaxBr

fi

if [ "$value" -lt $MinBr ]; then

value=$MinBr

fi

echo "Value: $value"

gdbus call --session --dest org.gnome.SettingsDaemon.Power --object-path /org/gnome/SettingsDaemon/Power --method org.freedesktop.DBus.Properties.Set org.gnome.SettingsDaemon.Power.Screen Brightness "<int32 $value>"

echo "SET VALUE: "

gdbus call --session --dest org.gnome.SettingsDaemon.Power --object-path /org/gnome/SettingsDaemon/Power --method org.freedesktop.DBus.Properties.Get org.gnome.SettingsDaemon.Power.Screen Brightness | cut -d'<' -f2 | cut -d'>' -f1




