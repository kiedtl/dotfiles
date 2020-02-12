#
# kiedtl's ~/.zshrc
# https://github.com/kiedtl/dotfiles
#

export PATH=/home/kiedtl/usr/local/bin:/home/kiedtl/bin:/usr/local/bin:$PATH
export LANG=en_US.UTF-8
export EDITOR=nvim
export VISUAL=nvim
export XDG_CONFIG_HOME="${HOME}/etc"

# pastel config
export PASTEL_COLOR_MODE=24bit

# mailx/fdm config
export MAIL="${HOME}/var/mail/INBOX"

# bat config
export BAT_THEME="OneHalfLight"

# nnn config
export NNN_USE_EDITOR=1

# for Rust development
export RUSTFLAGS="-C link-args=-fuse-ld=gold"
export RUST_BACKTRACE=1

# source stuff from bin scripts
. "${HOME}/bin/c"                         # clear/cd/cat stuffed into one command
. "${HOME}/bin/h"                         # "cd /home/kiedtl"

alias bc="bc -ql"                         # basic calculator
alias p='pwd'                             # where does laziness become insanity?
alias t='touch'                           # ...
alias l='exa'                             # ...
alias git='hub'                           # hub: git + hub = github 8-)
alias tree='exa --tree --git-ignore'      # use exa's tree instead
alias ls='exa -l'                         # long live exa!
alias lsd='exa -al'
alias grep='grep --colour=auto'           # color by default
alias cp="cp -i"                          # confirm before overwriting files
alias rm='rm -i'                          # confirm before deleting a file
alias df='df -h'                          # show human-readable sizes
alias free='free -m'                      # show sizes in MB

bindkey -v                                # long live vi command-line editing! ;P
setopt extendedglob                       # enable extended globbing
setopt autocd                             # automagically cd into directories
setopt histignoredups                     # don't push duplicates into history
setopt noclobber                          # ugh
setopt interactivecomments                # enable interactive comments

# I have no idea what this does ;)
# it's been in here for ages anyway,
# why take it out...
xhost +local:root > /dev/null 2>&1

# retrieve colorscheme
(cat ~/.cache/wal/sequences &)

# my mnmlist prompt
precmd() {
	pwd=$(echo $PWD | sed "s/\/home\/${USER}/~/")
	echo -ne "\033]0;${USER}@${HOST}:${pwd}\007"
}

export PS1="%2~ > "
