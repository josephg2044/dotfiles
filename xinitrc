#!/bin/sh

xrandr --output DVI-D-0 --off --output HDMI-0 --off --output HDMI-1 --off --output DP-0 --mode 1920x1080 --rate 240 --pos 1920x0 --rotate right --output DP-1 --off --output DP-2 --primary --mode 1920x1080 --rate 240 --pos 0x420 --rotate normal --output DP-3 --off --output None-1-1 --off &
exec bspwm -c ~/.config/bspwm/bspwmrc
