---@class config.telescope.Options
---@field cwd? string
---@field show_untracked? boolean
---@field hidden? boolean

---@class config.Telescope
---@overload fun(builtin:string, opts?:config.telescope.Options)
local M = setmetatable({}, {
  ---@param m config.Telescope
  __call = function(m, ...)
    return m.telescope(...)
  end,
})

---@param command string
---@param opts? config.telescope.Options
function M.telescope(command, opts)
  local parameters = { command = command, opts = opts }
  return function()
    opts = vim.tbl_deep_extend("force", {
      cwd = require "config.root"(),
    }, parameters.opts or {}) --[[@as config.telescope.Options]]

    command = parameters.command
    if command == "files" then
      if opts.cwd and vim.uv.fs_stat(opts.cwd .. "/.git") then
        opts.show_untracked = true
        command = "git_files"
      else
        opts.hidden = true
        command = "find_files"
      end
    end

    require("telescope.builtin")[command](opts)
  end
end

return M
