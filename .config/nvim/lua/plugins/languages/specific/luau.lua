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
    "neovim/nvim-lspconfig",
    dependencies = {
      "lopi-py/luau-lsp.nvim",
    },
    opts = {
      servers = {
        luau_lsp = {
          completion = {
            imports = {
              enabled = true,
              requireStyle = "alwaysAbsolute",
            },
          },
        },
      },
      setup = {
        luau_lsp = function(options)
          require("luau-lsp").setup {
            server = { settings = { ["luau-lsp"] = options } },
          }
        end,
      },
    },
  },
}
