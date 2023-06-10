export VISUAL=nvim
export EDITOR="$VISUAL"
export BROWSER=qutebrowser

typeset -U path PATH
path=(~/.cargo/bin ~/sources/arcanist/bin ~/.dotnet/tools ~/.local/bin /usr/local/bin $path)
export PATH
