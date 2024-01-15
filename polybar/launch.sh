#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar
# If all your bars have ipc enabled, you can also use
# polybar-msg cmd quit

# Launch bar1 and bar2
while pgrep -x polybar >/dev/null; do sleep 1; done

# Launch
polybar main_bar &

echo "Bar launched..."
sleep 1
xdo lower -N "Polybar"
xdo above -N "Polybar" -t $(xdo id -N Bspwm -n root)
