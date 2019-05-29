# Import colorscheme from pywal
(cat ~/.cache/wal/sequences &)
source ~/.cache/wal/colors-tty.sh

export PATH=$HOME/bin:/home/kiedtl/.gem/ruby/2.6.0/bin:/home/kiedtl/go/bin:$PATH
export PATH=/home/kiedtl/.cargo/bin:/root/.local/bin:$PATH
export BH_FILTER="(feh)"
export BUILDDIR=~/build/

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='nano'
else
   export EDITOR='nano'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#

alias zshconfig="vim ~/.zshrc"

extract ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.xz)     tar xvf $1     ;;
      *.tar.bz2)    tar xjf $1     ;;
      *.tar.gz)     tar xzf $1     ;;
      *.bz2)        bunzip2 $1     ;;
      *.rar)        unrar x $1     ;;
      *.gz)         gunzip $1      ;;
      *.tar)        tar xf $1      ;;
      *.tbz2)       tar xjf $1     ;;
      *.tgz)        tar xzf $1     ;;
      *.zip)        unzip $1       ;;
      *.Z)          uncompress $1  ;;
      *.7z)         7z x $1        ;;
      *)            echo "'$1' cannot be extracted!" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Polyglot prompt
. ~/bin/polyglot

# only load it for interactive shells
if [[ $- == *i* ]] && command -v shellhistory-location &>/dev/null; then
    . $(shellhistory-location)
    shellhistory enable
fi

# Bashhub.com Installation
if [ -f ~/.bashhub/bashhub.zsh ]; then
    source ~/.bashhub/bashhub.zsh
fi
