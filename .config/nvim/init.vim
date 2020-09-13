" Plugins

call plug#begin()
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

" Colour Scheme

set termguicolors

colorscheme flattened_light

" Editing

set number
set relativenumber

" Miscellaneous
source ~/.config/nvim/wsl.vim
