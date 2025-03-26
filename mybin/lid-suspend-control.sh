#!/bin/sh

WHAT=handle-lid-switch
PID=$(systemd-inhibit --list | grep $WHAT | sed "s/.*$USER//" | cut -d ' ' -f 2)

if [ -z $PID ]; then
	systemd-inhibit --what=$WHAT zenity --info --text='Lid suspend blocked while open' --ok-label=Close &
	echo Started suspend prevention process $!
else
	echo Killing suspend prevention process $PID
	kill $PID
fi

