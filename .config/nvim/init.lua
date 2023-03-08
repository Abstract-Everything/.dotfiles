-- Notes
-- To see which lsp servers are supported by lsp-config type ':h lspconfig-all'

-- Plug
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
	-- Package manager
	use 'wbthomason/packer.nvim'

	-- Project management
	use {
		"ahmedkhalf/project.nvim",
		config = function()
			require("project_nvim").setup{
				detection_methods = { "pattern" }
			}
		end
	}

	-- Theme
	use 'gruvbox-community/gruvbox'

	use 'Pocco81/auto-save.nvim'

	-- Scripting
	use "nvim-lua/plenary.nvim"

	-- Searching tools
	use {
		'nvim-telescope/telescope.nvim',
		requires = { 'nvim-lua/plenary.nvim' }
	}

	use {
		'nvim-telescope/telescope-fzf-native.nvim',
		run = [[
			'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release' 
			'&& cmake --build build --config Release'
			'&& cmake --install build --prefix build'
		]]
	}

	-- Navigating code
	use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
	use 'nvim-treesitter/nvim-treesitter-textobjects'

	-- Tools for writing code
	use 'neovim/nvim-lspconfig'

	--- Snippets
	use ({
		"L3MON4D3/LuaSnip",
		-- install jsregexp (optional!:).
		run = "make install_jsregexp"
	})
	use 'rafamadriz/friendly-snippets'

	use 'hrsh7th/nvim-cmp'
	use 'hrsh7th/cmp-calc'
	use 'hrsh7th/cmp-buffer'
	use 'hrsh7th/cmp-path'
	use 'hrsh7th/cmp-nvim-lsp'
	use 'hrsh7th/cmp-nvim-lsp-signature-help'
	use 'hrsh7th/cmp-nvim-lua'
	use 'saadparwaiz1/cmp_luasnip'
	use 'p00f/clangd_extensions.nvim'

	-- Tools for debugging
	use { "mfussenegger/nvim-dap" }
	-- use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }

	-- Ecosystem
	use {
		"sindrets/diffview.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
		},
	}

	use {
		'TimUntersberger/neogit',
		requires = { 'nvim-lua/plenary.nvim', 'sindrets/diffview.nvim' }
	}
end)

-- Options
--- Visuals
vim.g.gruvbox_italic = '1'
vim.g.gruvbox_contrast_dark = 'hard'
vim.g.gruvbox_invert_selection = '0'
vim.g.gruvbox_color_column = 'dark0_soft'
vim.g.gruvbox_sign_column = 'bg0'
vim.g.gruvbox_number_column = 'bg0'

vim.o.termguicolors = true
vim.o.background = 'dark'
vim.cmd [[colorscheme gruvbox]]
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
vim.o.colorcolumn = '81'
vim.o.updatetime = 250
vim.opt.completeopt = { 'menuone', 'noselect', 'noinsert' }

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

vim.keymap.set('n', ']q', ':cnext<return>', silent_noremap)
vim.keymap.set('n', '[q', ':cprev<return>', silent_noremap)

local initpath = vim.fn.stdpath('config') .. package.config:sub(1, 1) .. 'init.lua'
vim.api.nvim_create_user_command('Source', 'source ' .. initpath, { nargs = 0 })
vim.api.nvim_create_user_command('Configuration', function()
	require('telescope.builtin').find_files({ cwd = '~/.config', hidden = true})
end, { nargs = 0 })

--- auto-save
require("auto-save").setup {
	condition = function(bufnr)
		local Job = require'plenary.job'
		local directory = vim.fn.expand('%:h')
		local filename = vim.fn.expand('%:p')

		if vim.fn.getbufvar(bufnr, "&modifiable") ~= 1
		   or filename == "" then
			return false
		end

		-- Only activate auto-save for files under version control
		local _, return_code = Job:new({
			command = 'git',
			args = { 'ls-files', '--error-unmatch', filename },
			cwd = directory
		}):sync()
		return return_code == 0
	end
}

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

-- Treesitter
require('nvim-treesitter.configs').setup {
	auto_install = true,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = 'gnn',
			node_incremental = 'grn',
			scope_incremental = 'grc',
			node_decremental = 'grm',
		},
	},
	indent = {
		enable = true,
	},
	textobjects = {
		select = {
			enable = true,
			lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				['af'] = '@function.outer',
				['if'] = '@function.inner',
				['ac'] = '@class.outer',
				['ic'] = '@class.inner',
				['ap'] = '@parameter.outer',
				['ip'] = '@parameter.inner',
			},
		},
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				[']f'] = '@function.outer',
				[']['] = '@class.outer',
				[']p'] = '@parameter.outer',
			},
			goto_next_end = {
				[']F'] = '@function.outer',
				[']]'] = '@class.outer',
				[']P'] = '@parameter.outer',
			},
			goto_previous_start = {
				['[f'] = '@function.outer',
				['[['] = '@class.outer',
				['[p'] = '@parameter.outer',
			},
			goto_previous_end = {
				['[F'] = '@function.outer',
				['[]'] = '@class.outer',
				['[P'] = '@parameter.outer',
			},
		},
	},
}

vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'

---- Language server protocol
function format_range_operator(...)
	local old_func = vim.go.operatorfunc
	_G.op_func_formatting = function()
		local start = vim.api.nvim_buf_get_mark(0, '[')
		local finish = vim.api.nvim_buf_get_mark(0, ']')
		vim.lsp.buf.range_formatting({}, start, finish)
		vim.go.operatorfunc = old_func
		_G.op_func_formatting = nil
	end
	vim.go.operatorfunc = 'v:lua.op_func_formatting'
	vim.api.nvim_feedkeys('g@', 'n', false)
end

local on_attach = function(client, bufnr)
	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd',         '<cmd>lua vim.lsp.buf.definition()<CR>', silent_noremap)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD',         '<cmd>lua vim.lsp.buf.type_definition()<CR>', silent_noremap)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi',         '<cmd>lua vim.lsp.buf.implementation()<CR>', silent_noremap)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr',         '<cmd>lua vim.lsp.buf.references()<CR>', silent_noremap)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K',          '<cmd>lua vim.lsp.buf.hover()<CR>', silent_noremap)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>',      '<cmd>lua vim.lsp.buf.signature_help()<CR>', silent_noremap)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', silent_noremap)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', silent_noremap)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', silent_noremap)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', silent_noremap)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', silent_noremap)
end

local custom_configuration = {}

custom_configuration['lua_ls'] = {
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

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local servers = { 'cmake', 'lua_ls', 'pyright', 'csharp_ls', 'texlab' }
for _, lsp in pairs(servers) do
	require('lspconfig')[lsp].setup(vim.tbl_deep_extend("force", {
		on_attach = on_attach,
		capabilities = capabilities
	}, custom_configuration[lsp] or {}))
end

require("clangd_extensions").setup {
	server = {
		on_attach = on_attach,
		capabilities = capabilities
	},
	extensions = {
		autoSetHints = true,
		inlay_hints = {
			only_current_line = false,
			only_current_line_autocmd = "CursorHold",
			show_parameter_hints = true,
			parameter_hints_prefix = "<- ",
			other_hints_prefix = "=> ",
			max_len_align = false,
			max_len_align_padding = 1,
			right_align = false,
			right_align_padding = 81,
			highlight = "Comment",
			priority = 100,
		},
		ast = {
			role_icons = {
				type = "",
				declaration = "",
				expression = "",
				specifier = "",
				statement = "",
				["template argument"] = "",
			},

			kind_icons = {
				Compound = "",
				Recovery = "",
				TranslationUnit = "",
				PackExpansion = "",
				TemplateTypeParm = "",
				TemplateTemplateParm = "",
				TemplateParamObject = "",
			},

			highlights = {
				detail = "Comment",
			},

			memory_usage = {
				border = "none",
			},

			symbol_info = {
				border = "none",
			},
		},
	}
}

-- Debug Adapter Protocol
local dap = require('dap')

dap.adapters.lldb = {
	type = 'executable',
	command = '/usr/bin/lldb-vscode',
	name = 'lldb'
}

-- launch.json uses type both the filetype and the adapter. Having this alias
-- adapter allows us to add a configuration to cpp and use the correct adapter
dap.adapters.cpp = dap.adapters.lldb

dap.configurations.cpp = {
	{
		name = 'launch cpp',
		type = 'lldb',
		request = 'launch',
		program = function()
			return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
		end,
		cwd = '${workspaceFolder}',
		stopOnEntry = true,
		args = {},
	}
}

-- Place project specific configurations in ${worksapce}/.config/dap.json
-- Example configuration:
-- {
-- 	"version": "0.2.0",
-- 	"configurations": [
-- 		{
-- 			"name": "Test configuration",
-- 			"type": "cpp",
-- 			"request": "launch",
-- 			"program": "/path/to/program",
-- 			"args": { "arg1", "arg2" },
-- 			"stopOnEntry": true
-- 		}
-- 	]
-- }
local load_project_dap_configurations = function()
	require('dap.ext.vscode').load_launchjs(vim.fn.getcwd() .. '/.config/dap.json')
end

vim.api.nvim_create_user_command('Debug', function()
	load_project_dap_configurations()

	local configurations = {}

	for name, list in pairs(dap.configurations) do
		for i in pairs(list) do
			table.insert(configurations, list[i])
		end
	end

	if #configurations == 0 then
		print('No configurations available to run')
		return
	end

	vim.ui.select(configurations, {
		prompt = 'Select which configuration to launch',
		format_item = function(configuration)
			return configuration.name
		end,
	}, function(configuration)
		if (configuration) then
			require'dap'.run(configuration)
		end
	end)
end, { nargs = 0 })

vim.api.nvim_set_keymap('n', '<leader>dr', "<cmd>lua require('dap').run_last()<CR>", silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>db', "<cmd>lua require('dap').toggle_breakpoint()<CR>", silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>dh', "<cmd>lua require('dap').run_to_cursor()<CR>", silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>dc', "<cmd>lua require('dap').continue()<CR>", silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>ds', "<cmd>lua require('dap').step_into()<CR>", silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>dn', "<cmd>lua require('dap').step_over()<CR>", silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>df', "<cmd>lua require('dap').step_out()<CR>", silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>dt', "<cmd>lua require('dap').repl.open()<CR>", silent_noremap)

--- Snippets
local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local luasnip = require("luasnip")
require('luasnip.loaders.from_vscode').lazy_load()

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
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({ select = true, }),
		['<Tab>'] = cmp.mapping(function(fallback)
			if luasnip.expand_or_locally_jumpable() then
				luasnip.expand_or_jump()
			elseif has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end, { 'i', 's' }),
		['<S-Tab>'] = cmp.mapping(function(fallback)
			if luasnip.locally_jumpable( -1) then
				luasnip.jump( -1)
			else
				fallback()
			end
		end, { 'i', 's' }),
	}),
	sources = cmp.config.sources({
		{ name = 'path' },
		{ name = 'nvim_lsp' },
		{ name = 'nvim_lsp_signature_help' },
		{ name = 'nvim_lua' },
		{ name = 'buffer' },
		{ name = 'luasnip' },
		{ name = 'calc' },
	}),
	sorting = {
		comparators = {
			cmp.config.compare.offset,
			cmp.config.compare.exact,
			cmp.config.compare.recently_used,
			require("clangd_extensions.cmp_scores"),
			cmp.config.compare.kind,
			cmp.config.compare.sort_text,
			cmp.config.compare.length,
			cmp.config.compare.order,
		},
	},
})

require("neogit").setup {
	disable_signs = false,
	disable_hint = false,
	disable_context_highlighting = false,
	disable_commit_confirmation = false,
	-- Neogit refreshes its internal state after specific events, which can be expensive depending on the repository size.
	-- Disabling `auto_refresh` will make it so you have to manually refresh the status after you open it.
	auto_refresh = true,
	disable_builtin_notifications = false,
	use_magit_keybindings = false,
	-- Change the default way of opening neogit
	kind = "tab",
	-- Change the default way of opening the commit popup
	commit_popup = {
		kind = "split",
	},
	-- Change the default way of opening popups
	popup = {
		kind = "split",
	},
	-- customize displayed signs
	signs = {
		-- { CLOSED, OPENED }
		section = { ">", "v" },
		item = { ">", "v" },
		hunk = { "", "" },
	},
	integrations = {
		diffview = true
	},
	-- Setting any section to `false` will make the section not render at all
	sections = {
		untracked = {
			folded = false
		},
		unstaged = {
			folded = false
		},
		staged = {
			folded = false
		},
		stashes = {
			folded = true
		},
		unpulled = {
			folded = true
		},
		unmerged = {
			folded = false
		},
		recent = {
			folded = true
		},
	},
	-- override/add mappings
	mappings = {
		-- modify status buffer mappings
		status = {
			-- Adds a mapping with "B" as key that does the "BranchPopup" command
			["B"] = "BranchPopup",
			-- Removes the default mapping of "s"
			["s"] = "",
		}
	}
}

