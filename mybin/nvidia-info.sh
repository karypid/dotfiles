#!/bin/bash

DT=$(date +"%Y-%m-%d_%H:%M")

set -o xtrace

mkdir -p "$DT"

cat /proc/cmdline > $DT/proc_cmdline
cat /proc/driver/nvidia/version > $DT/proc_nvidia_version
cat /proc/driver/nvidia/params | sort > $DT/proc_nvidia_params
modinfo nvidia | grep license > $DT/mod_nvidia_license

journalctl -b -k | head -n 2 > $DT/boot_start
journalctl -b -k | grep NVRM | head -n 10 > $DT/boot_nvidia_start

#sudo cat /sys/module/nvidia_modeset/parameters/vblank_sem_control

