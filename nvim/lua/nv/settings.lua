-- See `:help vim.o`
-- Disable compatibility to old-time vi
vim.o.compatible = false
vim.o.showmatch = true -- Show matching brackets/parentheses
vim.o.ttyfast = true
vim.o.title = true
vim.o.titlestring = "%F"
-- Add line numbers
vim.wo.number = true

-- Add relative line numbers
vim.wo.relativenumber = true

-- Get bash-like tab completions
vim.o.wildmode = "longest,full"

-- Set an 80 column border for good coding style
vim.wo.colorcolumn = "80"

-- Highlight current cursorline
vim.wo.cursorline = true

-- Hide mode indicator
vim.o.showmode = false

-- Disable highlight of last search pattern
vim.o.hlsearch = false

-- Set laststatus=3
vim.o.laststatus = 3

-- Set window statusline to display the current file path
vim.wo.winbar = "%=%m\\ %<%f\\ %h%m%r%=%-14.(%l,%c%V%)%P"

-- Show symbols on the column (i.e. E error)
vim.wo.signcolumn = "yes"

-- Enable truecolor in the terminal if supported
if vim.fn.has("termguicolors") == 1 then
    vim.o.termguicolors = true
end
-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

