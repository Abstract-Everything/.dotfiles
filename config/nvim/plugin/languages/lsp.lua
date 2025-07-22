local Config = require "config"

-- Client config
vim.lsp.config("*", {
  capabilities = {
    textDocument = {
      foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      },
    },
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true,
      },
    },
  },
})

-- UI
local _border = "rounded"

vim.diagnostic.config { float = { border = _border } }

-- Autoformat
local augroup_name = "LspFormatting"
local augroup = vim.api.nvim_create_augroup(augroup_name, { clear = true })
local autoformat_enabled = true

vim.api.nvim_create_user_command("ToggleAutoFormat", function()
  autoformat_enabled = not autoformat_enabled
end, {})

vim.api.nvim_create_user_command(augroup_name, function()
  if autoformat_enabled then
    Config.formatting.format_file(false)
  else
    vim.notify("Autoformatting is disabled", vim.log.levels.TRACE)
  end
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

    vim.keymap.set("n", "K", function()
      vim.lsp.buf.hover { border = _border }
    end)
    vim.keymap.set({ "n", "i" }, "<C-k>", function()
      vim.lsp.buf.signature_help { border = _border }
    end)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
    vim.keymap.set("n", "<leader>f", Config.formatting.format_file)
  end,
})
