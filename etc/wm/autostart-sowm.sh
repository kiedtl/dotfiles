#!/usr/bin/env bash

main() {
	# swap escape and caps lock
	(xmodmap -e "clear lock"
	xmodmap -e "keycode 9 = Caps_Lock NoSymbol Caps_Lock"
	xmodmap -e "keycode 66 = Escape NoSymbol Escape") &

	# configure Xresources async
	(xrdb -merge ~/.Xresources) &

	# set cursor
	xsetroot -cursor_name left_ptr

	# edit background
	# did I mention that bars are bloat?
	#polybar -r bar &
	hsetroot -solid "#c3d3d2"

	# X autolock
	exec xautolock -time 30 -locker slock
}

main "$@"
