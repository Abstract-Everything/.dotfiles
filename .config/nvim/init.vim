" Plugins

call plug#begin()

Plug 'gruvbox-community/gruvbox'

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'raghur/vim-ghost', {'do': ':GhostInstall'}
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'Pocco81/AutoSave.nvim'
call plug#end()

" Coc Extensions
let g:coc_global_extensions = ['coc-clangd', 'coc-pyright', 'coc-cmake']

" User interface
"" Colour Scheme

set termguicolors

"" Number Column
set number
set relativenumber

if has("patch-8.1.1564")
	set signcolumn=number
else
	set signcolumn=yes
endif

"" Editor Window
autocmd CursorHold * silent call CocActionAsync('highlight')

" User Experience
" Clear highlight on esc
" To learn using Ctrl + c for changing to normal mode
inoremap <silent><esc> <nop>
vnoremap <silent><esc> <nop>
nnoremap <silent><C-c> <C-c>:noh<return>
inoremap <silent><C-c> <C-c>

" Key binding
"" Editing
nmap <silent> gR <Plug>(coc-rename)

""" Code Formatting
xmap <silent> = <Plug>(coc-format-selected)
nmap <silent> = <Plug>(coc-format-selected)
nmap <leader>= <Plug>(coc-format)

""" Comprehension
function! s:show_documentation()
	if (index(['vim', 'help'], &filetype) >= 0)
		execute 'h '.expand('<cword>')
	else
		call CocAction('doHover')
	endif
endfunction
nnoremap <silent> K :call <SID>show_documentation()<CR>

""" Jumping
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

""" Jump to errors
nmap <silent> <C-n> <Plug>(coc-diagnostic-next)
nmap <silent> <C-p> <Plug>(coc-diagnostic-prev)

"" Others

nmap <silent> <C-A-f> :Files<CR>
nmap <silent> <C-f> :GFiles<CR>

" Commands
command! Configuration :Files ~/.config
command! Source :source ~/.config/nvim/init.vim

" Miscellaneous
source ~/.config/nvim/wsl.vim
