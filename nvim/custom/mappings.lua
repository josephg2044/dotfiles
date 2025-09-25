local M = {}

M.general = {
	n = {
		[";"] = { ":", "enter command mode", opts = { nowait = true } },
		["<C-Up>"] = { ":resize -2<CR>", opts = { noremap = true, silent = true } },
		["<C-Down>"] = { ":resize +2<CR>", opts = { noremap = true, silent = true } },
		["<C-Left>"] = { ":vertical resize -2<CR>", opts = { noremap = true, silent = true } },
		["<C-Right>"] = { ":vertical resize +2<CR>", opts = { noremap = true, silent = true } },
		["<A-j>"] = { "<Esc>:m .+1<CR>==gi", opts = { noremap = true, silent = true } },
		["<A-k>"] = { "<Esc>:m .-2<CR>==gi", opts = { noremap = true, silent = true } },
		["<C-d>"] = { "<C-d>zz" },
		["<C-u>"] = { "<C-u>zz" },
		["n"] = { "nzzzv" },
		["N"] = { "Nzzzv" },
		["<leader>cc"] = {
			"<cmd>!g++ % -o main -g<CR>",
		},
		["<leader>cl"] = {
			"<cmd>!echo $(latexmk -pdf main.tex) > compile.out; latexmk -c<CR>",
		},
		["<leader>ff"] = { "<cmd> Pick files <CR>", "Find files" },
		["<leader>fr"] = { "<cmd> Pick grep_live <CR>", "Find rg" },
		["<leader>fb"] = { "<cmd> Pick buffers <CR>", "Find buffers" },
		["<leader>tE"] = { "<cmd> Refactor extract_block <CR>" },
		["<leader>tt"] = { "<cmd> Refactor extract_var <CR>" },
		["<leader>tI"] = { "<cmd> Refactor inline_func <CR>" },
		["<leader>ti"] = { "<cmd> Refactor inline_var <CR>" },
		["<leader>fm"] = {
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			opts = { nowait = true },
		},
	},
	i = {
		["<Tab>"] = {
			function()
				local luasnip = require("luasnip")
				if luasnip.expand_or_jumpable() then
					luasnip.expand_or_jump()
				else
					vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
				end
			end,
			opts = { silent = true },
		},
		["<S-Tab>"] = {
			function()
				require("luasnip").expand()
			end,
			opts = { silent = true },
		},
		["<C-K>"] = {
			function()
				require("luasnip").jump(1)
			end,
			opts = { noremap = true, silent = true },
		},
		["<C-J>"] = {
			function()
				require("luasnip").jump(-1)
			end,
			opts = { noremap = true, silent = true },
		},
		["<C-k>"] = {
			function()
				require("luasnip").change_choice(-1)
			end,
			opts = { noremap = true, silent = true },
		},
		["<C-j>"] = {
			function()
				require("luasnip").change_choice(1)
			end,
			opts = { noremap = true, silent = true },
		},
	},
	v = {
		["<"] = { "<gv", opts = { noremap = true, silent = true } },
		[">"] = { ">gv", opts = { noremap = true, silent = true } },
		["y"] = { "ygv<esc>", norempa = true },
	},
	x = {
		["J"] = { ":move '>+1<CR>gv-gv", opts = { noremap = true, silent = true } },
		["K"] = { ":move '<-2<CR>gv-gv", opts = { noremap = true, silent = true } },
		["<S-j>"] = { ":move '>+1<CR>gv-gv", opts = { noremap = true, silent = true } },
		["<S-k>"] = { ":move '<-2<CR>gv-gv", opts = { noremap = true, silent = true } },
	},
	t = {
		["<C-h>"] = { "<C-\\><C-N><C-w>h", opts = { silent = true } },
		["<C-j>"] = { "<C-\\><C-N><C-w>j", opts = { silent = true } },
		["<C-k>"] = { "<C-\\><C-N><C-w>k", opts = { silent = true } },
		["<C-l>"] = { "<C-\\><C-N><C-w>l", opts = { silent = true } },
	},
}

M.dap = {
	plugin = true,
	n = {
		["<leader>db"] = {
			"<cmd> DapToggleBreakpoint <CR>",
			"Add breakpoint at line",
		},
		["<leader>dr"] = {
			"<cmd> DapContinue <CR>",
			"Start or continue the debugger",
		},
		["<leader>di"] = {
			"<cmd> DapStepInto <CR>",
		},
		["<leader>do"] = {
			"<cmd> DapStepOut <CR>",
		},
		["<leader>dv"] = {
			"<cmd> DapStepOver <CR>",
		},
		["<leader>j"] = {
			"<cmd> !javac % <CR>",
		},
	},
}

M.refactor = {
	plugin = true,
	n = {},
}

-- more keybinds!

return M
