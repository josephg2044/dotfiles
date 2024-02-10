#!/usr/bin/env bash

# Screenshot
time=`date +%H-%M-%S`
day=`date +%Y-%m-%d`
dir="/home/joseph/pictures/screenshots/${day}"
file="${time}.png"

if [[ ! -d "$dir" ]]; then
	mkdir -p "$dir"
fi

# Copy screenshot to clipboard
cd ${dir}; shotgun $file
xclip -t 'image/png' -selection clipboard -i $file
nsxiv $file
