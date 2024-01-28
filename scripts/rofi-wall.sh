#!/bin/bash
wallpath="$HOME/pictures/wallpapers"
selected=$(exa $wallpath* | rofi -dmenu -p "wall")
feh --bg-scale "$wallpath/$selected"
