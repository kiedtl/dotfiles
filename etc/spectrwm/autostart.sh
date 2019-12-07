#!/usr/bin/env bash

main() {
	# swap escape and caps lock
	(xmodmap -e "clear lock"
	xmodmap -e "keycode 9 = Caps_Lock NoSymbol Caps_Lock"
	xmodmap -e "keycode 66 = Escape NoSymbol Escape") &

	# configure Xresources async
	(xrdb -merge ~/.Xresources) &

	# restart spectrwm -- hack for regions to work :-(
	/bin/kill -s SIGHUP spectrwm

	# add wallpaper and start bar script
	~/.fehbg &
	polybar -r bar &

	# X autolock
	exec xautolock -time 30 -locker slock
}

main "$@"
