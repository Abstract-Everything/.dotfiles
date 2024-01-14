return {
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
  },
  { "b0o/schemastore.nvim" },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    config = function()
      require("mason-tool-installer").setup {
        auto_update = true,
        debounce_hours = 24,
        ensure_installed = {
          "lua_ls",
          "stylua",
          "luau-lsp",

          "clangd",
          "clang-format",

          "neocmakelsp",
          "cmakelint",
          "gersemi",

          "csharp-language-server",
          "csharpier",

          "haskell-language-server",

          "rust_analyzer",

          "bash-language-server",
          "shellcheck",
          "shfmt",

          "pylsp",
          "black",

          "yaml-language-server",
          "json-lsp",
        },
      }
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "folke/neodev.nvim", opts = {} },
    config = function()
      local _border = "rounded"

      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = _border,
      })

      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = _border,
      })

      vim.diagnostic.config { float = { border = _border } }

      require("lspconfig.ui.windows").default_options = {
        border = _border,
      }
    end,
  },
  -- Specific language server extensions
  "p00f/clangd_extensions.nvim",
  "lopi-py/luau-lsp.nvim",
  {
    -- https://rsdlt.github.io/posts/rust-nvim-ide-guide-walkthrough-development-debug/
    "simrat39/rust-tools.nvim",
    dependencies = { "rust-lang/rust.vim" },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

          -- Buffer local mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions

          local opts = { buffer = ev.buf }

          local hover_callback = vim.lsp.buf.hover
          local code_actions_callback = vim.lsp.buf.code_action

          local active_client = vim.lsp.get_client_by_id(ev.data.client_id)
          if active_client.name == "rust_analyzer" then
            local rust_tools = require "rust-tools"
            hover_callback = rust_tools.hover_actions.hover_actions
            code_actions_callback = rust_tools.code_action_group.code_action_group
          elseif active_client.name == "clangd" then
            require("clangd_extensions.inlay_hints").setup_autocmd()
            require("clangd_extensions.inlay_hints").set_inlay_hints()
          end

          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gD", vim.lsp.buf.type_definition, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "K", hover_callback, opts)
          vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
          vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
          vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
          vim.keymap.set("n", "<leader>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set({ "n", "v" }, "<leader>ca", code_actions_callback, opts)
          vim.keymap.set("n", "<leader>f", function()
            vim.lsp.buf.format {
              async = true,
              -- Use the null-ls formatter if it has one
              filter = function(filter_client)
                for _, client in ipairs(vim.lsp.get_active_clients()) do
                  if client.name == "null-ls" and client.supports_method "textDocument/formatting" then
                    return filter_client.name == "null-ls"
                  end
                end

                return true
              end,
            }
          end, opts)
        end,
      })

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      require("mason-lspconfig").setup_handlers {
        function(server_name) -- default handler
          require("lspconfig")[server_name].setup {
            capabilities = capabilities,
          }
        end,
        ["lua_ls"] = function()
          require("lspconfig")["lua_ls"].setup {
            capabilities = capabilities,
            settings = {
              Lua = {
                runtime = {
                  version = "LuaJIT",
                  path = vim.split(package.path, ";"),
                },
                diagnostics = {
                  globals = { "vim" },
                },
                workspace = {
                  library = {
                    [vim.fn.expand "$VIMRUNTIME/lua"] = true,
                    [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
                  },
                },
                telemetry = {
                  enable = false,
                },
              },
            },
          }
        end,
        ["rust_analyzer"] = function()
          require("rust-tools").setup {
            server = {
              capabilities = capabilities,
            },
          }
        end,
        ["luau_lsp"] = function()
          require("luau-lsp").setup {}
        end,
      }
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      local nls = require "null-ls"
      nls.setup {
        sources = {
          -- lua
          nls.builtins.formatting.stylua,

          -- python
          nls.builtins.formatting.black,

          -- csharp
          nls.builtins.formatting.csharpier,

          -- shell
          nls.builtins.code_actions.shellcheck,
          nls.builtins.formatting.shfmt,

          -- cmake
          nls.builtins.diagnostics.cmake_lint,
          nls.builtins.formatting.gersemi,
        },
      }
    end,
  },
}
