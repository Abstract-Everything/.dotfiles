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

  ---@param server string
  local function setup(server)
    capabilities = vim.deepcopy(capabilities)

    if options.setup[server] then
      local setup_handled = options.setup[server](capabilities, options.servers[server])
      if setup_handled then
        return
      end
    end

    local server_options =
      vim.tbl_deep_extend("force", { capabilities = capabilities }, options.servers[server] or {})
    require("lspconfig")[server].setup(server_options)
  end

  -- For mason-lspconfig to enable PyLspInstall, it requires lspconfig to be
  -- loaded before the setup function is called
  require "lspconfig"
  require("mason-lspconfig").setup {
    ensure_installed = {},
    automatic_installation = true,
    handlers = { setup },
  }
end

return M
