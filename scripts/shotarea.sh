#!/usr/bin/env bash

# Screenshot
time=`date +%H-%M-%S`
day=`date +%Y-%m-%d`
geometry=`xrandr | grep 'current' | head -n1 | cut -d',' -f2 | tr -d '[:blank:],current'`
dir="`xdg-user-dir PICTURES`/screenshots/${day}"
file="${time}_${geometry}.png"

if [[ ! -d "$dir" ]]; then
	mkdir -p "$dir"
fi

# Copy screenshot to clipboard
copy_shot () {
	tee "$file" | xclip -selection clipboard -t image/png
}

cd ${dir} && maim -u -m 10 -f png -s -b 1 -c 0.75,0.75,0.85,0.15 -l | copy_shot
nsxiv $file
