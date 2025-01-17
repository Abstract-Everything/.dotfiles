local LazyConfig = require "lazy.core.config"
local LazyPlugin = require "lazy.core.plugin"

---@class config.Plugins
local M = {}

---@param name string
function M.options(name)
  local plugin = LazyConfig.plugins[name]
  if not plugin then
    return {}
  end
  return LazyPlugin.values(plugin, "opts", false)
end

return M
