---@class Config
local M = {}

M.root = require "config.root"
M.telescope = require "config.telescope"
M.formatting = require "config.formatting"
M.keymaps = require "config.keymaps"
M.lsp = require "config.lsp"

M.debug_logs = false

return M
