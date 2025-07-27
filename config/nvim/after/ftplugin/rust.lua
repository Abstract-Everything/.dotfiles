local Config = require "config"

local buffer = vim.api.nvim_get_current_buf()

vim.keymap.set("n", "K", function()
  vim.cmd.RustLsp { "hover", "actions" }
end, vim.tbl_deep_extend("error", Config.keymaps.silent_noremap, { buffer = buffer }))

vim.keymap.set("n", "<leader>cA", function()
  vim.cmd.RustLsp "codeAction"
end, vim.tbl_deep_extend("error", Config.keymaps.silent_noremap, { buffer = buffer }))

vim.keymap.set("n", "<leader>dT", function()
  vim.cmd.RustLsp "debuggables"
end, vim.tbl_deep_extend("error", Config.keymaps.silent_noremap, { buffer = buffer }))
