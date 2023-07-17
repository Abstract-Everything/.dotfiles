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
    "--branch=stable", -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- TODO plugins to consider:
-- Editor
-- 	Show colours when typing them out
-- 	https://github.com/norcalli/nvim-colorizer.lua
--
-- 	Easy commenting
-- 	https://github.com/numToStr/Comment.nvim
--
-- 	Note taking and organization
-- 	https://github.com/nvim-neorg/neorg
--
-- Debugging
-- 	https://github.com/rcarriga/nvim-dap-ui
-- 	https://github.com/theHamsta/nvim-dap-virtual-text
--
-- Git
-- 	https://github.com/lewis6991/gitsigns.nvim
-- 	https://github.com/tpope/vim-fugitive
-- 	https://github.com/rhysd/git-messenger.vim
-- 	https://github.com/rhysd/committia.vim
--
-- A command to write into a diary/ Todo/ thoughts notebook
require("lazy").setup "plugins"
