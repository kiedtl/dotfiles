#!/usr/bin/env bash
#
# autostart.sh - 

main() {
	# swap escape and caps lock
	xmodmap -e "clear lock"
	xmodmap -e "keycode 9 = Caps_Lock NoSymbol Caps_Lock"
	xmodmap -e "keycode 66 = Escape NoSymbol Escape"

	# configure Xresources async
	xrdb -merge ~/etc/Xorg/.Xresources
	
	# add wallpaper
	~/.fehbg &
	polybar -r bar

	# exec ~/.config/polybar/launch-dwm.sh
	# (conky | while read info; do xsetroot -name "${info}"; done) &

	# X autolock
	exec xautolock -time 30 -locker slock
}

main "$@"
