return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },
  "nvim-treesitter/playground",
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "query" },
      modules = {},
      ignore_install = {},
      auto_install = true,
      sync_install = false,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          scope_incremental = "<C-space>",
          node_decremental = "<bs>",
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["as"] = "@class.outer",
            ["is"] = "@class.inner",
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
            ["ap"] = "@conditional.outer",
            ["ip"] = "@conditional.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]f"] = "@function.outer",
            ["]s"] = "@class.outer",
            ["]a"] = "@parameter.outer",
            ["]p"] = "@conditional.outer",
          },
          goto_next_end = {
            ["]F"] = "@function.outer",
            ["]S"] = "@class.outer",
            ["]A"] = "@parameter.outer",
            ["]P"] = "@conditional.outer",
          },
          goto_previous_start = {
            ["[f"] = "@function.outer",
            ["[s"] = "@class.outer",
            ["[a"] = "@parameter.outer",
            ["[p"] = "@conditional.outer",
          },
          goto_previous_end = {
            ["[F"] = "@function.outer",
            ["[S"] = "@class.outer",
            ["[A"] = "@parameter.outer",
            ["[P"] = "@conditional.outer",
          },
        },
      },
    },
    config = function(_, options)
      require("nvim-treesitter.configs").setup(options)
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = {
      enable = true,
    },
  },
}
