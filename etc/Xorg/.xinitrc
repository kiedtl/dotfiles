# kiedtl's xinitrc

# swap escape and caps lock
xmodmap -e "clear lock"
xmodmap -e "keycode 9 = Caps_Lock NoSymbol Caps_Lock"
xmodmap -e "keycode 66 = Escape NoSymbol Escape"

# merge Xresources
xrdb -merge ~/etc/Xorg/.Xresources
xrdb -merge ~/.cache/wal/colors.Xresources
xrdb -merge ~/.cache/wal/2bwm.Xresources

# set wallpaper
[ -f ~/.fehbg ] && ~/.fehbg &

# start xcompmgr
xcompmgr &

# start bars
polybar -r bar &

xautolock -time 30 -locker slock &
exec ssh-agent sowm
