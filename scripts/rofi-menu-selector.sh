#!/bin/bash
menus="vpn\nmin\nwall\ncalc\npower"
sel=$(echo -e $menus | rofi -theme ~/.config/rofi/small.rasi -dmenu)
case ${sel} in
    "vpn")
		$HOME/.config/polybar/scripts/vpn/vpn_menu
        ;;
    "min")
        $HOME/.local/bin/minmenu.sh
        ;;
    "wall")
        $HOME/.local/bin/rofi-wall.sh
        ;;
    "calc")
        rofi -theme ~/.config/rofi/calc.rasi -show calc -modi calc -no-show-match -no-sort -calc-command "echo -n '{result}' | xclip -selection clipboard"
        ;;
    "power")
        $HOME/.config/rofi/applets/powermenu.sh
        ;;
esac
