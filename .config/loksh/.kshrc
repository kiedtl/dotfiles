#
# kiedtl's ~/.${SHELL}rc
# works with both bash and loksh.
# https://github.com/kiedtl/dotfiles
#

export PATH=/home/kiedtl/usr/local/bin:/home/kiedtl/bin:/usr/local/bin:$PATH
export LANG=en_US.UTF-8
export EDITOR=vim
export ENV=/home/kiedtl/.kshrc

# nnn config
export NNN_USE_EDITOR=1

alias git='hub'                           # hub: git + hub = github 8-)
alias ls='exa'
alias lsd='exa -l'
alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'
alias fgrep='fgrep --colour=auto'
alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias more=less

xhost +local:root > /dev/null 2>&1

# my mnmlst prmpt: the glorious $
# export PS1="$ "

# retrieve wal colorscheme
cat /home/kiedtl/.cache/wal/sequences
# wall -r

# promptless prompt, by dylanaraps
. '/home/kiedtl/.config/bash/promptless.sh'
