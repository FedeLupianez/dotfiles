return {
	{
		"neovim/nvim-lspconfig",
	},
	{
		"williamboman/mason.nvim",
	},

	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "saghen/blink.cmp" },
		opts = {
			ensure_installed = {
				"vtsls",
				"pyright",
			},
		},

		config = function()
			local lazy_setup = {
				pyright = { "python" },
				vtsls = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
				svelte = { "svelte" },
				lua_ls = { "lua" },
			}

			local capabilities = require("blink.cmp").get_lsp_capabilities()
			local lspconfig = require("lspconfig")

			lspconfig.clangd.setup({
				capabilities = capabilities,
				filetypes = { "c", "cpp", "objc", "objcpp", "arduino" },
				-- cmd = { "clangd", "--compile-commands-dir=." },
				cmd = { "clangd", "--background-index", "-j=12" },
				root_dir = require("lspconfig.util").root_pattern("platformio.ini", "compile_commands.json"),
			})

			for server, file_types in pairs(lazy_setup) do
				local opts = { capabilities = capabilities, filetypes = file_types }

				if server == "vtsls" then
					opts.settings = {
						typescript = {
							inlayHints = {
								enabled = true,
							},
							referencesCodeLens = {
								enabled = true,
							},
						},
						experimental = {
							documentHighlight = true,
						},
					}
				end
				lspconfig[server].setup(opts)
			end
		end,
	},
}
