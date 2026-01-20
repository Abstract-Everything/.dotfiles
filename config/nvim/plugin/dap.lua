local dap = require "dap"
local dapui = require "dapui"

-- Alias to start new session as running continue is unintuitive
vim.keymap.set("n", "<leader>ds", function()
  require("dap").continue()
end)

vim.keymap.set("n", "<leader>dr", function()
  dap.run_last()
end)

vim.keymap.set("n", "<leader>dt", function()
  dap.repl.open()
end)

vim.keymap.set("n", "<leader>du", function()
  dapui.toggle {}
end)

vim.keymap.set({ "n", "v" }, "<M-e>", function()
  dapui.eval()
end)

vim.keymap.set("n", "<M-b>", function()
  dap.toggle_breakpoint()
end)

vim.keymap.set("n", "<M-h>", function()
  dap.run_to_cursor()
end)

vim.keymap.set("n", "<M-c>", function()
  dap.continue()
end)

vim.keymap.set("n", "<M-j>", function()
  dap.step_over()
end)

vim.keymap.set("n", "<M-l>", function()
  dap.step_into()
end)

vim.keymap.set("n", "<M-k>", function()
  dap.step_out()
end)

vim.keymap.set("n", "<M-u>", function()
  dap.up()
end)

vim.keymap.set("n", "<M-d>", function()
  dap.down()
end)

dap.adapters.lldb = {
  type = "executable",
  command = vim.fn.exepath "lldb-dap",
  name = "lldb",
}
