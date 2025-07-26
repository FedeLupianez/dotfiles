return {
	"akinsho/toggleterm.nvim",
	config = function()
		require("toggleterm").setup({
			size = 20,
			shell = vim.o.shell,
			open_mapping = "<F10>",
			shade_terminals = true,
			shading_factor = 1,
			start_in_insert = true,
			insert_mappings = true,
			terminal_mappings = true,
			persist_size = true,
			persist_mode = true,
			close_on_exit = true,
			direction = "float",
			float_opts = {
				border = "curved",
			},
		})
	end,
	enabled = true,
}
