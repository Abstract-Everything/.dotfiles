# Command Aliases

function dotfiles
{
  git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}
