#!/usr/bin/env bash

. ./.install-helpers.sh

echo 'Configuring coc-vim'
check_installed_program git
check_installed_program curl
check_installed_program nvim
check_installed_program node
check_installed_program npm
check_installed_program clangd
check_installed_program rg

echo 'Cloning VimPlug'
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' &>/dev/null

nvim -c 'PlugInstall|qa'
nvim -c 'CocInstall -sync coc-clangd|qa'
nvim -c 'checkhealth'
