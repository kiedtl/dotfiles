#!/bin/sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Start the polybar party
polybar top -r -c /home/kiedtl/.config/polybar/fancy/config-top.ini &
polybar bottom -r -c /home/kiedtl/.config/polybar/fancy/config-bottom.ini &
