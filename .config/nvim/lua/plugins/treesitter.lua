return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = { "query" },
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
          },
        },
        indent = {
          enable = true,
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["a]"] = "@class.outer",
              ["i["] = "@class.inner",
              ["ap"] = "@parameter.outer",
              ["ip"] = "@parameter.inner",
              ["ac"] = "@conditional.outer",
              ["ic"] = "@conditional.inner",
              ["av"] = "@variable.outer",
              ["iv"] = "@variable.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              ["]f"] = "@function.outer",
              ["]["] = "@class.outer",
              ["]p"] = "@parameter.outer",
              ["]c"] = "@conditional.outer",
              ["]v"] = "@variable.outer",
            },
            goto_next_end = {
              ["]F"] = "@function.outer",
              ["]]"] = "@class.outer",
              ["]P"] = "@parameter.outer",
              ["]C"] = "@conditional.outer",
              ["]V"] = "@variable.outer",
            },
            goto_previous_start = {
              ["[f"] = "@function.outer",
              ["[["] = "@class.outer",
              ["[p"] = "@parameter.outer",
              ["[c"] = "@conditional.outer",
              ["[v"] = "@variable.outer",
            },
            goto_previous_end = {
              ["[F"] = "@function.outer",
              ["[]"] = "@class.outer",
              ["[P"] = "@parameter.outer",
              ["[C"] = "@conditional.outer",
              ["[V"] = "@variable.outer",
            },
          },
        },
      }

      vim.o.foldmethod = "expr"
      vim.o.foldexpr = "nvim_treesitter#foldexpr()"
      vim.o.foldenable = false
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    config = function()
      require("treesitter-context").setup()
    end,
  },
  "nvim-treesitter/playground",
}
