#!/usr/bin/env bash
#
# autostart.sh - 

main() {
	# swap escape and caps lock
	xmodmap -e "clear lock"
	xmodmap -e "keycode 9 = Caps_Lock NoSymbol Caps_Lock"
	xmodmap -e "keycode 66 = Escape NoSymbol Escape"

	# configure Xresources
	xrdb -merge ~/.Xresources
	xrdb -merge ~/.cache/wal/colors.Xresources	
	# add wallpaper and start bar script
	~/.fehbg
	exec ~/.config/polybar/launch-i3.sh
	# (conky | while read info; do xsetroot -name "${info}"; done) &
}

main "$@"
