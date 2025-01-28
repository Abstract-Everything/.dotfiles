return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "b0o/SchemaStore.nvim",
    },
    opts = function(_, options)
      return vim.tbl_deep_extend("force", options, {
        servers = {
          jsonls = {
            settings = {
              json = {
                format = {
                  enable = true,
                },
                schemas = require("schemastore").json.schemas(),
                validate = { enable = true },
              },
            },
          },
        },
      })
    end,
  },
}
