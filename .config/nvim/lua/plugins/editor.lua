return {
  {
    "Pocco81/auto-save.nvim",
    config = function()
      require("auto-save").setup {
        condition = function(bufnr)
          local Job = require "plenary.job"
          local directory = vim.fn.expand "%:h"
          if vim.fn.isdirectory(directory) == 0 then
            return false
          end

          local filename = vim.fn.expand "%:p"
          if vim.fn.getbufvar(bufnr, "&modifiable") ~= 1 or filename == "" then
            return false
          end

          -- Only activate auto-save for files under version control
          local _, return_code = Job:new({
            command = "git",
            args = { "ls-files", "--error-unmatch", filename },
            cwd = directory,
          }):sync()
          return return_code == 0
        end,
      }
    end,
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    lazy = false,
    keys = {
      {
        "zR",
        function()
          require("ufo").openAllFolds()
        end,
      },
      {
        "zM",
        function()
          require("ufo").closeAllFolds()
        end,
      },
      { "<leader>z", "zCzO" },
    },
    config = function(_, opts)
      local ufo = require "ufo"

      ufo.setup { opts }

      vim.o.foldcolumn = "1"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      vim.api.nvim_create_autocmd("BufRead", {
        callback = function()
          vim.cmd [[ silent! foldclose! ]]
          local bufnr = vim.api.nvim_get_current_buf()

          -- some plugins may change the foldmethod
          vim.wait(50, function()
            ufo.attach(bufnr)
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
    end,
  },
}
