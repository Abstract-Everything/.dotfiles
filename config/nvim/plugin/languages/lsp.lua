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
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)

    vim.keymap.set("n", "gd", function()
      require("telescope.builtin").lsp_definitions { reuse_win = true }
    end, Config.keymaps.buffer)

    vim.keymap.set("n", "gD", function()
      require("telescope.builtin").lsp_type_definitions { reuse_win = true }
    end, Config.keymaps.buffer)

    vim.keymap.set("n", "gi", function()
      require("telescope.builtin").lsp_implementations { reuse_win = true }
    end, Config.keymaps.buffer)

    vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, Config.keymaps.buffer)

    if client ~= nil and client.name == "rust-analyzer" then
      vim.keymap.set("n", "K", function()
        vim.cmd.RustLsp { "hover", "actions" }
      end, Config.keymaps.buffer)

      vim.keymap.set("n", "<leader>ca", function()
        vim.cmd.RustLsp "codeAction"
      end, Config.keymaps.buffer)
    else
      vim.keymap.set("n", "K", vim.lsp.buf.hover, Config.keymaps.buffer)

      vim.keymap.set({ "n", "i" }, "<C-k>", vim.lsp.buf.signature_help, Config.keymaps.buffer)
    end

    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, Config.keymaps.buffer)

    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, Config.keymaps.buffer)

    vim.keymap.set("n", "<leader>f", Config.formatting.format_file, Config.keymaps.buffer)
  end,
})
