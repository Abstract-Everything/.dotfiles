local Config = require "config"

-- UI
local _border = "rounded"

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = _border,
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = _border,
})

vim.diagnostic.config { float = { border = _border } }

require("lspconfig.ui.windows").default_options = {
  border = _border,
}

-- Autoformat
local augroup_name = "LspFormatting"
local augroup = vim.api.nvim_create_augroup(augroup_name, { clear = true })

vim.api.nvim_create_user_command(augroup_name, function()
  Config.formatting.format_file(false)
end, {})

vim.api.nvim_clear_autocmds { group = augroup }

vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  command = "undojoin | " .. augroup_name,
})

-- Keymaps

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_attach", { clear = true }),
  callback = function()
    vim.keymap.set("n", "gd", function()
      require("telescope.builtin").lsp_definitions { reuse_win = true }
    end, Config.keymaps.silent_noremap)

    vim.keymap.set("n", "gD", function()
      require("telescope.builtin").lsp_type_definitions { reuse_win = true }
    end, Config.keymaps.silent_noremap)

    vim.keymap.set("n", "gi", function()
      require("telescope.builtin").lsp_implementations { reuse_win = true }
    end)

    vim.keymap.set("n", "gr", function()
      require("telescope.builtin").lsp_references()
    end)

    vim.keymap.set("n", "K", vim.lsp.buf.hover)
    vim.keymap.set({ "n", "i" }, "<C-k>", vim.lsp.buf.signature_help)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
    vim.keymap.set("n", "<leader>f", Config.formatting.format_file)
  end,
})
