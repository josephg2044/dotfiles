vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.relativenumber = true
vim.g.lua_snippets_path = vim.fn.stdpath("config") .. "/lua/custom/snippets"
vim.deprecate = function() end
vim.cmd("highlight Search guifg=black guibg=LightBlue")
vim.opt.wrap = false

vim.o.foldcolumn = "0"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true
