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
    },
    v = {
         ["<"] = { "<gv", opts = { noremap = true, silent = true } },
         [">"] = { ">gv", opts = { noremap = true, silent = true } },
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
    }
}

-- more keybinds!

return M
