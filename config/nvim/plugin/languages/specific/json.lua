vim.lsp.config["jsonls"] = {
  settings = {
    json = {
      format = {
        enable = true,
      },
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
}
vim.lsp.enable "jsonls"
