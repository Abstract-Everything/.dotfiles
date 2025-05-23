return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {},
      setup = {},
    },
    config = function(_, options)
      require("config").lsp.setup(options)
    end,
  },
  {
    "williamboman/mason.nvim",
    config = function(_, options)
      require("mason").setup(options)
    end,
  },
  { import = "plugins.languages.specific" },
}
