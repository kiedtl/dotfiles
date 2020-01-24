#!/usr/bin/env bash
#
# autostart.sh - 

main() {
	# swap escape and caps lock
	(
		xmodmap -e "clear lock"
		xmodmap -e "keycode 9 = Caps_Lock NoSymbol Caps_Lock"
		xmodmap -e "keycode 66 = Escape NoSymbol Escape"
	) &

	# configure Xresources async
	(xrdb -merge ~/etc/Xorg/.Xresources) &
	
	# add wallpaper
	(~/.fehbg) &

	# X autolock
	exec xautolock -time 30 -locker slock
}

main "$@"
