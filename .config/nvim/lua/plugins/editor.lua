return {
	{
		"ahmedkhalf/project.nvim",
		config = function()
			require("project_nvim").setup {
				detection_methods = { "pattern" }
			}
		end
	},
	{
		'Pocco81/auto-save.nvim',
		config = function()
			require("auto-save").setup {
				condition = function(bufnr)
					local Job = require 'plenary.job'
					local directory = vim.fn.expand('%:h')
					local filename = vim.fn.expand('%:p')

					if vim.fn.getbufvar(bufnr, "&modifiable") ~= 1
					    or filename == "" then
						return false
					end

					-- Only activate auto-save for files under version control
					local _, return_code = Job:new({
						command = 'git',
						args = { 'ls-files', '--error-unmatch', filename },
						cwd = directory
					}):sync()
					return return_code == 0
				end
			}
		end
	}
}
