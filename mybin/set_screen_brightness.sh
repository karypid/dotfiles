#!/bin/sh

BRIGHTNESS=$1

echo "Setting laptop screen brightness to $BRIGHTNESS (range is 15-1200)..."
echo $BRIGHTNESS > /sys/class/backlight/intel_backlight/brightness

