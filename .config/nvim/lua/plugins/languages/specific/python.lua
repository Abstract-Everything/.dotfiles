local Util = require "config.util"

local last_root_directory = ""

local function find_python_client_ids()
  local ids = {}
  for _, client in ipairs(vim.lsp.get_active_clients()) do
    if client.name == "pyright" then
      table.insert(ids, client.id)
    end
  end
  return ids
end

local function automatically_set_parent_venv()
  local root_directory = Util.root { lsp_client_ids = find_python_client_ids() }
  if not root_directory then
    vim.notify("Did not manage to retrieve python root directory", vim.log.levels.INFO)
    return
  end

  if root_directory == last_root_directory then
    vim.notify("LspRoot is the same, not changing venv: " .. root_directory, vim.log.levels.INFO)
    return
  end
  last_root_directory = root_directory

  local cwd = vim.fn.getcwd()
  vim.api.nvim_set_current_dir(root_directory)
  require("venv-selector").retrieve_from_cache()
  vim.api.nvim_set_current_dir(cwd)
end

return {
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, options)
      local nls = require "null-ls"
      options.sources = vim.list_extend(options.sources or {}, {
        nls.builtins.formatting.black,
        nls.builtins.diagnostics.mypy,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- TODO: Check configuration
        pyright = {},
        ruff_lsp = {},
      },
      setup = {
        pyright = function(options)
          vim.api.nvim_create_autocmd({ "LspAttach" }, {
            callback = function()
              automatically_set_parent_venv()
            end,
          })
          vim.api.nvim_create_autocmd({ "BufEnter" }, {
            callback = function()
              automatically_set_parent_venv()
            end,
          })
          -- TODO: Add option to let setup be handled by init.lua
          require("lspconfig").pyright.setup(options)
        end,
      },
    },
  },
  {
    "linux-cultist/venv-selector.nvim",
    cmd = "VenvSelect",
    opts = function(_, options)
      return vim.tbl_deep_extend("force", options, {
        name = {
          "venv",
          ".venv",
          "env",
          ".env",
        },
      })
    end,
    keys = {
      { "<leader>vs", "<cmd>VenvSelect<cr>" },
      { "<leader>vc", "<cmd>VenvSelectCached<cr>" },
    },
  },
}
