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

          "clangd",
          "clang-format",

          "rust_analyzer",

          "pylsp",
          "black",

          "yaml-language-server",
        },
      }
    end,
  },
  "neovim/nvim-lspconfig",
  -- Specific language server extensions
  "p00f/clangd_extensions.nvim",
  {
    -- https://rsdlt.github.io/posts/rust-nvim-ide-guide-walkthrough-development-debug/
    "simrat39/rust-tools.nvim",
    dependencies = { "rust-lang/rust.vim" },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      local rust_tools = require "rust-tools"

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

          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if client.name == "rust_analyzer" then
            hover_callback = rust_tools.hover_actions.hover_actions
            code_actions_callback = rust_tools.code_action_group.code_action_group
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
            vim.lsp.buf.format { async = true }
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
        ["clangd"] = function()
          require("clangd_extensions").setup {
            server = {
              capabilities = capabilities,
            },
            extensions = {
              autoSetHints = true,
              inlay_hints = {
                only_current_line = false,
                only_current_line_autocmd = "CursorHold",
                show_parameter_hints = true,
                parameter_hints_prefix = "<- ",
                other_hints_prefix = "=> ",
                max_len_align = false,
                max_len_align_padding = 1,
                right_align = false,
                right_align_padding = 81,
                highlight = "Comment",
                priority = 100,
              },
              ast = {
                role_icons = {
                  type = "",
                  declaration = "",
                  expression = "",
                  specifier = "",
                  statement = "",
                  ["template argument"] = "",
                },
                kind_icons = {
                  Compound = "",
                  Recovery = "",
                  TranslationUnit = "",
                  PackExpansion = "",
                  TemplateTypeParm = "",
                  TemplateTemplateParm = "",
                  TemplateParamObject = "",
                },
                highlights = {
                  detail = "Comment",
                },
                memory_usage = {
                  border = "none",
                },
                symbol_info = {
                  border = "none",
                },
              },
            },
          }
        end,
        ["rust_analyzer"] = function()
          rust_tools.setup {
            server = {
              capabilities = capabilities,
            },
          }
        end,
      }

      require("lspconfig").jsonls.setup {
        capabilities = capabilities,
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      }
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      local nls = require "null-ls"
      nls.setup {
        sources = {
          nls.builtins.formatting.black,
          nls.builtins.formatting.stylua,
        },
      }
    end,
  },
}
