#!/bin/bash
MaxBr="99"
MinBr="0"

actValue=$(gdbus call --session --dest org.gnome.SettingsDaemon.Power --object-path /org/gnome/SettingsDaemon/Power --method org.freedesktop.DBus.Properties.Get org.gnome.SettingsDaemon.Power.Screen Brightness | cut -d'<' -f2 | cut -d'>' -f1)


echo "ActValue: $actValue"

value=$actValue

if [ "$1" == "u" ]; then

value=$((value+20))

else

value=$((value-20))

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




