#
# kiedtl's ~/.profile
# https://github.com/kiedtl/dotfiles
#

have() {
    if command -v "$1" 2>/dev/null >&2
    then
        return 0
    else
        return 1
    fi
}

export PATH="/home/kiedtl/local/bin:/home/kiedtl/bin:/usr/local/bin:$PATH"
export LANG="en_US.UTF-8"
export EDITOR="nvim"
export VISUAL="$EDITOR"
export TERM="xterm-256color" # enable the darned 256 color support vim, ok?
export XDG_CONFIG_HOME="${HOME}/etc"
export ENV="/home/kiedtl/etc/mksh/profile.sh"
export HISTFILE="/home/kiedtl/opt/.cache/mksh/history.txt"
export HISTSIZE="65535"

# weechat
export WEECHAT_HOME="/home/kiedtl/etc/weechat/"

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
[ -f /etc/profile.d/kiss_path.sh ] && \
    . /etc/profile.d/kiss_path.sh

# source stuff from ~/bin
. ~/bin/shtat

s() {
    systemctl --user "${1:-status}" "${2:-bot}"
}

if have doas; then
    alias d='doas'
else
    alias d='sudo'
fi

if have exa; then
    alias l='exa -F'
    alias tree='exa --tree --git-ignore' # use exa's tree instead
    alias ls='exa -lF'                   # long live exa!
    alias lsd='exa -alF'                 # ^^
else
    alias lsd='ls -alF'                  # boo hoo hoo exa isn't there
    alias l='ls -F'                      # oh woe is me, what would I
    alias ls='ls -lF'                    # do without colors :'(
fi

if have peaclock; then
    alias peaclock='LC_ALL=C peaclock'   # fix peaclock on musl
fi

if have bc; then
    alias bc="bc -ql"                    # basic calculator
fi

alias p='pwd'                        # where does laziness become insanity?
alias h='cd ~'                       # ...
alias c='clear'                      # ...
alias t='touch'                      # ...
alias grep='grep --colour=auto'      # color by default
alias mv="mv -i"                     # prevent $(mv x.h x.c) ugh
alias cp="cp -i"                     # confirm before overwriting files
alias rm='rm -i'                     # confirm before deleting a file
alias df='df -h'                     # show human-readable sizes
alias free='free -m'                 # show sizes in MB

set -o vi

case $SHELL in
    *mksh*)
        set -o trackall
        set -o bgnice
        set -o vi-tabcomplete
    ;;
esac

# I have no idea what this does ;)
#
# I mean, it's been in here for ages anyway,
# since my first distro (Manjaro) in fact,
# so why bother taking it out...
xhost +local:root >/dev/null 2>&1

if have paleta && have colors; then
    paleta $(colors) 2>/dev/null >&2      # retrieve colorscheme
fi

prompt() {
    mypwd=$(printf "$PWD" | \
        sed "s|$HOME|~|g")

    # wrap nonprintables for mksh
    printf '\1\r\1'

    # print '%' just in case last command didn't print a newline
    # then, print a bunch of spaces if a newline was output, then
    # the spaces will stay on a line and we can output a carriage
    # return to get back to the start of the line. otherwise,
    # the spaces will wrap to the next line, where we can safely
    # carriage return to the start of the line and print out prompt.
    # this hack prevents out prompt from being messed up by some
    # idiotic programs that don't print their newlines.
    sz=$((COLUMNS-2))
    printf "\1\033[7m%%\033[0m%-${sz}s\1" \
        " "

    # print a carriage return and change window title
    printf '\r\1\033]0;%s\a\1' "$mypwd"

    # print path
    printf '\1\033[31m\1%s\1\033[0m\1' \
        "$mypwd"

    # print prompt char
    if [ "$(whoami)" = "root" ]
    then
        printf '%s' "#"
    else
        printf '%s' "\$"
    fi

    # print a space
    printf '%s' " "
}

export PS1=$'\$(prompt)'
