return {
	{
		"mason-org/mason.nvim",
		opts = { ensure_installed = { "markdownlint" } },
	},
	{
		"mfussenegger/nvim-lint",
		opts = {
			linters_by_ft = {
				markdown = { "markdownlint" },
			},
		},
	},
}
