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
          fflags = {
            -- enable_by_default = true,
            -- enable_new_solver = true,
          },
          server = {
            root_dir = function(path)
              return vim.fs.root(path, ".git")
            end,
            settings = {
              ["luau-lsp"] = {
                completion = {
                  imports = {
                    enabled = true,
                    requireStyle = "alwaysAbsolute",
                  },
                },
              },
            },
          },
        },
      },
      setup = {
        luau_lsp = function(capabilities, options)
          local opts = vim.tbl_deep_extend("error", options, {
            server = {
              capabilities = capabilities,
            },
          })

          require("luau-lsp").setup(opts)
          return true
        end,
      },
    },
  },
}
