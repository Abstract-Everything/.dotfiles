---@class Config
---@field root config.Root
---@field telescope config.Telescope
---@field plugins config.Plugins
---@field formatting config.Formatting
local M = {}

M.root = require "config.root"
M.telescope = require "config.telescope"
M.plugins = require "config.plugins"
M.formatting = require "config.formatting"

return M
