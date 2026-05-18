------------------------------------------------------------------------------------------------------------------------
--- Core settings
------------------------------------------------------------------------------------------------------------------------

return {
	-- nord.nvim
	{
		"gbprod/nord.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("nord").setup({})
			vim.cmd.colorscheme("nord")
			vim.schedule(function()
				vim.cmd([[hi WinSeparator guifg=#ff0000]])
			end)
		end,
	},

	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "nord",
		},
	},
}
