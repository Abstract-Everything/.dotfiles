local Config = require "config"

vim.keymap.set("n", "<leader>,", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>")
vim.keymap.set("n", "<leader><", "<cmd>Telescope oldfiles<cr>")

vim.keymap.set("n", "<leader>:", "<cmd>Telescope command_history<cr>")

--#region Search
--#region Text
vim.keymap.set("n", "<leader>/", Config.telescope "live_grep")
vim.keymap.set(
  "n",
  "<leader>?",
  Config.telescope("live_grep", { "n", cwd = Config.root { only_git_root = true } })
)
vim.keymap.set("n", "<leader>sw", Config.telescope("grep_string", { word_match = "-w" }))
vim.keymap.set("v", "<leader>sw", Config.telescope "grep_string")
--#endregion

--#region Diagnostics
vim.keymap.set("n", "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>")
vim.keymap.set("n", "<leader>sD", "<cmd>Telescope diagnostics<cr>")
--#endregion

--#region Lsp symbols
vim.keymap.set("n", "<leader>ss", "<cmd>Telescope lsp_workspace_symbols<cr>")
vim.keymap.set("n", "<leader>sS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>")
--#endregion

vim.keymap.set("n", "<leader>sk", "<cmd>Telescope keymaps<cr>")

vim.keymap.set("n", "<leader>sm", "<cmd>Telescope man_pages<cr>")

vim.keymap.set("n", "<leader>sl", "<cmd>Telescope spell_suggest<cr>")

vim.keymap.set("n", "<leader>sq", "<cmd>Telescope quickfix<cr>")

vim.keymap.set("n", "<leader>sQ", "<cmd>Telescope quickfixhistory<cr>")

--#endregion

--#region Files
vim.keymap.set("n", "<leader>ff", Config.telescope "files")
vim.keymap.set(
  "n",
  "<leader>fF",
  Config.telescope("files", { no_ignore = true, no_ignore_parent = true })
)
vim.keymap.set("n", "<leader>fg", Config.telescope "git_files")
vim.keymap.set("n", "<leader>fc", "<cmd>Configuration<cr>")
--#endregion

vim.keymap.set("n", "<leader>sr", "<cmd>Telescope resume<cr>")
