local set = vim.opt


-- vim.opt.foldmethod     = 'expr'
-- vim.opt.foldexpr       = 'nvim_treesitter#foldexpr()'
---WORKAROUND
vim.api.nvim_create_autocmd({'BufEnter','BufAdd','BufNew','BufNewFile','BufWinEnter'}, {
  group = vim.api.nvim_create_augroup('TS_FOLD_WORKAROUND', {}),
  callback = function()
    vim.opt.foldmethod     = 'expr'
    vim.opt.foldexpr       = 'nvim_treesitter#foldexpr()'
  end
})
---ENDWORKAROUND


vim.notify = require("notify")

set.expandtab = true
set.smarttab = true
set.tabstop = 4
set.shiftwidth = 4

set.hlsearch = true
set.incsearch = true 
set.ignorecase = true
set.smartcase = true

set.splitbelow = true
set.splitright = true

set.wrap = false
set.scrolloff = 5
set.fileencoding = 'utf-8'
set.termguicolors = true
set.relativenumber = true
set.cursorline = true

set.hidden = true

