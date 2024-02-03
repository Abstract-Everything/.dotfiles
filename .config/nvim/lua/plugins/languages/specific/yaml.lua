return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, options)
      return vim.tbl_deep_extend("force", options, {
        servers = {
          yamlls = {
            settings = {
              redhat = { telemetry = { enabled = false } },
              yaml = {
                format = {
                  enable = true,
                },
                validate = true,
                -- Disable builtin schema to use SchemaStore.nvim
                schemaStore = {
                  enable = false,
                  url = "",
                },
                schemas = require("schemastore").yaml.schemas(),
              },
            },
          },
        },
      })
    end,
  },
}
