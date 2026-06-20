return {
	{
		"mason-org/mason.nvim",
		init = function()
			require("config.mason").clean_registry()
		end,
	},
	{
		"WhoIsSethDaniel/toggle-lsp-diagnostics.nvim",
		config = function()
			require("toggle_lsp_diagnostics").init(vim.diagnostic.config())
		end,
	},
}
