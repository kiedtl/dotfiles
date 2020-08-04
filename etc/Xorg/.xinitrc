#
# kiedtl's xinitrc
# https://github.com/kiedtl/dotfiles
#
# (c) Kiëd Llaentenn
# check the LICENSE for more info.
#


# swap escape and caps lock
xmodmap -e "clear lock"
xmodmap -e "keycode 9 = Caps_Lock NoSymbol Caps_Lock"
xmodmap -e "keycode 66 = Escape NoSymbol Escape"

# merge Xresources
xrdb -merge ~/etc/Xorg/.Xresources
xrdb -merge ~/.cache/wal/colors.Xresources
xrdb -merge ~/.cache/wal/2bwm.Xresources

# set wallpaper/theme, bars
[ -f ~/.fehbg ] && ~/.fehbg &
the &
polybar -r bar &

xautolock -time 30 -locker slock &
exec ssh-agent 2bwm
