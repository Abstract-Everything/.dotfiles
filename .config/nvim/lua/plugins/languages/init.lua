local Util = require "config.util"

return {
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "nvimtools/none-ls.nvim",
    },
    opts = {
      automatic_installation = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    opts = {
      servers = {},
      setup = {},
    },
    config = function(_, options)
      local _border = "rounded"

      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = _border,
      })

      vim.lsp.handlers["textDocument/signatureHelp"] =
        vim.lsp.with(vim.lsp.handlers.signature_help, {
          border = _border,
        })

      vim.diagnostic.config { float = { border = _border } }

      require("lspconfig.ui.windows").default_options = {
        border = _border,
      }

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          require("plugins.languages.keymaps").setup(args.buf)
          Util.formatting.setup_auto_format()
        end,
      })

      local servers = options.servers
      ---@class lsp.ClientCapabilities
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

      ---@param server string
      local function setup(server)
        local server_options = vim.tbl_deep_extend(
          "force",
          { capabilities = vim.deepcopy(capabilities) },
          servers[server] or {}
        )
        if options.setup[server] then
          options.setup[server](server_options)
          return
        end

        require("lspconfig")[server].setup(server_options)
      end

      local mason_servers = {} ---@type string[]
      for server, _ in pairs(servers) do
        mason_servers[#mason_servers + 1] = server
      end

      -- For mason-lspconfig to enable PyLspInstall, it requires lspconfig to be
      -- loaded before the setup function is called
      require "lspconfig"
      require("mason-lspconfig").setup { ensure_installed = mason_servers, handlers = { setup } }
    end,
  },
  { import = "plugins.languages.specific" },
}
