#!/usr/bin/env bash
#
# autostart.sh - 

main() {
    feh --bg-fill ~/Pictures/wallpaper.jpg
    (conky | while read info; do xsetroot -name "${info}"; done) &
}

main "$@"
