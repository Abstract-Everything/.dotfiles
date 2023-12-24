return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local telescope = require "telescope"
      local builtin = require "telescope.builtin"

      telescope.setup()
      telescope.load_extension "fzf"

      vim.api.nvim_create_user_command("Configuration", function()
        builtin.find_files { cwd = "~/.config", hidden = true }
      end, { nargs = 0 })

      vim.keymap.set("n", "<leader><space>", builtin.buffers)
      vim.keymap.set("n", "<leader>ss", builtin.lsp_workspace_symbols)
      vim.keymap.set("n", "<leader>sS", builtin.lsp_dynamic_workspace_symbols)
      vim.keymap.set("n", "<leader>sg", builtin.git_files)
      vim.keymap.set("n", "<leader>sf", builtin.find_files)
      vim.keymap.set("n", "<leader>sd", builtin.grep_string)
      vim.keymap.set("n", "<leader>sp", builtin.live_grep)
      vim.keymap.set("n", "<leader>so", function()
        builtin.tags { only_current_buffer = true }
      end)
      vim.keymap.set("n", "<leader>?", builtin.oldfiles)
    end,
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
  },
}
