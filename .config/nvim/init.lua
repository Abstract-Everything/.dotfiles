-- Leader key -> ","
--
-- In general, it's a good idea to set this early in your config, because otherwise
-- if you have any mappings you set BEFORE doing this, they will be set to the OLD
-- leader.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  }
end
vim.opt.runtimepath:prepend(lazypath)

require("config").setup()

-- Setup lsp document highlighting
-- Checkout what codelens is
--
-- TODO plugins to consider:
--
-- LazyVim as a reference
--
-- File traversal
--	nvim-neo-tree/neo-tree.nvim
--
-- Editor
--	Show colours when typing them out
--	https://github.com/norcalli/nvim-colorizer.lua
--
--	Note taking and organization
--	https://github.com/nvim-neorg/neorg
--
--	Spelling
--	https://github.com/uga-rosa/cmp-dictionary
--
--	status line
--	https://github.com/nvim-lualine/lualine.nvim
--
--	interactive search and replace
--	nvim-pack/nvim-spectre
--
--	jump to text
--	folke/flash.nvim
--
--	interactively show keybindings
--	folke/which-key.nvim
--
--	show uncommited hunks
--	lewis6991/gitsigns.nvim
--
--	highlight word under cursor
--	RRethy/vim-illuminate
--
--	nicer quickfix/ location lists
--	folke/trouble.nvim
--
--	To persist buffers when closing neovim
--	folke/persistence.nvim
--
--	Notifications
--	rcarriga/nvim-notify
--
--	nicer ui
--	stevearc/dressing.nvim
--
--	indent guides
--	lukas-reineke/indent-blankline.nvim
--
-- Debugging
--	https://github.com/rcarriga/nvim-dap-ui
--	https://github.com/theHamsta/nvim-dap-virtual-text
--
-- Git
--	https://github.com/lewis6991/gitsigns.nvim
--	https://github.com/tpope/vim-fugitive
--	https://github.com/rhysd/git-messenger.vim
--	https://github.com/rhysd/committia.vim
--
-- A command to write into a diary/ Todo/ thoughts notebook
require("lazy").setup {
  dev = { path = "~/sources" },
  spec = "plugins",
}
