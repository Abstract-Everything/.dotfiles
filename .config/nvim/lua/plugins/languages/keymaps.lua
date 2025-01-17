local Keys = require "lazy.core.handler.keys"
local Config = require "config"

local M = {}

M._keys = {
  {
    "gd",
    function()
      require("telescope.builtin").lsp_definitions { reuse_win = true }
    end,
  },
  {
    "gD",
    function()
      require("telescope.builtin").lsp_type_definitions { reuse_win = true }
    end,
  },
  {
    "gi",
    function()
      require("telescope.builtin").lsp_implementations { reuse_win = true }
    end,
  },
  {
    "gr",
    function()
      require("telescope.builtin").lsp_references()
    end,
  },
  { "K", vim.lsp.buf.hover },
  { "<C-k>", vim.lsp.buf.signature_help, mode = { "n", "i" } },
  { "<leader>rn", vim.lsp.buf.rename },
  { "<leader>ca", vim.lsp.buf.code_action, mode = { "n", "v" } },
  {
    "<leader>f",
    Config.formatting.format_file,
  },
}

---@param buffer number
function M.resolve(buffer)
  if not Keys.resolve then
    return {}
  end

  local keys = M._keys
  local language_specific = Config.plugins.options "nvim-lspconfig"
  for _, client in ipairs(vim.lsp.get_clients { bufnr = buffer }) do
    local config = language_specific.servers and language_specific.servers[client.name] or {}
    local mappings = config and config.keys or {}
    vim.list_extend(keys, mappings)
  end
  return Keys.resolve(keys)
end

function M.setup(buffer)
  local keymaps = M.resolve(buffer)

  for _, keys in pairs(keymaps) do
    local options = Keys.opts(keys)
    options.buffer = buffer
    vim.keymap.set(keys.mode or "n", keys.lhs, keys.rhs, options)
  end
end

return M
