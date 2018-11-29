if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi
source ~/.profile
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
export PATH="$PATH:$(yarn global bin)"
export GH_TOKEN=5f8f383650da83faaa75f6f87a5071b5c53b5225

eval "$(hub alias -s)"

export PATH=~/usr/bin:$PATH
# Setting PATH for Python 3.6
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.6/bin:${PATH}"
export PATH

alias dev:spectrum="cd ~/sites/spectrum"