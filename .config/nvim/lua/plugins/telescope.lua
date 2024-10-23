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
      { "nvim-telescope/telescope-ui-select.nvim" },
    },
    -- Add more keys - such as quickfix history
    keys = {
      { "<leader>,", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>" },
      { "<leader><", "<cmd>Telescope oldfiles<cr>" },

      { "<leader>:", "<cmd>Telescope command_history<cr>" },
      { "<leader>/", Util.telescope "live_grep" },
      {
        "<leader>?",
        Util.telescope("live_grep", { cwd = Util.root { only_git_root = true } }),
      },

      { "<leader>ff", Util.telescope "files" },
      { "<leader>fF", Util.telescope("files", { no_ignore = true, no_ignore_parent = true }) },
      { "<leader>fg", Util.telescope "git_files" },
      { "<leader>fc", "<cmd>Configuration<cr>" },

      { "<leader>sl", "<cmd>Telescope spell_suggest<cr>" },

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
      telescope.load_extension "ui-select"
    end,
  },
}
