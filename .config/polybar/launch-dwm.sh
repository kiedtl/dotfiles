#!/bin/sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Start the polybar party
# polybar top -c /home/kiedtl/.config/polybar/config-top.ini &
polybar dwm_bar -s -c /home/kiedtl/.config/polybar/config-dwm.ini &
