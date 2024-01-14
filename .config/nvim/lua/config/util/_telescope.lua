---@class config.util.telescope.opts
---@field cwd? string
---@field show_untracked? boolean

---@class config.util.telescope
---@overload fun(builtin:string, opts?:config.util.telescope.opts)
local M = setmetatable({}, {
  ---@param m config.util.telescope
  __call = function(m, ...)
    return m.telescope(...)
  end,
})

function M.setup() end

---@param command string
---@param opts? config.util.telescope.opts
function M.telescope(command, opts)
  return function()
    opts = vim.tbl_deep_extend("force", {
      cwd = require "config.util._root"(),
    }, opts or {}) --[[@as config.util.telescope.opts]]

    if command == "files" then
      if opts.cwd and vim.loop.fs_stat(opts.cwd .. "/.git") then
        opts.show_untracked = true
        command = "git_files"
      else
        command = "find_files"
      end
    end

    require("telescope.builtin")[command](opts)
  end
end

return M
