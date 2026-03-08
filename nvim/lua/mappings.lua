local map = vim.keymap.set

map("i", "<C-b>", "<ESC>^i", { desc = "move beginning of line" })
map("i", "<C-e>", "<End>", { desc = "move end of line" })

map("n", "<C-h>", "<C-w>h", { desc = "switch window left" })
map("n", "<C-l>", "<C-w>l", { desc = "switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "switch window up" })

map("n", "M", "`", { desc = "remap M to jump to mark" })
map("n", "dm", require("guttermarks.actions").delete_mark, { desc = "Delete mark under cursor" })
map("n", "mm", require("guttermarks.actions").next_buf_mark, { desc = "Next mark in current buffer" })
map("n", "MM", require("guttermarks.actions").prev_buf_mark, { desc = "Previous mark in current buffer" })

map("n", "<Esc>", "<cmd>noh<CR>", { desc = "general clear highlights" })

map({ "n", "x" }, "<leader>fm", function()
	require("conform").format({ lsp_fallback = true })
end, { desc = "general format file" })

map("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "LSP diagnostic loclist" })

-- tabufline
map("n", "<leader>b", "<cmd>enew<CR>", { desc = "buffer new" })

map("n", "<tab>", function()
    require("core.tabufline").next()
end, { desc = "buffer goto next" })

map("n", "<S-tab>", function()
    require("core.tabufline").prev()
end, { desc = "buffer goto prev" })

map("n", "<leader>x", function()
    require("core.tabufline").close_buffer()
end, { desc = "buffer close" })

-- nvimtree
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "nvimtree toggle window" })

-- toggleable
map({ "n", "t" }, "<A-h>", function()
	require("core.term.init").toggle({ pos = "sp", id = "htoggleTerm" })
end, { desc = "terminal toggleable horizontal term" })

map({ "n", "t" }, "<A-i>", function()
	require("core.term.init").toggle({ pos = "float", id = "floatTerm" })
end, { desc = "terminal toggle floating term" })

map("n", ";", ":", { desc = "Enter command mode", nowait = true })

map("n", "<C-Up>", ":resize -2<CR>", { desc = "Resize split up", silent = true })
map("n", "<C-Down>", ":resize +2<CR>", { desc = "Resize split down", silent = true })
map("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Resize split left", silent = true })
map("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Resize split right", silent = true })

map("n", "<A-j>", "<Esc>:m .+1<CR>==gi", { desc = "Move line down", silent = true })
map("n", "<A-k>", "<Esc>:m .-2<CR>==gi", { desc = "Move line up", silent = true })

map("n", "<C-d>", "<C-d>zz", { desc = "Half-page down (center)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half-page up (center)" })
map("n", "n", "nzzzv", { desc = "Next search result (center)" })
map("n", "N", "Nzzzv", { desc = "Prev search result (center)" })

map("n", "<leader>ff", "<cmd>FzfLua files<CR>", { desc = "Find files" })
map("n", "<leader>fr", "<cmd>FzfLua live_grep_native<CR>", { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>FzfLua buffers<CR>", { desc = "Find buffers" })
map("n", "<leader>fh", "<cmd>FzfLua history<CR>", { desc = "Live grep" })
map("n", "<leader>fa", "<cmd>FzfLua marks<CR>", { desc = "Live grep" })

map("n", "<leader>fm", function()
	require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format", nowait = true })

map("v", "<", "<gv", { desc = "Indent left (keep selection)", silent = true })
map("v", ">", ">gv", { desc = "Indent right (keep selection)", silent = true })

map("v", "y", "ygv<Esc>", { desc = "Yank (keep selection)", silent = true })

map("x", "J", ":move '>+1<CR>gv-gv", { desc = "Move selection down", silent = true })
map("x", "K", ":move '<-2<CR>gv-gv", { desc = "Move selection up", silent = true })
map("x", "<S-j>", ":move '>+1<CR>gv-gv", { desc = "Move selection down", silent = true })
map("x", "<S-k>", ":move '<-2<CR>gv-gv", { desc = "Move selection up", silent = true })

map("n", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Terminal: focus left", silent = true })
map("n", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Terminal: focus down", silent = true })
map("n", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Terminal: focus up", silent = true })
map("n", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Terminal: focus right", silent = true })

map("n", "<leader>ll", "<cmd>VimtexCompile<CR>", { desc = "VimTeX compile" })
map("n", "<leader>lv", "<cmd>VimtexView<CR>", { desc = "VimTeX view" })
map("n", "<leader>LL", "<cmd>VimtexCompileSS<CR>", { desc = "VimTeX compile (SS)" })
