#
# kiedtl's ~/.cshrc
# https://github.com/kiedtl/dotfiles
#

setenv PATH /home/kiedtl/usr/local/bin:/home/kiedtl/bin:/usr/local/bin:$PATH
setenv LANG en_US.UTF-8
setenv EDITOR vim

# nnn config
setenv NNN_USE_EDITOR 1

alias git 'hub'                           # hub: git + hub = github 8-)
alias ls 'exa'
alias lsd 'exa -l'
alias grep 'grep --colour=auto'
alias egrep 'egrep --colour=auto'
alias fgrep 'fgrep --colour=auto'
alias cp "cp -i"                          # confirm before overwriting something
alias df 'df -h'                          # human-readable sizes
alias free 'free -m'                      # show sizes in MB

xhost +local:root >& /dev/null

complete -cf sudo

# retrieve wal colorscheme
cat /home/kiedtl/.cache/wal/sequences

# promptless prompt, by dylanaraps
if ($?prompt) then
	set prompt='➜ '
endif
