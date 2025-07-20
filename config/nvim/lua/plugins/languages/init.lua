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
  { import = "plugins.languages.specific" },
}
