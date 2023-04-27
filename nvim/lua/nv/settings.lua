vim.opt.list = true
vim.opt.listchars:append("space:⋅")
vim.opt.listchars:append("eol:↴")
vim.opt.listchars:append("nbsp:␣")
vim.o.compatible = false
vim.o.showmatch = true
vim.o.showmode = false
vim.o.title = true
vim.o.titlestring = "%F"
vim.wo.number = true
vim.wo.relativenumber = true
vim.o.wildmode = "longest,full"
vim.wo.colorcolumn = "80"
vim.wo.cursorline = true
vim.o.laststatus = 3
vim.wo.winbar = "%=%m\\ %<%f\\ %h%m%r%=%-14.(%l,%c%V%)%P"
vim.wo.signcolumn = "yes"
if vim.fn.has("termguicolors") == 1 then
    vim.o.termguicolors = true
end
vim.o.completeopt = 'menuone,noselect'
vim.o.mouse = 'a'
vim.o.clipboard = 'unnamedplus'
vim.opt.wrap = false

-- Enable folding
vim.cmd('filetype plugin on')
vim.opt.foldlevel = 20
vim.cmd([[
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
function FoldText()
	let line = getline(v:foldstart)
	let numOfLines = v:foldend - v:foldstart
	let fillCount = winwidth('%') - len(line) - len(numOfLines) - 14
	return line . '  ' . repeat('.', fillCount) . ' (' . numOfLines . ' L)'
endfunction
]])
vim.opt.fillchars = { fold = ' ' } -- removes trailing dotimes

-- Performance
vim.o.ttyfast = true
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.numberwidth = 4
vim.o.breakindent = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Splitting
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Miscellaneous
vim.opt.swapfile = false
vim.opt.undofile = true
-- vim.opt.undodir = '~/.config/nvim_plugins/undo'
vim.opt.hidden = true
