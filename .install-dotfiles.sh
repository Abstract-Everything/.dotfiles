#!/usr/bin/env bash

type git >/dev/null 2>&1 ||
{
	echo >&2 "Error: git is not installed, aborting."
	exit 1
}

dotfiles_name=.dotfiles
dotfiles_dir=${HOME}/${dotfiles_name}
dotfiles_backupdir=${HOME}/.dotfiles-backup

function dotfiles
{
	git --git-dir=${dotfiles_dir} --work-tree=${HOME} $@
}

function backup_existing_files
{
	while read line; do

		if [ ! -d "${line}" ] && [ ! -f "${line}" ]; then
			continue
		fi

		echo "Backing up: ${line}"

		local dir=$(echo "${line}" | sed "s|${HOME}|${dotfiles_backupdir}|g")
		local backup_dir="${dotfiles_backupdir}/${dir}"

		mkdir -p -- "${backup_dir}"
		mv -- ${line} "${backup_dir}"
	done < /dev/stdin
}

echo "Setting up dotfiles."

pushd ${HOME} > /dev/null
if [ -d "${dotfiles_name}" ]; then
	echo "Fatal: '${HOME}/.dotfiles' already exists. Please rename it in order to continue"
	exit 1
fi

git clone --bare https://github.com/Abstract-Everything/.dotfiles ${dotfiles_name} --quiet

dotfiles ls-tree --full-tree -r HEAD                                           \
| cut -f 2                                                                     \
| grep "\.config"                                                              \
| sed -E 's|(.config/([^/]+)).*$|\1|g'                                         \
| uniq                                                                         \
| backup_existing_files

dotfiles ls-tree --full-tree -r HEAD                                           \
| cut -f 2                                                                     \
| grep -v "\.config"                                                           \
| backup_existing_files

dotfiles checkout
dotfiles config status.showUntrackedFiles no
popd > /dev/null

echo 'Dotfiles setup successful.';
