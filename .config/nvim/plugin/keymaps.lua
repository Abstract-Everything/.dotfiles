-- Configuration
local silent_noremap = { silent = true, noremap = true }

---@param name string
local function create_augroup(name)
  return vim.api.nvim_create_augroup("custom_autocommands_" .. name, { clear = true })
end

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = create_augroup "checktime",
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd "checktime"
    end
  end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = create_augroup "highlight_yank",
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.keymap.set("n", "<leader>e", function()
  vim.diagnostic.open_float()
end, silent_noremap)
vim.keymap.set("n", "]d", function()
  vim.diagnostic.goto_next()
end, silent_noremap)
vim.keymap.set("n", "[d", function()
  vim.diagnostic.goto_prev()
end, silent_noremap)
vim.keymap.set("n", "<leader>q", function()
  vim.diagnostic.setloclist()
end, silent_noremap)

vim.keymap.set("n", "<C-n>", ":cnext<return>", silent_noremap)
vim.keymap.set("n", "<C-p>", ":cprev<return>", silent_noremap)

vim.keymap.set({"n", "x"}, "<leader>y", [["+y]], silent_noremap)
vim.keymap.set({"n", "x"}, "<leader>p", [["+p]], silent_noremap)
vim.keymap.set({"n", "x"}, "<leader>d", [["_d]], silent_noremap)
vim.keymap.set("x", "<leader>d", [["_dP]])

vim.keymap.set("t", "<leader><Esc>", "<C-\\><C-N>", silent_noremap)

vim.api.nvim_create_user_command("Configuration", function()
  require("telescope.builtin").find_files { cwd = "~/.config", hidden = true }
end, { nargs = 0 })

