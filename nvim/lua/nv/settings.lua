vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣', eol = '↴', space = '⋅' }
vim.g.editorconfig = true
vim.o.compatible = false
vim.o.showmatch = true
vim.o.showmode = false
vim.o.title = true
vim.o.titlestring = '%F'
vim.wo.number = true
-- vim.wo.relativenumber = true
vim.o.wildmode = 'longest,full'
-- vim.wo.colorcolumn = "80"
vim.wo.cursorline = true
vim.o.laststatus = 3
-- vim.o.winbar = "%=%f"
vim.wo.signcolumn = 'yes'
if vim.fn.has 'termguicolors' == 1 then
  vim.o.termguicolors = true
end
vim.o.completeopt = 'menuone,noselect'
vim.o.mouse = 'a'
vim.o.clipboard = 'unnamedplus'
vim.opt.wrap = false

-- Enable folding
vim.cmd 'filetype plugin on'
vim.opt.foldlevel = 20
vim.cmd [[
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
function FoldText()
	let line = getline(v:foldstart)
	let numOfLines = v:foldend - v:foldstart
	let fillCount = winwidth('%') - len(line) - len(numOfLines) - 14
	return line . '  ' . repeat('.', fillCount) . ' (' . numOfLines . ' L)'
endfunction
]]
vim.opt.fillchars = { fold = ' ' } -- removes trailing dotimes
-- Netrw
vim.cmd [[
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 3
let g:netrw_altv = 1
let g:netrw_winsize = 25
" augroup ProjectDrawer
"   autocmd!
"   autocmd VimEnter * :Vexplore
" augroup END
]]
-- Performance
vim.o.ttyfast = true
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Indentation
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.numberwidth = 4
vim.o.breakindent = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.inccommand = 'split'

-- Splitting
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Miscellaneous
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.scrolloff = 10
vim.cmd [[
    aunmenu PopUp.How-to\ disable\ mouse
    aunmenu PopUp.-1-
]]
-- vim.opt.undodir = '~/.config/nvim_plugins/undo'
vim.opt.hidden = true

-- [[ Highlight on yank ]]
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = vim.api.nvim_create_augroup('YankHighlight', { clear = true }),
  pattern = '*',
})
