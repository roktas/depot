return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = { bashls = {} },
			settings = { bashls = {} },
		},
	},
	{
		"stevearc/conform.nvim",
		optional = true,
		opts = {
			formatters_by_ft = {
				bash = { "shfmt" },
				sh = { "shfmt" },
				zsh = { "shfmt" },
			},
		},
	},
}
