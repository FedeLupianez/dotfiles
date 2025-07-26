return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = { "astro", "css", "svelte", "cpp" },
			highlight = {
				enable = true, -- Habilitar Tree-sitter para resaltado de sintaxis
				disable = {}, -- No deshabilitar ningún lenguaje
				additional_vim_regex_highlighting = false, -- Deshabilitar resaltado con expresiones regulares
			},
		},
	},
}
