---@class config.util
---@field root config.util.root
---@field telescope config.util.telescope
---@field plugins config.util.plugins
---@field formatting config.util.formatting
local M = {}

M.root = require "config.util._root"
M.telescope = require "config.util._telescope"
M.plugins = require "config.util._plugins"
M.formatting = require "config.util._formatting"

return M
