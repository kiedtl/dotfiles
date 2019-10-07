xrdb -merge ~/.Xresources

# forget about i3
#i3

# start feh, since dwm
# can't or won't start it itself
feh --bg-fill ~/wallpapers/landscape-006.jpg 2>&1

# start dwm
exec dwm
