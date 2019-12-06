#
# kiedtl's ~/.${SHELL}rc
# works with both bash and loksh.
# https://github.com/kiedtl/dotfiles
#

# auto-start tmux session
# don't start tmux if no X server
#if [ -z "$TMUX" ] && [ ! -z "$DISPLAY" ]; then
	  #exec tmux
#fi


export PATH=/home/kiedtl/usr/local/bin:/home/kiedtl/bin:/usr/local/bin:$PATH
export LANG=en_US.UTF-8
export EDITOR=vim
export VISUAL=vim
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

# for Rust debugging
export RUST_BACKTRACE=1

# aliases
clo() {
	unset LANGUAGE;
	LANG=C peaclock
}

alias git='hub'  			  # hub: git + hub = github 8-)
alias tree='exa --tree --git-ignore'
alias l='exa'
alias ls='exa -l'
alias lsd='exa -al'
alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'
alias fgrep='fgrep --colour=auto'
alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias more=less

xhost +local:root > /dev/null 2>&1

# retrieve paleta colorscheme
# cat /home/kiedtl/.cache/wal/sequences
# wall -r
paleta ~/etc/colors/paleta > /dev/null

# source functions from bin
. "${HOME}/bin/c"
. "${HOME}/bin/]"

# promptless prompt, by dylanaraps
. "${XDG_CONFIG_HOME}/loksh/prompt.sh"
