-- <F1>: Diagnostics / No Diagnostics
vim.keymap.set({ "n", "x" }, "<F1>", function()
	require("toggle_lsp_diagnostics").toggle_diagnostics()
end, { silent = true })

-- <F2>: Troubles / No Troubles
vim.keymap.set({ "n", "x" }, "<F2>", function()
	require("trouble").toggle()
end)

-- <F5>: Format
vim.keymap.set({ "n", "v" }, "<F5>", function()
	LazyVim.format({ force = true }) -- luacheck: ignore
end)

-- <F6>:  Action
-- <F7>:  Rename
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(event)
		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = event.buf }

		vim.keymap.set({ "n", "v" }, "<F6>", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "<F7>", vim.lsp.buf.rename, opts)
	end,
})

-- <">: Switch Window
vim.keymap.set("", '"', "<C-W>w")

-- <M-s/S>: Update/Write All
vim.keymap.set({ "n", "x" }, "<M-s>", ":update<CR>")
vim.keymap.set("i", "<M-s>", "<C-O>:update<CR>")
vim.keymap.set({ "n", "x" }, "<M-S>", ":wall<CR>")
vim.keymap.set("i", "<M-S>", "<C-O>:wall<CR>")

-- <M-q/Q>: Quit/Quit All
vim.keymap.set({ "n", "x" }, "<M-q>", ":q<CR>", { silent = true })
vim.keymap.set("i", "<M-q>", "<C-O>:q<CR>", { silent = true })
vim.keymap.set({ "n", "x" }, "<M-Q>", ":q!<CR>", { silent = true })

-- <Y>: Yank to end
vim.api.nvim_set_keymap("n", "Y", "y$", { noremap = true, silent = true })

-- <CR>: Disable search highlight with a simple key
vim.api.nvim_set_keymap("n", "<CR>", ":noh<CR>", { noremap = true, nowait = true, silent = true })

-- <ı>: Toggle Split

local splitted_window = nil

local function toggle_split(is_vertical)
	if splitted_window then
		vim.api.nvim_win_close(splitted_window, false)
		splitted_window = nil
	else
		if is_vertical then
			vim.cmd([[vsplit]])
		else
			vim.cmd([[split]])
		end
		splitted_window = vim.fn.win_getid()
	end
end

vim.keymap.set("", "ı", function()
	toggle_split(false)
end)

-- <~>: uniq sort
vim.keymap.set("v", "~", ":sort u<cr>")

-- <ö>: Jump to previous diagnostic
vim.keymap.set({ "n", "x" }, "ö", function()
	vim.diagnostic.goto_prev()
end)

-- <ç>: Jump to next diagnostic
vim.keymap.set({ "n", "x" }, "ç", function()
	vim.diagnostic.goto_next()
end)

-- Don't replace my clipboard when <Del>
vim.api.nvim_set_keymap("n", "<Del>", '"_x', { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<Del>", '"_x', { noremap = true, silent = true })

-- Use <Alt> instead of <Ctrl> for increment/decrement mappings (needed under Tmux)
vim.api.nvim_set_keymap("n", "<A-a>", "<C-a>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<A-a>", "<C-a>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<A-x>", "<C-x>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<A-x>", "<C-x>", { noremap = true, silent = true })

-- Following lines in section are from Fatih: https://github.com/fatih/dotfiles

-- Run gofmt/gofmpt, import packages automatically on save
vim.api.nvim_create_autocmd("BufWritePre", {
	group = vim.api.nvim_create_augroup("setGoFormatting", { clear = true }),
	pattern = "*.go",
	callback = function()
		local params = vim.lsp.util.make_range_params()
		params.context = { only = { "source.organizeImports" } }
		local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 2000)
		for _, res in pairs(result or {}) do
			for _, r in pairs(res.result or {}) do
				if r.edit then
					vim.lsp.util.apply_workspace_edit(r.edit, "utf-16")
				else
					vim.lsp.buf.execute_command(r.command)
				end
			end
		end

		vim.lsp.buf.format()
	end,
})

-- Don't jump forward if I higlight and search for a word
local function stay_star()
	local sview = vim.fn.winsaveview()
	local args = string.format("keepjumps keeppatterns execute %q", "sil normal! *")
	vim.api.nvim_command(args)
	vim.fn.winrestview(sview) ---@diagnostic disable-line
end
vim.keymap.set("n", "*", stay_star, { noremap = true, silent = true })

-- If I visually select words and paste from clipboard, don't replace my
-- clipboard with the selected word, instead keep my old word in the
-- clipboard
vim.keymap.set("x", "p", '"_dP')

-- Search mappings: These will make it so that going to the next one in a
-- search will center on the line it's found in.
vim.keymap.set("n", "n", "nzzzv", { noremap = true })
vim.keymap.set("n", "N", "Nzzzv", { noremap = true })

-- Define abbreviation for Copilot and CopilotChat
vim.cmd([[cnoreabbrev CC CopilotChat]])
vim.cmd([[cnoreabbrev CD CopilotChatDocs]])
vim.cmd([[cnoreabbrev CE CopilotChatExplain]])
vim.cmd([[cnoreabbrev CF CopilotChatFix]])
vim.cmd([[cnoreabbrev CO CopilotChatOptimize]])
vim.cmd([[cnoreabbrev CR CopilotChatReview]])
vim.cmd([[cnoreabbrev CT CopilotChatTests]])
vim.cmd([[cnoreabbrev cC CopilotChatCommitStaged]])
vim.cmd([[cnoreabbrev cc CopilotChatCommit]])
vim.cmd([[cnoreabbrev cf CopilotChatFixDiagnostic]])
