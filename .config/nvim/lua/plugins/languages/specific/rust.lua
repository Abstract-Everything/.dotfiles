local Util = require "config.util"

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- https://rsdlt.github.io/posts/rust-nvim-ide-guide-walkthrough-development-debug/
      "simrat39/rust-tools.nvim",
      dependencies = { "rust-lang/rust.vim" },
    },
    opts = {
      servers = {
        rust_analyzer = {
          keys = {
            {
              "K",
              function()
                require("rust-tools").hover_actions.hover_actions()
              end,
            },
            {
              "<leader>cA",
              function()
                require("rust-tools").code_action_group.code_action_group()
              end,
            },
          },
        },
      },
      setup = {
        rust_analyzer = function(options)
          local rust_plugin_options = Util.plugins.options "rust-tools"
          require("rust-tools").setup {
            vim.tbl_deep_extend("force", rust_plugin_options or {}, { server = options }),
          }
        end,
      },
    },
  },
}
