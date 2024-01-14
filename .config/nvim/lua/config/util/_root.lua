local LazyUtil = require "lazy.core.util"

---@class config.util.root
---@overload fun(): string
local M = setmetatable({}, {
  ---@param m config.util.root
  __call = function(m)
    return m.get({ first = true })[1]
  end,
})

function M.info()
  local lines = { "Buffer Root Path: " .. table.concat(M.get(), ", ") } ---@type string[]
  LazyUtil.info(lines, { title = "Buffer Root Path" })
end

function M.setup()
  vim.api.nvim_create_user_command("BufferRootPath", function()
    require("config.util._root").info()
  end, { desc = "Get the root directory for the current buffer" })
end

---@param opts? { first?: boolean }
---@return table<integer, string>
function M.get(opts)
  local result = {}
  for _, root_fn in pairs { M.lsp_roots, M.git_root, M.cwd } do
    local roots = root_fn()
    if vim.tbl_count(roots) > 0 then
      if opts and opts.first then
        return roots
      end

      roots = vim.tbl_filter(function(path)
        return not vim.tbl_contains(result, path)
      end, roots)
      vim.list_extend(result, roots)
    end
  end

  return result
end

---@private
M.sources = { "lsp", ".git", "cwd" }

---@private
function M.lsp_roots()
  local buffer = vim.api.nvim_get_current_buf()
  local buffer_path = M.buffer_path(buffer)
  if not buffer_path then
    return {}
  end

  local roots = {} ---@type string[]
  for _, client in pairs(vim.lsp.get_active_clients { bufnr = buffer }) do
    local workspace = client.config.workspace_folders
    for _, ws in pairs(workspace or {}) do
      table.insert(roots, vim.uri_to_fname(ws.uri))
    end
  end

  return vim.tbl_filter(function(path)
    path = LazyUtil.norm(path)
    return path and buffer_path:find(path, 1, true) == 1
  end, roots)
end

---@private
function M.buffer_path(buffer)
  local path = vim.api.nvim_buf_get_name(assert(buffer))
  return M.real_path(path)
end

---@private
function M.real_path(path)
  if path == "" or path == nil then
    return nil
  end
  path = vim.loop.fs_realpath(path) or path
  return LazyUtil.norm(path)
end

---@private
function M.git_root()
  local root = require("plenary.job")
    :new({
      command = "git",
      args = { "rev-parse", "--show-toplevel" },
    })
    :sync()
  return { root[1] }
end

---@private
function M.cwd()
  return { M.real_path(vim.loop.cwd()) }
end

return M
