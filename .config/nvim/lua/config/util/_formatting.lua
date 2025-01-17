local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

---@class config.util.formatting
local M = setmetatable({}, {})

---@param async boolean?
function M.format_file(async)
  if async == nil then
    async = true
  end
  vim.lsp.buf.format {
    async = async,
    -- Use the null-ls formatter if it has one
    filter = function(filter_client)
      for _, client in ipairs(vim.lsp.get_clients()) do
        if client.name == "null-ls" and client.supports_method "textDocument/formatting" then
          return filter_client.name == "null-ls"
        end
      end

      return true
    end,
  }
end

function M.setup_auto_format()
  local bufnr = vim.api.nvim_get_current_buf()

  vim.api.nvim_buf_create_user_command(bufnr, "LspFormatting", function()
    M.format_file(false)
  end, {})

  vim.api.nvim_clear_autocmds {
    group = augroup,
    buffer = bufnr,
  }

  vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroup,
    buffer = bufnr,
    command = "undojoin | LspFormatting",
  })
end

return M
