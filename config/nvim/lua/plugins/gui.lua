return {
  {
    "folke/tokyonight.nvim",
    opts = { style = "night" },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      require("tokyonight").load()
    end,
  },
  { "stevearc/dressing.nvim" },
  { "MunifTanjim/nui.nvim" },
  { "MeanderingProgrammer/render-markdown.nvim" },
  { "nvim-tree/nvim-web-devicons" },
}
