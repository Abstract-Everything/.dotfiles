#!/usr/bin/env bash

function dotfiles {
	/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}

function mkdir_mv {
	local dir=$(dirname "./${2}")
	echo "Backing up: ${1}";
	mkdir -p -- ${dir}
	mv -- ${1} ${2}
}
export -f mkdir_mv

echo "Installing Dotfiles."
git clone --bare https://github.com/Abstract-Everything/.dotfiles ${HOME}/.dotfiles --quiet

dotfiles checkout --quiet &>/dev/null
if [ ${?} = 0 ]; then
	echo "Checked out dotfiles.";
else
	mkdir -p .dotfiles-backup
	echo 'Backing up pre-existing dotfiles.';
	dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} bash -c 'mkdir_mv {} .dotfiles-backup/{}'
	echo 'Backup done.';
fi;

dotfiles checkout
dotfiles config status.showUntrackedFiles no
echo 'Dotfiles installed.';

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' &>/dev/null
echo 'Cloned VimPlug'
