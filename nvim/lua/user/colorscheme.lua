vim.cmd [[
try
  colorscheme ayu
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
  endtry
]]
vim.cmd('hi Normal guibg=#0a0a0a')
-- set background=dark
