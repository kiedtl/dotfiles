#!/usr/bin/env bash
#
# autostart.sh - 

main() {
    feh --bg-fill ~/wallpaper/landscape-006.jpg
    # (conky | while read info; do xsetroot -name "${info}"; done) &
}

main "$@"
