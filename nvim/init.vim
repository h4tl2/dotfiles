" General   
set nocompatible            " disable compatibility to old-time vi
set showmatch               " show matching
set ttyfast                 " Speed up scrolling in Vim

" Visual
set number                  " add line numbers
set relativenumber
set wildmode=longest,list   " get bash-like tab completions
set cc=100                  " set an 80 column border for good coding style
set cursorline              " highlight current cursorline
set noshowmode

" Code
filetype plugin indent on   "allow auto-indenting depending on file type
syntax on                   " syntax highlighting
filetype plugin on

" Indent
set tabstop=4               " number of columns occupied by a tab 
set softtabstop=4           " see multiple spaces as tabstops so <BS> does the right thing
set expandtab               " converts tabs to white space
set shiftwidth=4            " width for autoindents
set autoindent              " indent a new line the same amount as the line just typed
set numberwidth=4           " columns used for the line number

" Search
set ignorecase              " case insensitive 
set smartcase               " case insensitive search unless capital letters are used
set hlsearch                " highlight search 
set incsearch               " incremental search
set mouse=a                 " enable mouse click
set clipboard=unnamedplus   " using system clipboard

" Split plane
set splitright
set splitbelow

" Others
" set spell                 " enable spell check (may need to download language package)
" set noswapfile            " disable creating swap file
" set backupdir=~/.cache/vim " Directory to store backup files.
" set hidden                 " navigate buffers without losing unsaved work


call plug#begin('~/.config/nvim/plugged')

Plug 'shaunsingh/nord.nvim'
" Telescope, gitsigns requires plenary to function
Plug 'nvim-lua/plenary.nvim'
" The main Telescope plugin
Plug 'nvim-telescope/telescope.nvim'
" An optional plugin recommended by Telescope docs
Plug 'nvim-telescope/telescope-fzf-native.nvim', {'do': 'make' }
" Tab, Status indicators
Plug 'nvim-lualine/lualine.nvim'
Plug 'akinsho/bufferline.nvim'
" Git Decorations (blame, diff)
Plug 'lewis6991/gitsigns.nvim'
" LSP config
Plug 'williamboman/nvim-lsp-installer'
Plug 'neovim/nvim-lspconfig'
" Autocompletion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'onsails/lspkind-nvim'
Plug 'glepnir/lspsaga.nvim'
" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
" Devicons
Plug 'kyazdani42/nvim-web-devicons'
" File explorer
Plug 'kyazdani42/nvim-tree.lua'
" Show Diagnostics
" todo find another alternative than trouble.nvim
call plug#end()

"lua require('plugins')
lua require('plugins/telescope')
lua require('plugins/nord')
lua require('plugins/gitsigns')
lua require('plugins/nvim-lsp-installer')
lua require('plugins/lsp')
lua require('plugins/treesitter')
lua require('plugins/nvim-tree')
lua require('plugins/bufferline')
lua require('plugins/lualine')


" Plugin Configuration
autocmd BufWritePre * lua vim.lsp.buf.formatting_sync()

" remaps
let mapleader = ' '

nnoremap <leader>h :wincmd h<Cr>
nnoremap <leader>j :wincmd j<Cr>
nnoremap <leader>k :wincmd k<Cr>
nnoremap <leader>l :wincmd l<Cr>

nnoremap <C-p> :Telescope find_files<Cr>
" nnoremap <leader>n :NERDTreeFocus<CR>
" nnoremap <C-n> :NERDTree<CR>
" nnoremap <C-b> :NERDTreeToggle<CR>
" nnoremap <C-f> :NERDTreeFind<CR>

colorscheme nord

