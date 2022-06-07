-- Plug ins
--- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
	command = 'source <afile> | PackerCompile', group = packer_group, pattern = 'init.lua'
})

require('packer').startup(function(use)
	--- Package manager
	use 'wbthomason/packer.nvim'

	-- Theme
	use 'gruvbox-community/gruvbox'

	use 'Pocco81/AutoSave.nvim'

	--- Searching tools
	use { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim' } }
	use {'nvim-telescope/telescope-fzf-native.nvim', run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }

	--- Tools for writing code
	use 'neovim/nvim-lspconfig'
	use 'hrsh7th/nvim-cmp'
	use 'hrsh7th/cmp-nvim-lsp'
	use 'hrsh7th/cmp-buffer'

	--- Snippets
	use 'saadparwaiz1/cmp_luasnip'
	use 'rafamadriz/friendly-snippets'
	use 'L3MON4D3/LuaSnip'
end)

-- Options
--- Visuals
vim.g.gruvbox_italic = '1'
vim.g.gruvbox_contrast_dark = 'hard'
vim.g.gruvbox_contrast_light = 'hard'
vim.g.gruvbox_invert_selection = '0'

vim.o.termguicolors = true
vim.o.background = 'dark'
vim.cmd [[colorscheme gruvbox]]
vim.cmd [[highlight ColorColumn ctermbg=0 guibg=grey]]
vim.cmd [[highlight SignColumn guibg=none]]
vim.cmd [[highlight LineNr guifg=#5eacd3]]

--- Workspace
vim.o.exrc = true
vim.o.undofile = true
vim.o.backup = false
vim.o.swapfile = false

--- Buffers
vim.o.hidden = true

--- Searching
vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true

--- Line numbers
vim.o.number = true
vim.o.relativenumber = true

--- Editor
vim.o.scrolloff = 10
vim.o.breakindent = true
vim.o.colorcolumn = '80'
vim.o.updatetime = 250
vim.o.completeopt = 'menu,menuone,noselect'
vim.o.foldclose = 'all'

--- Status
vim.o.signcolumn = 'yes'
vim.o.ruler = true

--- Spelling
vim.o.spell = true
vim.o.spelllang = 'en_gb'

-- Configuration
local silent_noremap = { silent = true, noremap = true }
local silent_expr = { silent = true, expr = true }

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

--Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

--- Clear highlight on esc
vim.api.nvim_set_keymap('n', '<esc>', ':noh<return>', silent_noremap)

vim.keymap.set('n', '<leader>e', function() vim.diagnostic.open_float() end, silent_noremap)
vim.keymap.set('n', ']d', function() vim.diagnostic.goto_next() end, silent_noremap)
vim.keymap.set('n', '[d', function() vim.diagnostic.goto_prev() end, silent_noremap)
vim.keymap.set('n', '<leader>q', function() vim.diagnostic.setloclist() end, silent_noremap)

local initpath = vim.fn.stdpath('config') .. package.config:sub(1, 1) .. 'init.lua'
vim.api.nvim_create_user_command('Source', 'source ' .. initpath , { nargs = 0 })
vim.api.nvim_create_user_command('Configuration', function()
	require('telescope.builtin').find_files({cwd = '~/.config'})
end, { nargs = 0 })

--- Autosave
require("autosave").setup(
    {
        enabled = true,
        execution_message = "AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"),
        events = {"InsertLeave", "TextChanged"},
        conditions = {
            exists = true,
            filename_is_not = {},
            filetype_is_not = {},
            modifiable = true
        },
        write_all_buffers = false,
        on_off_commands = true,
        clean_command_line_interval = 0,
        debounce_delay = 135
    }
)

-- Telescope
local telescope = require('telescope')
telescope.setup()
telescope.load_extension 'fzf'

vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers)
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').git_files)
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files)
vim.keymap.set('n', '<leader>sb', require('telescope.builtin').current_buffer_fuzzy_find)
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags)
vim.keymap.set('n', '<leader>st', require('telescope.builtin').tags)
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').grep_string)
vim.keymap.set('n', '<leader>sp', require('telescope.builtin').live_grep)
vim.keymap.set('n', '<leader>so', function()
  require('telescope.builtin').tags { only_current_buffer = true }
end)
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles)

--- Language server protocol
local on_attach = function(client, bufnr)
	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', silent_noremap)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', silent_noremap)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', silent_noremap)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', silent_noremap)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', silent_noremap)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', silent_noremap)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', silent_noremap)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', silent_noremap)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', silent_noremap)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', silent_noremap)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', silent_noremap)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', silent_noremap)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', silent_noremap)
end

local custom_configuration = {}
custom_configuration['clangd'] = {
	cmd = { 'clangd', '--background-index' }
}

custom_configuration['sumneko_lua'] = {
	settings = {
		Lua = {
			runtime = {
				version = 'LuaJIT',
				path = vim.split(package.path, ';'),
			},
			diagnostics = {
				globals = {'vim'},
			},
			workspace = {
				library = {
					[vim.fn.expand('$VIMRUNTIME/lua')] = true,
					[vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
				},
			},
			telemetry = {
				enable = false,
			},
		}
	}
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local servers = { 'clangd', 'cmake', 'sumneko_lua', 'pyright', 'texlab' }
for _, lsp in pairs(servers) do
	require('lspconfig')[lsp].setup(vim.tbl_deep_extend("force", {
		on_attach = on_attach,
		capabilities = capabilities
	}, custom_configuration[lsp] or {}))
end

--- Snippets
local luasnip = require('luasnip')

require('luasnip.loaders.from_vscode').lazy_load()

-- This causes an error, use the nvim_set_keymap until a fix is issued
-- vim.keymap.set('i', '<Tab>', function()
-- 	luasnip = require('luasnip')
-- 	return luasnip.expand_or_jumpable() and luasnip.expand_or_jump() or '<Tab>'
-- end, silent_expr)

vim.api.nvim_set_keymap('i', '<Tab>', 'luasnip#expand_or_jumpable() ? "<Plug>luasnip-expand-or-jump" : "<Tab>"', silent_expr)

vim.keymap.set('i', '<S-Tab>', function()
	luasnip = require('luasnip')
	return luasnip.jumpable(-1) and luasnip.jump(-1) or '<Tab>'
end, silent_expr)

vim.keymap.set('s', '<Tab>', function()
	if (require('luasnip').jumpable())
	then
		require('luasnip').jump(1)
	end
end, silent_noremap)

vim.keymap.set('s', '<S-Tab>', function()
	if (require('luasnip').jumpable(-1))
	then
		require('luasnip').jump(-1)
	end
end, silent_noremap)

vim.keymap.set({ 'i', 's' }, '<C-E>', function()
	return require('luasnip').choice_active() and luasnip.next_choice()
end, silent_expr)

local cmp = require('cmp')
cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
	}, {
		{ name = 'buffer' },
	})
})

-- wsl settings
if (not vim.fn.executable("powershell.exe"))
then
	vim.cmd([[
		let g:clipboard = {
		\ 	'name': 'WslClipboard',
		\    	'copy':
		\ 	{
		\      		'+': 'clip.exe',
		\      		'*': 'clip.exe',
		\    	 },
		\    	'paste':
		\ 	{
		\    		'+': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
		\    		'*': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
		\    	},
		\    	'cache_enabled': 0,
		\ }
	]])
end

