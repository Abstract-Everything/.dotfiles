vim.keymap.set("n", "<leader>dr", function()
  require("dap").run_last()
end)

vim.keymap.set("n", "<leader>db", function()
  require("dap").toggle_breakpoint()
end)

vim.keymap.set("n", "<leader>dh", function()
  require("dap").run_to_cursor()
end)

vim.keymap.set("n", "<leader>dc", function()
  require("dap").continue()
end)

vim.keymap.set("n", "<leader>ds", function()
  require("dap").step_into()
end)

vim.keymap.set("n", "<leader>dn", function()
  require("dap").step_over()
end)

vim.keymap.set("n", "<leader>df", function()
  require("dap").step_out()
end)

vim.keymap.set("n", "<leader>dt", function()
  require("dap").repl.open()
end)

vim.keymap.set("n", "<leader>du", function()
  require("dapui").toggle {}
end)

vim.keymap.set({ "n", "v" }, "<leader>de", function()
  require("dapui").eval()
end)
