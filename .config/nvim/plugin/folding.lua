local ufo = require "ufo"

vim.o.foldcolumn = "1"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

vim.keymap.set("n", "zR", function()
  ufo.openAllFolds()
end)

vim.keymap.set("n", "zM", function()
  ufo.closeAllFolds()
end)

vim.keymap.set("n", "<leader>z", "zCzO")

vim.api.nvim_create_autocmd("BufRead", {
  group = vim.api.nvim_create_augroup("folding", { clear = true }),
  callback = function()
    vim.cmd [[ silent! foldclose! ]]
    local bufnr = vim.api.nvim_get_current_buf()

    -- some plugins may change the foldmethod
    vim.wait(50, function()
      require("ufo").attach(bufnr)
      return true
    end)

    local winid = vim.api.nvim_get_current_win()
    local method = vim.wo[winid].foldmethod
    if method == "diff" or method == "marker" then
      require("ufo").closeAllFolds()
      return
    end

    if not ufo.hasAttached(bufnr) then
      return
    end

    require "async"(function()
      -- Use lsp folds if available
      local ok, ranges = pcall(function()
        await(ufo.getFolds(bufnr, "lsp"))
      end)

      -- Fallback to treesitter otherwise
      if not ok or not ranges then
        ok, ranges = pcall(function()
          await(ufo.getFolds(bufnr, "treesitter"))
        end)
      end

      if ok and ranges then
        if ufo.applyFolds(bufnr, ranges) then
          ufo.closeAllFolds()
        end
      end
    end)
  end,
})
