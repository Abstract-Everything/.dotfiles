return {
	"mfussenegger/nvim-dap",
	{
		"nvim-telescope/telescope-dap.nvim",
		config = function ()
			local silent_noremap = { silent = true, noremap = true }

			-- Debug Adapter Protocol
			local dap = require('dap')

			dap.adapters.lldb = {
				type = 'executable',
				command = '/usr/bin/lldb-vscode',
				name = 'lldb'
			}

			-- launch.json uses type both the filetype and the adapter. Having this alias
			-- adapter allows us to add a configuration to cpp and use the correct adapter
			dap.adapters.cpp = dap.adapters.lldb

			dap.configurations.cpp = {
				{
					name = 'launch cpp',
					type = 'lldb',
					request = 'launch',
					program = function()
						return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
					end,
					cwd = '${workspaceFolder}',
					stopOnEntry = true,
					args = {},
				}
			}

			-- Place project specific configurations in ${worksapce}/.config/dap.json
			-- Example configuration:
			-- {
			-- 	"version": "0.2.0",
			-- 	"configurations": [
			-- 		{
			-- 			"name": "Test configuration",
			-- 			"type": "cpp",
			-- 			"request": "launch",
			-- 			"program": "/path/to/program",
			-- 			"args": { "arg1", "arg2" },
			-- 			"stopOnEntry": true
			-- 		}
			-- 	]
			-- }
			local load_project_dap_configurations = function()
				require('dap.ext.vscode').load_launchjs(vim.fn.getcwd() .. '/.config/dap.json')
			end

			vim.api.nvim_create_user_command('Debug', function()
				load_project_dap_configurations()

				local configurations = {}

				for name, list in pairs(dap.configurations) do
					for i in pairs(list) do
						table.insert(configurations, list[i])
					end
				end

				if #configurations == 0 then
					print('No configurations available to run')
					return
				end

				vim.ui.select(configurations, {
					prompt = 'Select which configuration to launch',
					format_item = function(configuration)
						return configuration.name
					end,
				}, function(configuration)
					if (configuration) then
						require 'dap'.run(configuration)
					end
				end)
			end, { nargs = 0 })

			vim.api.nvim_set_keymap('n', '<leader>dr', "<cmd>lua require('dap').run_last()<CR>", silent_noremap)
			vim.api.nvim_set_keymap('n', '<leader>db', "<cmd>lua require('dap').toggle_breakpoint()<CR>", silent_noremap)
			vim.api.nvim_set_keymap('n', '<leader>dh', "<cmd>lua require('dap').run_to_cursor()<CR>", silent_noremap)
			vim.api.nvim_set_keymap('n', '<leader>dc', "<cmd>lua require('dap').continue()<CR>", silent_noremap)
			vim.api.nvim_set_keymap('n', '<leader>ds', "<cmd>lua require('dap').step_into()<CR>", silent_noremap)
			vim.api.nvim_set_keymap('n', '<leader>dn', "<cmd>lua require('dap').step_over()<CR>", silent_noremap)
			vim.api.nvim_set_keymap('n', '<leader>df', "<cmd>lua require('dap').step_out()<CR>", silent_noremap)
			vim.api.nvim_set_keymap('n', '<leader>dt', "<cmd>lua require('dap').repl.open()<CR>", silent_noremap)
		end
	},
}
