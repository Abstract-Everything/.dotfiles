---@class config.util
---@field root config.util.root
---@field telescope config.util.telescope
local M = {}

M.root = require "config.util._root"
M.telescope = require "config.util._telescope"

function M.setup()
  M.root.setup()
  M.telescope.setup()
end

return M
