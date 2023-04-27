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
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
function FoldText()
	local line = vim.fn.getline(vim.v.foldstart)
	local numOfLines = vim.v.foldend - vim.v.foldstart
	local fillCount = vim.fn.winwidth('%') - #line - #numOfLines - 14
	return line .. '  ' .. string.rep('.', fillCount) .. ' (' .. numOfLines .. ' L)'
end
vim.opt.foldtext = 'v:lua.FoldText()'
vim.opt.fillchars = {fold=' '} -- removes trailing dotimes

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
