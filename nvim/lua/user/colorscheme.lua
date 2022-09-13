vim.cmd [[
try
  colorscheme ayu
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
  endtry
]]
vim.cmd('hi Normal guibg=#0e0e10')
-- set background=dark
