-- TODO:
-- better solution for autoformatting - one which does not touch undo
-- telescope quickfix keymap

-- Leader key -> ","
--
-- In general, it's a good idea to set this early in your config, because otherwise
-- if you have any mappings you set BEFORE doing this, they will be set to the OLD
-- leader.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.runtimepath:prepend(lazypath)

-- Set this so that plugins initialization sees it
vim.o.winborder = "rounded"

-- Setup lsp document highlighting
-- Checkout what codelens is
--
-- Add test runner
-- Way to manage open buffers
-- Fix luau snippets
-- Add Debug SyncAssert to lua snippets
-- Create command to fit text inside of a certain number of columns
-- Why does tab change nvim completion item? Just let CTRL N/P do the job
--
-- Add notify to custom scripts
--
-- TODO plugins to consider:
--
-- LazyVim as a reference
--
-- File traversal
--  oil.nvim
--  nvim-neo-tree/neo-tree.nvim
--
-- Editor
--  Show colours when typing them out
--  https://github.com/norcalli/nvim-colorizer.lua
--
--  Note taking and organization
--  https://github.com/nvim-neorg/neorg
--
--  Spelling
--  https://github.com/uga-rosa/cmp-dictionary
--
--  status line
--  https://github.com/nvim-lualine/lualine.nvim
--
--  interactive search and replace
--  nvim-pack/nvim-spectre
--
--  jump to text
--  folke/flash.nvim
--
--  interactively show keybindings
--  folke/which-key.nvim
--
--  show uncommited hunks
--  lewis6991/gitsigns.nvim
--
--  highlight word under cursor
--  RRethy/vim-illuminate
--
--  nicer quickfix/ location lists
--  folke/trouble.nvim
--
--  To persist buffers when closing neovim
--  folke/persistence.nvim
--
--  Notifications
--  rcarriga/nvim-notify
--
--  nicer ui
--  stevearc/dressing.nvim
--
--  indent guides
--  lukas-reineke/indent-blankline.nvim
--
--  automatic completion of pairs
--    nvim-autopairs
--    nvim-ts-autopairs
--    mini.pairs
--
--  mini.pairs
--  mini.surround
--
--  dadbod / dbee
--
--  AI
--   avante.nvim
--
--  LSP Errors
--    lsp_lines https://git.sr.ht/~whynothugo/lsp_lines.nvim
--
--  Auto formatting
--    comform.nvim
--
-- Debugging
--  Create good shortcuts for debugging
--  https://github.com/rcarriga/nvim-dap-ui
--  https://github.com/theHamsta/nvim-dap-virtual-text
--
-- Git
--  https://github.com/lewis6991/gitsigns.nvim
--  https://github.com/tpope/vim-fugitive
--  https://github.com/rhysd/git-messenger.vim
--  https://github.com/rhysd/committia.vim
--
-- A command to write into a diary/ Todo/ thoughts notebook
require("lazy").setup({
	spec = "plugins",
	dev = { path = "~/sources" },
	change_detection = { notify = false },
})
