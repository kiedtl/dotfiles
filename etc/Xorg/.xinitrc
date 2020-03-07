# kiedtl's xinitrc

esc &
rice &

xautolock -time 30 -locker slock &
xterm -e "sh -c 'sleep 3; ssh-add'" &

exec ssh-agent sowm
