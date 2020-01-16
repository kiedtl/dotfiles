#
# kiedtl's ~/.${SHELL}rc
# works (sort of) with both loksh and mksh.
# https://github.com/kiedtl/dotfiles
#

export PATH=/home/kiedtl/usr/local/bin:/home/kiedtl/bin:/usr/local/bin:$PATH
export LANG=en_US.UTF-8
export EDITOR=nvim
export VISUAL=nvim
export ENV=/home/kiedtl/.kshrc
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
export RUSTFLAGS="-C link-args=-fuse-ld=lld"
export RUST_BACKTRACE=1

# aliases
clo() {
	unset LANGUAGE;
	LANG=C peaclock ${@}
}

# source stuff from bin scripts
. "${HOME}/bin/c"
. "${HOME}/bin/h"
. "${HOME}/bin/z"

alias p='pwd'
alias t='touch'
alias l='exa'
alias git='hub'  			  # hub: git + hub = github 8-)
alias tree='exa --tree --git-ignore'
alias ls='exa -l'
alias lsd='exa -al'
alias grep='grep --colour=auto'
alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB

# long live vi-style command-line editing! :P
set -o vi

# the csh !bang feature
set -o csh-history

# I have no idea what this does ;)
xhost +local:root > /dev/null 2>&1

# retrieve colorscheme
paleta ~/etc/colors/waters > /dev/null

# my mnmlist prompt
if [ "${USER}" = "root" ]; then
	export PS1="# "
else
	export PS1="$ "
fi
