local Util = require "config.util"

return {
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, options)
      local nls = require "null-ls"
      options.sources = vim.list_extend(options.sources or {}, {
        nls.builtins.formatting.stylua,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "lopi-py/luau-lsp.nvim",
    },
    opts = {
      servers = { luau_lsp = {} },
      setup = {
        luau_lsp = function(options)
          local luau_plugin_options = Util.plugins.options "luau-lsp"
          require("luau-lsp").setup {
            vim.tbl_deep_extend(
              "force",
              luau_plugin_options or {},
              { server = { ["luau-lsp"] = { options } } }
            ),
          }
        end,
      },
    },
  },
}
