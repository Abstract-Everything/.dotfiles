" Plugins

call plug#begin()

Plug 'gruvbox-community/gruvbox'

Plug 'Pocco81/AutoSave.nvim'

Plug 'neovim/nvim-lspconfig'

Plug 'raghur/vim-ghost', {'do': ':GhostInstall'}

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

call plug#end()

" Clear highlight on esc
nnoremap <silent><esc> <esc>:noh<return>

"" Others
nmap <silent> <C-A-f> :Files<CR>
nmap <silent> <C-f> :GFiles<CR>

" Commands
command! Configuration :Files ~/.config
command! Source :source ~/.config/nvim/init.vim

" Miscellaneous
source ~/.config/nvim/wsl.vim
