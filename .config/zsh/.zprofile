# In order to source this file, define 'export ZDOTDIR=$HOME/.config'
#   /etc/profile.d/<file>
#   $HOME/.zshenv
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

export VISUAL=nvim
export EDITOR="$VISUAL"
export BROWSER=qutebrowser

typeset -U path PATH
path=(~/.cargo/bin ~/sources/arcanist/bin ~/.dotnet/tools ~/.local/bin /usr/local/bin $path)
export PATH
