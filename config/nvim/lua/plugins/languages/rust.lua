return {
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    ft = { "rust" },
    lazy = false,
    on_attach = function(client, buffer) end,
    opts = {
      -- TODO: Setting these using vim.lsp.config does not seem to work
      default_settings = {
        ["rust-analyzer"] = {
          cargo = {
            allFeatures = true,
            loadOutDirsFromCheck = true,
            runBuildScripts = true,
          },
          checkOnSave = true,
          procMacro = {
            enable = true,
          },
        },
      },
    },
    config = function(_, options)
      vim.g.rustaceanvim = options or {}
    end,
  },
}
