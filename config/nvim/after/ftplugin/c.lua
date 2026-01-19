local Config = require "config"

vim.keymap.set("n", "<leader>ls", "<cmd>ClangdSwitchSourceHeader<cr>", Config.keymaps.buffer)

local dap = require "dap"

local configuration = {
  {
    type = "lldb",
    request = "launch",
    name = "Launch file",
    program = require("dap.utils").pick_file,
    cwd = "${workspaceFolder}",
  },
  {
    type = "lldb",
    request = "attach",
    name = "Attach to process",
    processId = require("dap.utils").pick_process,
    cwd = "${workspaceFolder}",
  },
}

dap.configurations.c = configuration
dap.configurations.cpp = configuration
