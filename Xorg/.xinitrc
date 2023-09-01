#
# kiedtl's xinitrc
# https://github.com/kiedtl/dotfiles
#
# (c) Kiëd Llaentenn
# check the LICENSE for more info.
#

# don't turn off my screen
#xset -dpms && xset s off

# disable the bell
xset -b

# Keyboard modifications:
# 	- Enable Ctrl+Alt+<Bksp> to kill X11
# 	- Swap escape and caps lock
# 	- Rebind meta/alt
#  	-option caps:swapescape \
setxkbmap -layout us,il \
	-option compose:ralt \
	-option grp:sclk_toggle \
	-option altwin:meta_alt \
	-option terminate:ctrl_alt_bksp

# configure locales
LC_ALL=''
export LANG=en_US.UTF-8
export LC_MESSAGES=c
export LC_TIME=en_US.UTF-8

# enable core dumps
ulimit -c unlimited

# merge Xresources
xrdb -merge ~/etc/Xorg/.Xresources
xrdb -merge ~/.cache/wal/colors.Xresources
xrdb -merge ~/.cache/wal/2bwm.Xresources

# set wallpaper/theme, bars
the peaceful &

xhost +localhost

mpd --kill
mpd &
mpd-record &
devmon &
xautolock -time 30 -locker 'i3lock-fancy -pf Fira-Code-Regular' &
pulseaudio &
exec ssh-agent i3
