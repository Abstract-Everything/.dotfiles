---@class config.Formatting
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

return M
