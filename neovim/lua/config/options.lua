vim.g.autoformat = false
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.o.autochdir = true
vim.o.clipboard = "unnamedplus"
vim.o.comments = "fb:-,fb:+,fb:*,fb::"
vim.o.completeopt = "menuone,noselect"
vim.o.cursorline = true
vim.o.expandtab = false
vim.o.foldenable = false
vim.o.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.foldmethod = "expr"
vim.o.hidden = false
vim.o.incsearch = true
vim.o.laststatus = 2
vim.o.list = false
vim.o.mouse = "a"
vim.o.nrformats = "bin,hex,alpha"
vim.o.shiftwidth = 8
vim.o.showmode = false
vim.o.smartindent = true
vim.o.softtabstop = 8
vim.o.spelllang = "en"
vim.o.splitbelow = false
vim.o.tabstop = 8
vim.o.termguicolors = true
vim.o.textwidth = 140
vim.o.updatetime = 250
vim.wo.signcolumn = "yes"

if vim.fn.has("unix") == 1 then
	vim.opt.shell = "bash"
end

vim.cmd([[autocmd TextYankPost * lua vim.highlight.on_yank {on_visual = true}]])
vim.cmd([[command! -nargs=0 WS %s/\s\+$//gce]])
