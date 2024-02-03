return {
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, options)
      local nls = require "null-ls"
      options.sources = vim.list_extend(options.sources or {}, {
        nls.builtins.code_actions.shellcheck,
        nls.builtins.formatting.shfmt,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bashls = {},
      },
    },
  },
}
