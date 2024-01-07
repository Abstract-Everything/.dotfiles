return {
  {
    "folke/tokyonight.nvim",
    opts = { style = "night" },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      require("tokyonight").load()
    end,
  },
}
