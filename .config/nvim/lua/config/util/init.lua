---@class config.util
---@field root config.util.root
---@field telescope config.util.telescope
---@field plugins config.util.plugins
local M = {}

M.root = require "config.util._root"
M.telescope = require "config.util._telescope"
M.plugins = require "config.util._plugins"

function M.setup()
  M.root.setup()
  M.telescope.setup()
end

return M
