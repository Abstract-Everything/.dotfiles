return {
  {
    "Pocco81/auto-save.nvim",
    opts = {
      condition = function(bufnr)
        local Job = require "plenary.job"
        local directory = vim.fn.expand "%:h"
        if vim.fn.isdirectory(directory) == 0 then
          return false
        end

        local filename = vim.fn.expand "%:p"
        if vim.fn.getbufvar(bufnr, "&modifiable") ~= 1 or filename == "" then
          return false
        end

        -- Only activate auto-save for files under version control
        local _, return_code = Job:new({
          command = "git",
          args = { "ls-files", "--error-unmatch", filename },
          cwd = directory,
        }):sync()
        return return_code == 0
      end,
    },
  },
}
