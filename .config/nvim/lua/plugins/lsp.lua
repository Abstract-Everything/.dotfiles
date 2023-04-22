return {
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		config = function ()
			require("mason").setup()
		end
	},
	'neovim/nvim-lspconfig',
	-- Specific language server extensions
	'p00f/clangd_extensions.nvim',
	{
		-- https://rsdlt.github.io/posts/rust-nvim-ide-guide-walkthrough-development-debug/
		'simrat39/rust-tools.nvim',
		dependencies = { 'rust-lang/rust.vim' }
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function ()
			require("mason-lspconfig").setup {
				ensure_installed = { 'lua_ls' }
			}

			local capabilities = require('cmp_nvim_lsp').default_capabilities()

			local on_attach = function(client, bufnr)
				local silent_noremap = { silent = true, noremap = true }

				vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

				vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd',         '<cmd>lua vim.lsp.buf.definition()<CR>', silent_noremap)
				vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD',         '<cmd>lua vim.lsp.buf.type_definition()<CR>', silent_noremap)
				vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi',         '<cmd>lua vim.lsp.buf.implementation()<CR>', silent_noremap)
				vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr',         '<cmd>lua vim.lsp.buf.references()<CR>', silent_noremap)
				vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K',          '<cmd>lua vim.lsp.buf.hover()<CR>', silent_noremap)
				vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>',      '<cmd>lua vim.lsp.buf.signature_help()<CR>', silent_noremap)
				vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', silent_noremap)
				vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', silent_noremap)
				vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', silent_noremap)
				vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', silent_noremap)
				vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', silent_noremap)
			end

			require("mason-lspconfig").setup_handlers {
				function (server_name) -- default handler
					require("lspconfig")[server_name].setup {
						on_attach = on_attach,
						capabilities = capabilities,
					}
				end,
				["lua_ls"] = function()
					require("lspconfig")["lua_ls"].setup {
						on_attach = on_attach,
						capabilities = capabilities,
						settings = {
							Lua = {
								runtime = {
									version = 'LuaJIT',
									path = vim.split(package.path, ';'),
								},
								diagnostics = {
									globals = { 'vim' },
								},
								workspace = {
									library = {
										[vim.fn.expand('$VIMRUNTIME/lua')] = true,
										[vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
									},
								},
								telemetry = {
									enable = false,
								},
							}
						}
					}
				end,
				["clangd"] = function()
					require("clangd_extensions").setup {
						server = {
							on_attach = on_attach,
							capabilities = capabilities,
						},
						extensions = {
							autoSetHints = true,
							inlay_hints = {
								only_current_line = false,
								only_current_line_autocmd = "CursorHold",
								show_parameter_hints = true,
								parameter_hints_prefix = "<- ",
								other_hints_prefix = "=> ",
								max_len_align = false,
								max_len_align_padding = 1,
								right_align = false,
								right_align_padding = 81,
								highlight = "Comment",
								priority = 100,
							},
							ast = {
								role_icons = {
									type = "",
									declaration = "",
									expression = "",
									specifier = "",
									statement = "",
									["template argument"] = "",
								},
								kind_icons = {
									Compound = "",
									Recovery = "",
									TranslationUnit = "",
									PackExpansion = "",
									TemplateTypeParm = "",
									TemplateTemplateParm = "",
									TemplateParamObject = "",
								},
								highlights = {
									detail = "Comment",
								},
								memory_usage = {
									border = "none",
								},
								symbol_info = {
									border = "none",
								},
							},
						}
					}
				end,
				["rust_analyzer"] = function()
					local rust_on_attach = function(client, bufnr)
						local silent_noremap = { silent = true, noremap = true }
						vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gq', '<cmd>lua vim.lsp.buf.format({ range = nil })<CR>', silent_noremap)
						on_attach(client, bufnr)
					end

					require('rust-tools').setup {
						server = {
							on_attach = rust_on_attach,
							capabilities = capabilities,
						},
					}
				end,
			}
		end
	}
}

