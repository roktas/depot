return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				ruby_lsp = { cmd = { "bundle", "exec", "ruby-lsp" } },
			},
		},
	},
	{
		"stevearc/conform.nvim",
		optional = true,
		opts = {
			formatters_by_ft = {
				ruby = { "rubyfmt" },
			},
		},
	},
}
