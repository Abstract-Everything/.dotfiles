local Config = require "config"

local PATH_SEPARATOR = ":"

vim.fn.assert_equal(0, vim.fn.has "win32", "This currently does not support windows")

--#region dynamic venv change
local function read_current_bin_path()
  for _, path in ipairs(vim.fn.split(vim.env.PATH, PATH_SEPARATOR)) do
    if vim.fn.executable(vim.fs.joinpath(path, "python3")) == 1 then
      return path
    end
  end

  return nil
end

local function find_venv(buffer_path)
  local venv_dir = vim.fs.find(".venv", {
    upward = true,
    type = "directory",
    path = vim.fs.dirname(buffer_path),
  })

  if #venv_dir > 0 then
    -- vim.notify("Using venv from parent directory" .. buffer_path, vim.log.levels.DEBUG)
    return venv_dir[1]
  end

  local virtual_env = vim.env.VIRTUAL_ENV
  if virtual_env and vim.uv.fs_stat(virtual_env) then
    -- vim.notify("Using venv from previously set VIRTUAL_ENV" .. buffer_path, vim.log.levels.DEBUG)
    return virtual_env
  end

  return nil
end

local function update_venv()
  local buffer_path = vim.api.nvim_buf_get_name(0)
  local venv_path = find_venv(buffer_path)
  if not venv_path then
    vim.notify("venv not found from: " .. buffer_path)
    return
  end

  local bin_path = vim.fs.joinpath(venv_path, "bin")
  local python_path = vim.fs.joinpath(bin_path, "python3")

  if vim.fn.executable(python_path) == 0 then
    vim.notify("python3 executable not found at: " .. python_path)
    return
  end

  require("dap-python").resolve_python = function()
    return python_path
  end

  local current_system_path = vim.env.PATH
  local current_bin_path = read_current_bin_path()
  if current_bin_path then
    if Config.debug_logs == true then
      vim.notify("Removing current binary path: '" .. current_bin_path .. "'")
    end
    current_system_path = string.gsub(current_system_path, current_bin_path, "")
  end
  local system_path = bin_path .. PATH_SEPARATOR .. current_system_path

  if Config.debug_logs == true then
    vim.notify("Activating '" .. venv_path .. "' with binary path '" .. system_path .. "'")
  end

  local client = vim.lsp.get_clients({ name = "pyright" })[1]
  if client then
    client.settings.python.pythonPath = python_path
    client.notify("workspace/didChangeConfiguration", {})
  else
    vim.notify "pyright is not active"
  end

  vim.env.PATH = system_path
  vim.env.VIRTUAL_ENV = venv_path
end
--#endregion

local buffer = vim.api.nvim_get_current_buf()
vim.api.nvim_create_autocmd({ "BufEnter", "LspAttach" }, {
  group = vim.api.nvim_create_augroup("python_set_venv", { clear = true }),
  buffer = buffer,
  callback = update_venv,
})

vim.keymap.set("n", "<leader>dT", require("dap-python").test_method, Config.keymaps.buffer)
vim.keymap.set("n", "<leader>dC", require("dap-python").test_class, Config.keymaps.buffer)
