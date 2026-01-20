local Config = require "config"

vim.keymap.set("n", "<leader>dT", function()
  vim.cmd.RustLsp "debuggables"
end, Config.keymaps.buffer)
