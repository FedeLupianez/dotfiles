return {
	"FedeLupianez/RandomPluginNvim",
	config = function()
		opts = {
			defaults = {
				min_number = 1,
				max_number = 999,
				length_string = 7,
			},

			keymaps = {
				random_number = "<leader>rn",
				random_string = "<leader>rs",
				random_format = "<leader>rf",
			},
		}
		require("RandomPlugin").setup(opts)
	end,
	enabled = false,
}
