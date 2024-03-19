local LazyUtil = require "lazy.core.util"

---@class config.util.root.options
---@field first? boolean
---@field only_git_root? boolean
---@field only_lsp_root? boolean
---@field lsp_client_ids? number[]

---@class config.util.root
---@overload fun(): string
local M = setmetatable({}, {
  ---@param m config.util.root
  ---@param options? config.util.root.options
  __call = function(m, options)
    return m.get(options)[1]
  end,
})

function M.info()
  local lines = { "Buffer Root Path: " .. table.concat(M.get { first = false }, ", ") } ---@type string[]
  LazyUtil.info(lines, { title = "Buffer Root Path" })
end

function M.setup()
  vim.api.nvim_create_user_command("BufferRootPath", function()
    require("config.util._root").info()
  end, { desc = "Get the root directory for the current buffer" })
end

---@param opts? config.util.root.options
---@return table<integer, string>
function M.get(opts)
  opts = opts or {}
  opts = vim.tbl_extend("keep", opts, {
    first = true,
    only_git_root = false,
    only_lsp_root = opts.only_lsp_root or opts.lsp_client_ids ~= nil,
  })
  assert(
    vim.tbl_count(vim.tbl_filter(function(value)
      return value
    end, { opts.only_lsp_root, opts.only_git_root })) < 2,
    "only_<root> parameters are mutually exclusive"
  )

  local sources = {}
  if opts.only_git_root then
    sources = { M.git_root }
  elseif opts.only_lsp_root then
    sources = { M.lsp_roots }
  else
    sources = { M.lsp_roots, M.git_root, M.cwd }
  end

  local result = {}
  for _, root_fn in pairs(sources) do
    local roots = root_fn(opts)
    if vim.tbl_count(roots) > 0 then
      if opts.first then
        result = roots
        break
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
---@param opts { lsp_client_ids?: number[] }
function M.lsp_roots(opts)
  local buffer = vim.api.nvim_get_current_buf()
  local buffer_path = M.buffer_path(buffer)
  if not buffer_path then
    return {}
  end

  local clients = {}
  if opts.lsp_client_ids then
    for _, id in ipairs(opts.lsp_client_ids) do
      table.insert(clients, vim.lsp.get_client_by_id(id))
    end
  else
    clients = vim.lsp.get_active_clients()
  end

  local roots = {} ---@type string[]
  for _, client in pairs(clients) do
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
