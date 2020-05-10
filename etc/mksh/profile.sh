#
# kiedtl's ~/.profile
# https://github.com/kiedtl/dotfiles
#

export PATH=/home/kiedtl/local/bin:/home/kiedtl/bin:/usr/local/bin:$PATH
export LANG=en_US.UTF-8
export EDITOR=nvim
export VISUAL="$EDITOR"
export TERM=xterm-256color # enable the darned 256 color support vim, ok?
export XDG_CONFIG_HOME="${HOME}/etc"
export ENV="/home/kiedtl/etc/mksh/profile.sh"
export LUA_PATH='/usr/share/lua/5.3/?.lua;/usr/share/lua/5.3/?.lua;/usr/share/lua/5.3/?/init.lua;/usr/lib/lua/5.3/?.lua;/usr/lib/lua/5.3/?/init.lua;./?.lua;./?/init.lua;/home/kiedtl/.luarocks/share/lua/5.3/?.lua;/home/kiedtl/.luarocks/share/lua/5.3/?/init.lua;/home/kiedtl/.luarocks/share/lua/5.3/?/init.lua'
export LUA_CPATH='/usr/lib/lua/5.3/?.so;/usr/lib/lua/5.3/loadall.so;./?.so;/home/kiedtl/.luarocks/lib/lua/5.3/?.so;/home/kiedtl/.luarocks/lib/lua/5.3/?.so;/usr/lib/lua/5.3/?.so'
export PATH='/home/kiedtl/.luarocks/bin:/home/kiedtl/.luarocks/bin:/home/kiedtl/local/bin:/home/kiedtl/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin'

# pastel config
export PASTEL_COLOR_MODE=24bit

# mailx/fdm config
export MAIL="${HOME}/var/mail/INBOX"

# bat config
export BAT_THEME="OneHalfLight"

# nnn config
export NNN_USE_EDITOR=1

# for Rust development
export RUST_BACKTRACE=1

# source kiss path if it exists
[ -f /etc/profile.d/kiss_path.sh ] && . /etc/profile.d/kiss_path.sh

# source stuff from bin scripts
. "${HOME}/bin/c"                         # clear/cd/cat stuffed into one command
. "${HOME}/bin/h"                         # "cd /home/kiedtl"

alias peaclock='LC_ALL=C peaclock'        # fix peaclock on musl
alias bc="bc -ql"                         # basic calculator
alias p='pwd'                             # where does laziness become insanity?
alias t='touch'                           # ...
alias l='exa'                             # ...
alias tree='exa --tree --git-ignore'      # use exa's tree instead
alias ls='exa -l'                         # long live exa!
alias lsd='exa -al'
alias grep='grep --colour=auto'           # color by default
alias mv="mv -i"                          # prevent $(mv x.h x.c) ugh
alias cp="cp -i"                          # confirm before overwriting files
alias rm='rm -i'                          # confirm before deleting a file
alias df='df -h'                          # show human-readable sizes
alias free='free -m'                      # show sizes in MB

set -o vi

# I have no idea what this does ;)
#
# I mean, it's been in here for ages anyway,
# since my first distro (Manjaro) in
# fact, so why bother taking it out...
xhost +local:root >/dev/null 2>&1

# retrieve colorscheme
paleta $(colors) 2>/dev/null >&2

a="$(printf "\a")"
e="$(printf "\033")"
mypwd() {
    printf "$PWD" | \
        sed "s|$HOME|~|g"
}

export PS1="$e]0;\$(mypwd)$a# "
