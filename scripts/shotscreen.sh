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

# notify and view screenshot
notify_view() {
	notify_cmd_shot='dunstify -u low --replace=699'
	${notify_cmd_shot} "Copied to clipboard."
	viewnior ${dir}/"$file"
	if [[ -e "$dir/$file" ]]; then
		${notify_cmd_shot} "Screenshot Saved."
	else
		${notify_cmd_shot} "Screenshot Deleted."
	fi
}

# Copy screenshot to clipboard
copy_shot () {
	tee "$file" | xclip -selection clipboard -t image/png
}

cd ${dir} && sleep 0.1 && maim -u -m 10 -f png | copy_shot
nsxiv $file
