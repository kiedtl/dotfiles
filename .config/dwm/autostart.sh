#!/usr/bin/env bash
#
# autostart.sh - 

main() {
	# swap escape and caps lock
	xmodmap -e "clear lock"
	xmodmap -e "keycode 9 = Caps_Lock NoSymbol Caps_Lock"
	xmodmap -e "keycode 66 = Escape NoSymbol Escape"

	# configure Xresources
	xrdb -merge ~/.cache/wal/colors.Xresources
	xrdb -merge ~/.Xresources
	# add wallpaper and start bar script
	~/.fehbg
	polybar bar
	
	# exec ~/.config/polybar/launch-dwm.sh
	# (conky | while read info; do xsetroot -name "${info}"; done) &

	# X autolock
	xautolock -time 10 -locker slock
}

main "$@"
