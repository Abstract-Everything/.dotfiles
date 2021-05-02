" Plugins

call plug#begin()
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'raghur/vim-ghost', {'do': ':GhostInstall'}
call plug#end()

" Coc Extensions
let g:coc_global_extensions = ['coc-clangd', 'coc-pyright']

" Colour Scheme

set termguicolors

colorscheme flattened_light

" User interface
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

" Editing
" Key binding
function! s:show_documentation()
	if (index(['vim', 'help'], &filetype) >= 0)
		execute 'h '.expand('<cword>')
	else
		call CocAction('doHover')
	endif
endfunction
nnoremap <silent> K :call <SID>show_documentation()<CR>

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gR <Plug>(coc-rename)

nmap <silent> <C-n> <Plug>(coc-diagnostic-next)
nmap <silent> <C-p> <Plug>(coc-diagnostic-prev)

" Miscellaneous
source ~/.config/nvim/wsl.vim
