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
}
