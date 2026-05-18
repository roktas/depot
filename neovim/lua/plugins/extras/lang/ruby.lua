return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				ruby_lsp = { cmd = { "bundle", "exec", "ruby-lsp" } },
			},
		},
	},
}
