return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "p00f/clangd_extensions.nvim",
    },
    opts = {
      servers = {
        clangd = {
          keys = {
            {
              "<leader>ls",
              "<cmd>ClangdSwitchSourceHeader<cr>",
            },
          },
        },
      },
    },
  },
  {
    "nvim-cmp",
    opts = function(_, opts)
      table.insert(opts.sorting.comparators, 1, require "clangd_extensions.cmp_scores")
    end,
  },
}
