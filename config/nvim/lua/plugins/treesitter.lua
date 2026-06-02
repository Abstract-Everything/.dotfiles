return {
  {
    "neovim-treesitter/nvim-treesitter",
    branch = "main",
    dependencies = { "neovim-treesitter/treesitter-parser-registry" },
    build = ":TSUpdate",
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = "neovim-treesitter/nvim-treesitter",
    opts = {
      select = {
        lookahead = true,
        selection_modes = {
          ["@function.outer"] = "V",
          ["@class.outer"] = "V",
          ["@parameter.outer"] = "v",
          ["@conditional.outer"] = "v",
        },
      },
      move = { set_jumps = true },
    },
    init = function()
      vim.g.no_plugin_maps = true
    end,
    config = function()
      require("nvim-treesitter-textobjects").setup {
        select = {
          lookahead = true,
          selection_modes = {
            ["@function.outer"] = "V",
            ["@class.outer"] = "V",
            ["@parameter.outer"] = "v",
            ["@conditional.outer"] = "v",
          },
        },
        move = { set_jumps = true },
      }
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    branch = "master",
    dependencies = "neovim-treesitter/nvim-treesitter",
    opts = {
      enable = true,
    },
  },
}
