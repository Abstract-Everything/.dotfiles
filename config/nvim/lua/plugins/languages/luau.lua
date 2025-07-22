return {
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, options)
      local nls = require "null-ls"
      options.sources = vim.list_extend(options.sources or {}, {
        nls.builtins.formatting.stylua,
        nls.builtins.diagnostics.selene,
      })
    end,
  },
  {
    "lopi-py/luau-lsp.nvim",
    opts = {
      servers = {
        luau_lsp = {
          fflags = {
            -- enable_by_default = true,
            -- enable_new_solver = true,
          },
        },
      },
    },
  },
}
