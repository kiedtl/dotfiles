#
# kiedtl's xinitrc
# https://github.com/kiedtl/dotfiles
#
# (c) Kiëd Llaentenn
# check the LICENSE for more info.
#

# don't turn off my screen
xset -dpms && xset s off

# disable the bell
xset -b

# enable Ctrl+Alt+<Bksp> to kill X11
setxkbmap -option terminate:ctrl_alt_bksp

# configure locales
LC_ALL=''
export LANG=en_US.UTF-8
export LC_MESSAGES=c
export LC_TIME=en_US.UTF-8

# enable core dumps
ulimit -c unlimited

# swap escape and caps lock
xmodmap -e "clear lock"
xmodmap -e "keycode 9 = Caps_Lock NoSymbol Caps_Lock"
xmodmap -e "keycode 66 = Escape NoSymbol Escape"

# merge Xresources
xrdb -merge ~/etc/Xorg/.Xresources
xrdb -merge ~/.cache/wal/colors.Xresources
xrdb -merge ~/.cache/wal/2bwm.Xresources

# set wallpaper/theme, bars
the peaceful &
polybar -r bar &
feh --bg-fill ~/img/wallpapers/meshwork.png

xautolock -time 30 -locker slock &
exec ssh-agent i3
