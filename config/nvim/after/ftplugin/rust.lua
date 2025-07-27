local Config = require "config"

vim.keymap.set("n", "K", function()
  vim.cmd.RustLsp { "hover", "actions" }
end, Config.keymaps.buffer)

vim.keymap.set("n", "<leader>cA", function()
  vim.cmd.RustLsp "codeAction"
end, Config.keymaps.buffer)

vim.keymap.set("n", "<leader>dT", function()
  vim.cmd.RustLsp "debuggables"
end, Config.keymaps.buffer)
