#
# kiedtl's ~/.profile
# https://github.com/kiedtl/dotfiles
#

export PATH="/usr/local/bin:$PATH"
export PATH="$HOME/local/bin:$PATH"
export PATH="$HOME/.local/bin:/usr/local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$HOME/go/bin:$PATH"
export PATH="/tilde/bin:$PATH"                  # tildeverse scripts
export PATH="$HOME/bin:$HOME/bin/net:$PATH"
export PATH="$HOME/bin/x11:$HOME/bin/lib:$PATH"
export PATH="$HOME/.luarocks/bin/:$PATH"

if has nvim; then
    export EDITOR="nvim"

    # Viewing manpages in neovim is a slightly more pleasant experience,
    # nvim has built-in support for manpages, including "syntax" highlighting
    # and following links (with 'K')
    #
    # Unfortunately, it's also really slow.
    #export MANPAGER="nvim -c 'set ft=man' -"
    #export MANWIDTH=$(stty size | cut -d' ' -f2)
else
    export EDITOR="vi"
fi

export VISUAL="$EDITOR"
export LANG="en_US.UTF-8"
export TERM="xterm-256color"                    # vim: enable 256 colors already
export XDG_CONFIG_HOME="${HOME}/etc"
export LD_LIBRARY_PATH=~/local/lib:$LD_LIBRARY_PATH

# mksh settings
HISTFILE="$HOME/opt/.cache/mksh/history.txt"
HISTSIZE="65535"
ENV="$HOME/etc/mksh/profile.sh"

# stop cluttering up my $HOME
export LESSHISTFILE=~/var/cache/less/history
alias wget="wget --no-hsts"
alias tmux="tmux -f $HOME/etc/tmux/conf"

# lurch
# https://github.com/lptstr/lurch
export LURCH_DEBUG=16

# mebsuta
# https://github.com/lptstr/mebsuta
export MEBS_DEBUG=16

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

# Lua stuff
export LUA_PATH='./?.lua;/home/kiedtl/.luarocks/share/lua/5.3/?.lua;/home/kiedtl/.luarocks/share/lua/5.3/?/init.lua;/usr/local/share/lua/5.3/?.lua;/usr/local/share/lua/5.3/?/init.lua;/home/kiedtl/.luarocks/share/lua/5.3/?.lua;/usr/local/lib/lua/5.3/?.lua;/usr/local/lib/lua/5.3/?/init.lua;/usr/share/lua/5.3/?.lua;/usr/share/lua/5.3/?/init.lua;./?.lua;./?/init.lua'
export LUA_CPATH='/home/kiedtl/.luarocks/lib/lua/5.3/?.so;/usr/local/lib/lua/5.3/?.so;/home/kiedtl/.luarocks/lib/lua/5.3/?.so;/usr/lib/x86_64-linux-gnu/lua/5.3/?.so;/usr/lib/lua/5.3/?.so;/usr/local/lib/lua/5.3/loadall.so;./?.so'

# for KISS Linux
# source kiss path if it exists
[ -f /etc/profile.d/kiss_path.sh ] && \
    . /etc/profile.d/kiss_path.sh

# source stuff from ~/bin
. ~/bin/shtat

lines() { sed "${1},+${2}!d" "$3"; }
s() { systemctl --user "${1:-status}" "${2:-bot}" ;}
pc() { echo "$@" | pescli -q; }
gc() {
    h="$1" rr="$2"
    shift 2
    git clone "https://github.com/$h/$rr" "$@" --recurse;
}

if has systemctl; then
    alias sysu='systemctl --user'
fi

if has doas; then
    alias d='doas'
else
    alias d='sudo'
fi

if has exa; then
    alias l='exa -F'
    alias tree='exa --tree --git-ignore'  # use exa's tree instead
    alias ls='exa -lF'                    # long live exa!
    alias lsd='exa -alF'                  # ^^
else
    alias lsd='ls -halF'                  # fallback to ls
    alias l='/bin/ls -F --color=always'   #
    alias ls='ls -lF'                     #

    eval $(dircolors)
fi

if has peaclock; then
    alias peaclock='LC_ALL=C peaclock'   # fix peaclock on musl
fi

if has bc; then
    alias bc="bc -ql"                    # basic calculator
fi

alias gst='git status'               # darn  you, git
alias p='pwd'                        # where does laziness become insanity?
alias h='cd ~'                       # ...
alias c='clear'                      # ...
alias cl='c; l'
alias t='touch'                      # ...
alias grep='grep --colour=auto'      # color by default
alias mv="mv -i"                     # prevent $(mv x.h x.c) ugh
alias cp="cp -i"                     # confirm before overwriting files
alias rm='rm -i'                     # confirm before deleting a file
alias df='df -h'                     # show human-readable sizes
alias free='free -m'                 # show sizes in MB
alias f="factor"

set -o vi

case $SHELL in
    *mksh*)
        set -o noclobber             # uhg
        set -o ignoreeof             # no accidental exits in ssh sessions
        set -o bgnice
        set -o vi-tabcomplete
    ;;
esac

# I have no idea what this does
#
# I mean, it's been in here for ages anyway, since my first distro (Manjaro) in
# fact, so why bother taking it out...
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

    # wrap nonprintables (for mksh)
    printf '\1\r'

    # print '%' just in case last command didn't print a newline,
    # then print a bunch of spaces if a newline was output;
    # the spaces will not stay on a line and we can output a carriage
    # return to get back to the start of the line. otherwise,
    # the spaces will wrap to the next line, where we can safely
    # carriage return to the start of the line and print out prompt.
    # this hack prevents out prompt from being messed up by some
    # idiotic programs that don't print their newlines.
    sz=$((COLUMNS-2))
    printf "\1\033[7m%%\033[0m%-${sz}s\r\1" \
        " "

    # print a carriage return and change window title
    printf "\1\033]0;%s\a\1" "$USER@$(hostname):$mypwd"

    # print hostname/path
    printf '\1\033[33m\1%s\1\033[7m\1%s\1\033[27;100m\1%s'\
        "" "$(hostname)" ""
    printf '\1\033[97;100m\1 %s\1\033[90;40m\1%s\1\033[m\1' \
        "$mypwd" ""

    #if [ "$(whoami)" = "root" ]; then
    #    printf '%s' "#"
    #else
    #    printf '%s' "$"
    #fi

    # print a space
    printf ' '
}

PS1="\$(prompt)"
