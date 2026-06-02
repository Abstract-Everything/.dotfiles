local move = require "nvim-treesitter-textobjects.move"
local select = require "nvim-treesitter-textobjects.select"

local function select_textobject(query)
  return function()
    select.select_textobject(query, "textobjects")
  end
end

local function move_to(fn, query)
  return function()
    move[fn](query, "textobjects")
  end
end

vim.keymap.set({ "x", "o" }, "af", select_textobject "@function.outer")
vim.keymap.set({ "x", "o" }, "if", select_textobject "@function.inner")
vim.keymap.set({ "x", "o" }, "as", select_textobject "@class.outer")
vim.keymap.set({ "x", "o" }, "is", select_textobject "@class.inner")
vim.keymap.set({ "x", "o" }, "aa", select_textobject "@parameter.outer")
vim.keymap.set({ "x", "o" }, "ia", select_textobject "@parameter.inner")
vim.keymap.set({ "x", "o" }, "ap", select_textobject "@conditional.outer")
vim.keymap.set({ "x", "o" }, "ip", select_textobject "@conditional.inner")

vim.keymap.set({ "n", "x", "o" }, "]f", move_to("goto_next_start", "@function.outer"))
vim.keymap.set({ "n", "x", "o" }, "]s", move_to("goto_next_start", "@class.outer"))
vim.keymap.set({ "n", "x", "o" }, "]a", move_to("goto_next_start", "@parameter.outer"))
vim.keymap.set({ "n", "x", "o" }, "]p", move_to("goto_next_start", "@conditional.outer"))

vim.keymap.set({ "n", "x", "o" }, "]F", move_to("goto_next_end", "@function.outer"))
vim.keymap.set({ "n", "x", "o" }, "]S", move_to("goto_next_end", "@class.outer"))
vim.keymap.set({ "n", "x", "o" }, "]A", move_to("goto_next_end", "@parameter.outer"))
vim.keymap.set({ "n", "x", "o" }, "]P", move_to("goto_next_end", "@conditional.outer"))

vim.keymap.set({ "n", "x", "o" }, "[f", move_to("goto_previous_start", "@function.outer"))
vim.keymap.set({ "n", "x", "o" }, "[s", move_to("goto_previous_start", "@class.outer"))
vim.keymap.set({ "n", "x", "o" }, "[a", move_to("goto_previous_start", "@parameter.outer"))
vim.keymap.set({ "n", "x", "o" }, "[p", move_to("goto_previous_start", "@conditional.outer"))

vim.keymap.set({ "n", "x", "o" }, "[F", move_to("goto_previous_end", "@function.outer"))
vim.keymap.set({ "n", "x", "o" }, "[S", move_to("goto_previous_end", "@class.outer"))
vim.keymap.set({ "n", "x", "o" }, "[A", move_to("goto_previous_end", "@parameter.outer"))
vim.keymap.set({ "n", "x", "o" }, "[P", move_to("goto_previous_end", "@conditional.outer"))
