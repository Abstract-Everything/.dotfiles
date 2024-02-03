return {
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, options)
      local nls = require "null-ls"
      options.sources = vim.list_extend(options.sources or {}, {
        nls.builtins.diagnostics.cmake_lint,
        nls.builtins.formatting.gersemi,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        neocmake = {},
      },
    },
  },
}
