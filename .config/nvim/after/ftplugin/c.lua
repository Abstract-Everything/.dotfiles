local Config = require "config"

vim.keymap.set(
  "n",
  "<leader>ls",
  "<cmd>ClangdSwitchSourceHeader<cr>",
  Config.keymaps.silent_noremap
)

local dap = require "dap"
if not dap.adapters["codelldb"] then
  require("dap").adapters.codelldb = {
    type = "server",
    host = "localhost",
    port = "${port}",
    executable = {
      command = "codelldb",
      args = {
        "--port",
        "${port}",
      },
    },
  }
end

local configuration = {
  {
    type = "codelldb",
    request = "launch",
    name = "Launch file",
    program = require("dap.utils").pick_file,
    cwd = "${workspaceFolder}",
  },
  {
    type = "codelldb",
    request = "attach",
    name = "Attach to process",
    processId = require("dap.utils").pick_process,
    cwd = "${workspaceFolder}",
  },
}

dap.configurations.c = configuration
dap.configurations.cpp = configuration
