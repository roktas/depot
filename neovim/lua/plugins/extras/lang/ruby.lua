local function rubocop_autocorrect(buf)
	buf = buf or vim.api.nvim_get_current_buf()

	local file = vim.api.nvim_buf_get_name(buf)
	if file == "" then
		vim.notify("Save the buffer before running RuboCop", vim.log.levels.WARN)
		return
	end

	if vim.bo[buf].modified then
		vim.api.nvim_buf_call(buf, function()
			vim.cmd.update()
		end)
	end

	local root = vim.fs.root(file, { "Gemfile" })
	local cmd = { "rubocop", "-A", file }
	local cwd = vim.fn.getcwd()

	if root then
		cwd = root
		if vim.fn.executable("bundle") == 1 then
			cmd = { "bundle", "exec", "rubocop", "-A", file }
		end
	end

	vim.notify(table.concat(cmd, " "), vim.log.levels.INFO)
	vim.system(cmd, { cwd = cwd, text = true }, function(result)
		vim.schedule(function()
			if result.code == 0 then
				vim.cmd.checktime()
				vim.notify("RuboCop autocorrect finished", vim.log.levels.INFO)
				return
			end

			local output = vim.trim((result.stderr or "") .. "\n" .. (result.stdout or ""))
			vim.notify(output ~= "" and output or "RuboCop autocorrect failed", vim.log.levels.ERROR)
		end)
	end)
end

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
	{
		"LazyVim/LazyVim",
		init = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "ruby",
				callback = function(event)
					vim.keymap.set("n", "<S-F5>", function()
						rubocop_autocorrect(event.buf)
					end, { buffer = event.buf, desc = "RuboCop autocorrect all" })
				end,
			})
		end,
	},
}
