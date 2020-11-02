#
# kiedtl's ~/.profile
# https://github.com/kiedtl/dotfiles
#

export PATH="$HOME/local/bin:$PATH"
export PATH="$HOME/.local/bin:/usr/local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$HOME/go/bin:$PATH"
export PATH="/tilde/bin:$PATH"                  # tildeverse scripts
export PATH="$HOME/bin:$HOME/bin/net:$PATH"
export PATH="$HOME/bin/x11:$HOME/bin/lib:$PATH"

export LANG="en_US.UTF-8"
export EDITOR="nvim"
export VISUAL="$EDITOR"
export TERM="xterm-256color"                    # vim: enable 256 colors already
export XDG_CONFIG_HOME="${HOME}/etc"
export ENV="$HOME/etc/mksh/profile.sh"
export HISTFILE="$HOME/opt/.cache/mksh/history.txt"
export HISTSIZE="65535"

# stop cluttering up my $HOME
export LESSHISTFILE=~/var/cache/less/history
alias wget="wget --no-hsts"
alias tmux="tmux -f $HOME/etc/tmux/conf"

# weechat/irssi
export IRSSI_HOME="$HOME/etc/irssi/"
export WEECHAT_HOME="$HOME/etc/weechat/"
alias irssi="irssi --home $IRSSI_HOME"

# pastel config
export PASTEL_COLOR_MODE=24bit

# mailx/fdm config
export MAIL="${HOME}/var/mail/INBOX"

# for Rust development
export RUST_BACKTRACE=1

# Common Lisp stuff
export SBCL_HOME=$HOME/local/lib/sbcl/

# for KISS Linux
# source kiss path if it exists
[ -f /etc/profile.d/kiss_path.sh ] && \
    . /etc/profile.d/kiss_path.sh

# source stuff from ~/bin
. ~/bin/shtat

s() {
    systemctl --user "${1:-status}" "${2:-bot}"
}

if has doas; then
    alias d='doas'
else
    alias d='sudo'
fi

if has exa; then
    alias l='exa -F'
    alias tree='exa --tree --git-ignore' # use exa's tree instead
    alias ls='exa -lF'                   # long live exa!
    alias lsd='exa -alF'                 # ^^
else
    alias lsd='ls -alF'                  # boo hoo hoo exa isn't there
    alias l='/bin/ls -F'                 # oh woe is me, what would I
    alias ls='ls -lF'                    # do without colors :'(
fi

if has peaclock; then
    alias peaclock='LC_ALL=C peaclock'   # fix peaclock on musl
fi

if has bc; then
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
        set -o noclobber
        set -o ignoreeof             # no accidental exits in ssh sessions
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

if has paleta && has colors; then
    paleta $(colors) 2>/dev/null >&2      # retrieve colorscheme
fi

prompt() {
    mypwd=$(printf "$PWD" | \
        sed "s|$HOME|~|g")
    if [ $mypwd != "~" ]; then
        mypwd="$(basename ${mypwd%/*})/$(basename ${mypwd})"
    fi

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
    printf '\r\1\033]0;%s\a\1' "$USER@$(hostname):$mypwd"

    # print path
    printf '\1\033[31m\1%s\1\033[0m\1' "$mypwd"

    if [ "$(whoami)" = "root" ]
    then
        printf ' %s' "#"
    else
        printf ' %s' "|"
    fi

    # print a space
    printf ' '
}

export PS1="\$(prompt)"
