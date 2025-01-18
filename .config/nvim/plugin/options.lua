-- Options
--- Visuals
vim.cmd [[highlight LineNr guifg=#5eacd3]]

--- Workspace
vim.o.exrc = false
vim.o.undofile = true
vim.o.backup = false
vim.o.swapfile = false

--- Buffers
vim.o.hidden = true

--- Commands
vim.o.inccommand = "split"

--- Searching
vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true

--- Lines
vim.opt.wrap = true
vim.o.number = true
vim.o.relativenumber = true

-- Inserting
vim.opt.showmatch = true
vim.opt.autoindent = true
vim.opt.cindent = true

--- Editor
vim.o.scrolloff = 10
vim.o.breakindent = true
vim.o.colorcolumn = "81"
vim.o.cursorline = true
vim.o.updatetime = 250
vim.opt.wildmode = { "longest", "full" }
vim.opt.completeopt = { "menuone", "noselect", "noinsert" }
vim.opt.diffopt =
  { "internal", "filler", "closeoff", "hiddenoff", "linematch:60", "algorithm:patience" }

--- Status
vim.o.signcolumn = "yes"
vim.o.ruler = true

--- Spelling
vim.o.spell = true
vim.o.spelllang = "en_gb"

vim.filetype.add { extension = { uproject = "json", ["code-snippets"] = "jsonc" } }
