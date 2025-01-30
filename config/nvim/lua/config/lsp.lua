-- ---@class config.lsp.Server
-- ---@field any vim.lsp.client
--
-- ---@class config.lsp.Setup
--
-- ---@class config.lsp.Options
-- ---@field servers config.lsp.Server[]
-- ---@field setup config.lsp.Setup

---@class config.Lsp
local M = setmetatable({}, {})

-- ---@param options config.lsp.Options
function M.setup(options)
  local capabilities = vim.tbl_deep_extend(
    "force",
    {},
    vim.lsp.protocol.make_client_capabilities(),
    require("cmp_nvim_lsp").default_capabilities()
  )

  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }

  capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true

  for server, server_options in pairs(options.servers) do
    capabilities = vim.deepcopy(capabilities)

    local setup_function = options.setup[server]
    local setup_handled = false
    if setup_function then
      setup_handled = setup_function(capabilities, server_options)
    end

    if not setup_handled then
      local setup_options =
        vim.tbl_deep_extend("force", { capabilities = capabilities }, server_options or {})
      require("lspconfig")[server].setup(setup_options)
    end
  end
end

return M
