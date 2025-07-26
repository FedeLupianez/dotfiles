return {
	{
		"echasnovski/mini.animate",
		enabled = false,
	},
	{
		"echasnovski/mini.nvim",
		enabled = false,
	},
	{
		"echasnovski/mini.splitjoin",
		version = false,
		config = function()
			require("mini.splitjoin").setup({})
		end,
	},
}
