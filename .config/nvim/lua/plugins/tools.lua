return {
  {
    "KabbAmine/zeavim.vim",
    init = function()
      vim.g.zv_disable_mapping = 1
      vim.keymap.set("n", "<leader>K", "<Plug>ZVOperator")
      vim.keymap.set("n", "<leader>k", "<Plug>Zeavim")
      vim.keymap.set("v", "<leader>k", "<Plug>ZVVisSelection")
      vim.keymap.set("n", "<leader><C-k>", "<Plug>ZVKeyDocset")
    end,
  },
  {
    "EthanJWright/vs-tasks.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-lua/popup.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("vstask").setup {
        telescope_keys = {
          vertical = "<C-v>",
          split = "<C-x>",
          tab = "<C-t>",
          current = "<CR>",
        },
      }
    end,
    init = function()
      local vstask = require("telescope").extensions.vstask
      vim.keymap.set("n", "<leader>ta", vstask.tasks)
      vim.keymap.set("n", "<leader>ti", vstask.inputs)
      vim.keymap.set("n", "<leader>th", vstask.history)
      vim.keymap.set("n", "<leader>tl", vstask.launch)
    end,
  },
}
