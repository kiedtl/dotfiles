#!/usr/bin/env bash
#
# autostart.sh - 

main() {
    feh --bg-fill ~/wallpapers/landscape-006.jpg
    (/home/kiedtl/bin/bar) &
    # (conky | while read info; do xsetroot -name "${info}"; done) &
}

main "$@"
