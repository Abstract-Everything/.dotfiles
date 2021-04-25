#!/usr/bin/env bash

if ! type git >/dev/null
then
	echo "Error: git is not installed, aborting."
	exit
fi

dotfiles_name=.dotfiles
dotfiles_dir=${HOME}/${dotfiles_name}
dotfiles_backupdir=${HOME}/.dotfiles-backup

function dotfiles {
	git --git-dir=${dotfiles_dir} --work-tree=${HOME} $@
}

function mkdir_mv {
	local dir=$(dirname "./${2}")
	echo "Backing up: ${1}";
	mkdir -p -- ${dir}
	mv -- ${1} ${2}
}
export -f mkdir_mv

echo "Installing Dotfiles."
cd ${HOME}
git clone --bare https://github.com/Abstract-Everything/.dotfiles ${dotfiles_name} --quiet

dotfiles checkout --quiet &>/dev/null
if [ ${?} = 0 ]; then
	echo "Checked out dotfiles.";
else
	mkdir -p ${dotfiles_backupdir}
	echo 'Backing up pre-existing dotfiles.';
	dotfiles checkout 2>&1	\
	| egrep "\s+\."		\
	| awk {'print $1'}	\
	| xargs -I{} bash -c "mkdir_mv {} ${dotfiles_backupdir}"

	echo 'Backup done.';
fi;

dotfiles checkout
dotfiles config status.showUntrackedFiles no
echo 'Dotfiles installed.';
