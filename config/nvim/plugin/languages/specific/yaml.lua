vim.lsp.config["yamlls"] = {
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
}
vim.lsp.enable "yamlls"
