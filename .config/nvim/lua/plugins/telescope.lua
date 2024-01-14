local Util = require "config.util"

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
      { "<leader>,", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>" },
      { "<leader><", "<cmd>Telescope oldfiles<cr>" },

      { "<leader>:", "<cmd>Telescope command_history<cr>" },
      { "<leader>/", Util.telescope "live_grep" },

      { "<leader>ff", Util.telescope "files" },
      { "<leader>fg", Util.telescope "git_files" },
      { "<leader>fc", Util.telescope("files", { cwd = os.getenv "XDG_CONFIG_HOME" or "~/.config" }) },

      { "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>" },
      { "<leader>sD", "<cmd>Telescope diagnostics<cr>" },

      { "<leader>sk", "<cmd>Telescope keymaps<cr>" },
      { "<leader>sm", "<cmd>Telescope man_pages<cr>" },
      { "<leader>sr", "<cmd>Telescope resume<cr>" },

      { "<leader>sw", Util.telescope("grep_string", { word_match = "-w" }) },
      { "<leader>sw", Util.telescope "grep_string", mode = "v" },

      { "<leader>ss", "<cmd>Telescope lsp_workspace_symbols<cr>" },
      { "<leader>sS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>" },
    },
    config = function(_, opts)
      local telescope = require "telescope"

      telescope.setup(opts)
      telescope.load_extension "fzf"
    end,
  },
}
