local Config = require "config"

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

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = create_augroup "resize_splits",
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd "tabdo wincmd ="
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
vim.keymap.set("n", "n", "'Nn'[v:searchforward].'zv'", Config.keymaps.expr)
vim.keymap.set("x", "n", "'Nn'[v:searchforward]", Config.keymaps.expr)
vim.keymap.set("o", "n", "'Nn'[v:searchforward]", Config.keymaps.expr)
vim.keymap.set("n", "N", "'nN'[v:searchforward].'zv'", Config.keymaps.expr)
vim.keymap.set("x", "N", "'nN'[v:searchforward]", Config.keymaps.expr)
vim.keymap.set("o", "N", "'nN'[v:searchforward]", Config.keymaps.expr)

vim.keymap.set("n", "<leader>e", function()
  vim.diagnostic.open_float()
end, Config.keymaps.silent_noremap)
vim.keymap.set("n", "]d", function()
  vim.diagnostic.jump {
    count = 1,
    severity = vim.diagnostic.severity.ERROR,
    float = true,
  }
end, Config.keymaps.silent_noremap)
vim.keymap.set("n", "[d", function()
  vim.diagnostic.jump {
    count = -1,
    severity = vim.diagnostic.severity.ERROR,
    float = true,
  }
end, Config.keymaps.silent_noremap)

vim.keymap.set("n", "<C-n>", ":cnext<return>zv", Config.keymaps.silent_noremap)
vim.keymap.set("n", "<C-p>", ":cprev<return>zv", Config.keymaps.silent_noremap)

vim.keymap.set({ "n", "x" }, "<leader>y", [["+y]], Config.keymaps.silent_noremap)
vim.keymap.set({ "n", "x" }, "<leader>Y", [["*y]], Config.keymaps.silent_noremap)
vim.keymap.set({ "n", "x" }, "<leader>p", [["+p]], Config.keymaps.silent_noremap)
vim.keymap.set({ "n", "x" }, "<leader>P", [["*p]], Config.keymaps.silent_noremap)
vim.keymap.set({ "n", "x" }, "<leader>d", [["_d]], Config.keymaps.silent_noremap)
vim.keymap.set("x", "<leader>d", [["_dP]])

vim.keymap.set("t", "<leader><Esc>", "<C-\\><C-N>", Config.keymaps.silent_noremap)

vim.api.nvim_create_user_command("Configuration", function()
  local command =
    Config.telescope("files", { cwd = os.getenv "XDG_CONFIG_HOME" or "~/.config", hidden = true })
  command()
end, { nargs = 0 })

vim.keymap.set({ "n" }, "-", "<cmd>Explore<cr>", Config.keymaps.silent_noremap)

vim.api.nvim_create_user_command("BufferRootPath", function()
  Config.root.info()
end, { desc = "Get the root directory for the current buffer" })
