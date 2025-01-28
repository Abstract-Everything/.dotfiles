return {
  {
    "sindrets/diffview.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      {
        "<leader>go",
        "<cmd>DiffviewOpen<cr>",
      },
      {
        "<leader>gl",
        "<cmd>DiffviewFileHistory<cr>",
      },
      {
        "<leader>gq",
        "<cmd>DiffviewClose<cr>",
      },
    },
  },
  {
    "neogitOrg/neogit",
    dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
    config = function()
      require("neogit").setup {
        integrations = {
          telescope = true,
          diffview = true,
        },
      }
    end,
  },
}
