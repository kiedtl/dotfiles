# kiedtl's xinitrc

(
	xmodmap -e "clear lock"
	xmodmap -e "keycode 9 = Caps_Lock NoSymbol Caps_Lock"
	xmodmap -e "keycode 66 = Escape NoSymbol Escape"
) &

(
	polybar left
	polybar center
	polybar right
) &

(xrdb -merge ~/etc/Xorg/.Xresources) &
(wal -R) &
(xautolock -time 30 -locker slock) &

exec ssh-agent frankenwm
