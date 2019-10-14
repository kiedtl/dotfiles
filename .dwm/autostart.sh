#!/usr/bin/env bash
#
# autostart.sh - 

main() {
	# swap escape and caps lock
	xmodmap -e "clear lock"
	xmodmap -e "keycode 9 = Caps_Lock NoSymbol Caps_Lock"
	xmodmap -e "keycode 66 = Escape NoSymbol Escape"
   	
	# add wallpaper and start bar script
	feh --bg-fill ~/wallpapers/landscape-013.jpg
	(/home/kiedtl/bin/bar) &
	# (conky | while read info; do xsetroot -name "${info}"; done) &
}

main "$@"
