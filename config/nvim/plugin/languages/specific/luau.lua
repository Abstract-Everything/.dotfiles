vim.lsp.config["luau-lsp"] = {
  settings = {
    ["luau-lsp"] = {
      completion = {
        imports = {
          enabled = true,
          requireStyle = "alwaysAbsolute",
        },
      },
    },
  },
}
vim.lsp.enable "luau-lsp"
