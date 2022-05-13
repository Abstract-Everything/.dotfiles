#!/usr/bin/env bash

# Test me
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

function backup_file
{
	while read line; do
		echo "Backing up: ${line}"

		local dir=$(dirname "${line}" | sed "s|${HOME}|${dotfiles_backupdir}|g")
		mkdir -p -- "${dotfiles_backupdir}/${dir}"
		mv -- ${line} ${dotfiles_backupdir}
	done < /dev/stdin
}

echo "Setting up dotfiles."

cd ${HOME}
git clone --bare https://github.com/Abstract-Everything/.dotfiles ${dotfiles_name} --quiet

dotfiles ls-tree --full-tree -r HEAD                                                                  \
| cut -f 2                                                                                            \
| grep "\.config"                                                                                     \
| sed -E 's|.config/([^/]+).*$|\1|g'                                                                  \
| uniq                                                                                                \
| xargs -I{} find ${HOME} -not -path "${dotfiles_backupdir}/*" -regextype sed -regex ".*/\.\?{}[^/]*" \
| tac                                                                                                 \
| backup_file

dotfiles ls-tree --full-tree -r HEAD                                    \
| cut -f 2                                                              \
| grep -v "\.config"                                                    \
| xargs -I{} find ${HOME} -not -path "${dotfiles_backupdir}/*" -name {} \
| backup_file

dotfiles checkout
dotfiles config status.showUntrackedFiles no
echo 'Dotfiles setup successful.';
