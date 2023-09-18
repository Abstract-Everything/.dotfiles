-- Configuration
local silent_noremap = { silent = true, noremap = true }

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
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

vim.keymap.set("n", "<Tab>", ":cnext<return>", silent_noremap)
vim.keymap.set("n", "<S-Tab>", ":cprev<return>", silent_noremap)

vim.api.nvim_create_user_command("Configuration", function()
  require("telescope.builtin").find_files { cwd = "~/.config", hidden = true }
end, { nargs = 0 })
