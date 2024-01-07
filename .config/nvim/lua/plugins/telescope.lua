return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
        config = function() end,
      },
    },
    keys = {
      { "<leader><space>", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>" },
      { "<leader>ss", "<cmd>Telescope lsp_workspace_symbols<cr>" },
      { "<leader>sS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>" },
      { "<leader>sg", "<cmd>Telescope git_files<cr>" },
      { "<leader>sf", "<cmd>Telescope find_files<cr>" },
      { "<leader>sd", "<cmd>Telescope grep_string<cr>" },
      { "<leader>sp", "<cmd>Telescope live_grep<cr>" },
      { "<leader>so", "<cmd>Telescope tags<cr>" },
      { "<leader>?", "<cmd>Telescope oldfiles<cr>" },
    },
    config = function()
      local telescope = require "telescope"
      local builtin = require "telescope.builtin"

      telescope.setup()
      telescope.load_extension "fzf"

      vim.api.nvim_create_user_command("Configuration", function()
        builtin.find_files { cwd = "~/.config", hidden = true }
      end, { nargs = 0 })
    end,
  },
}
