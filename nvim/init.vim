" General   
set nocompatible            " disable compatibility to old-time vi
set showmatch               " show matching
set ttyfast                 " Speed up scrolling in Vim
set title
" set titlestring=\ \ %F\ \ %{strftime('%Y-%m-%d\ %H:%M',getftime(expand('%')))}
set titlestring=%F

" Visual
set number                  " add line numbers
set relativenumber
set wildmode=longest,full   " get bash-like tab completions
set cc=80                  " set an 100 column border for good coding style
set cursorline              " highlight current cursorline
set noshowmode
set nohlsearch
set laststatus=3
if (has("termguicolors"))
    set termguicolors
endif

" set nowrap

" Code
filetype plugin indent on   "allow auto-indenting depending on file type
syntax on                   " syntax highlighting
filetype plugin on
set foldlevel=20
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

" Indent
set tabstop=4               " number of columns occupied by a tab 
set softtabstop=4           " see multiple spaces as tabstops so <BS> does the right thing
set expandtab               " converts tabs to white space
set shiftwidth=4            " width for autoindents
set autoindent              " indent a new line the same amount as the line just typed
set numberwidth=4           " columns used for the line number
" go specific
" au FileType go set noexpandtab
" au FileType go set tabstop=4

" Search
set ignorecase              " case insensitive 
set smartcase               " case insensitive search unless capital letters are used
set hlsearch                " highlight search 
set incsearch               " incremental search
set mouse=a                 " enable mouse click
set clipboard+=unnamedplus   " using system clipboard

" Split plane
set splitright
set splitbelow

" Others
" set spell                 " enable spell check (may need to download language package)
set noswapfile            " disable creating swap file
" set backupdir=~/.cache/vim " Directory to store backup files.
set hidden                 " navigate buffers without losing unsaved work


call plug#begin('~/.config/nvim/plugged')

" colorschemes, theme, icon
Plug 'kyazdani42/nvim-web-devicons'
Plug 'shaunsingh/nord.nvim'
Plug 'EdenEast/nightfox.nvim'
Plug 'jacoborus/tender.vim'
Plug 'Mofiqul/dracula.nvim'

" The main Telescope plugin
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', {'do': 'make' }

" Tab, Status, indicators
Plug 'nvim-lualine/lualine.nvim'
Plug 'akinsho/bufferline.nvim'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'folke/trouble.nvim'
Plug 'j-hui/fidget.nvim'

" Git Decorations (blame, diff)
Plug 'lewis6991/gitsigns.nvim'
Plug 'sindrets/diffview.nvim'

" LSP config
Plug 'williamboman/nvim-lsp-installer'
Plug 'neovim/nvim-lspconfig'
" Plug 'glepnir/lspsaga.nvim', { 'branch': 'main' }

" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }

" Autocompletion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
Plug 'hrsh7th/cmp-path'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'onsails/lspkind-nvim'
Plug 'numToStr/Comment.nvim'
Plug 'windwp/nvim-autopairs'

" File explorer
Plug 'kyazdani42/nvim-tree.lua'

" ext.
Plug 'folke/which-key.nvim'
Plug 'famiu/bufdelete.nvim'

" Language specific
" Plug 'ray-x/go.nvim'
" Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

call plug#end()

lua require('plugins/nvim-lsp-installer')
lua require('plugins/lsp')
lua require('plugins/telescope')
lua require('plugins/autopair')
lua require('plugins/nord')
lua require('plugins/gitsigns')
lua require('plugins/treesitter')
lua require('plugins/nvim-tree')
lua require('plugins/bufferline')
lua require('plugins/lualine')
lua require('plugins/indent-blankline')
lua require('plugins/diffview')
lua require('plugins/which-key')
lua require('plugins/scratches')
lua require('plugins/go')
lua require('Comment').setup()
lua require('fidget').setup{}
lua require('trouble').setup{}

" lua require('lspsaga').init_lsp_saga()

" Autoformat
" formatting_sync will be deprecated on vim 0.8
" https://github.com/neovim/nvim-lspconfig/issues/115#issuecomment-1130373799 
autocmd BufWritePre * lua vim.lsp.buf.formatting_sync()

" will prompt you to select the code action
" autocmd BufWritePre *.go lua vim.lsp.buf.code_action({ source = { organizeImports = true } })
" let nvim-lsp handle gopls server instead of vim-go
" let g:go_gopls_enabled = 0

" https://stackoverflow.com/a/6496995
" fun! Formatting()
"     " if &ft =~ 'ruby\|javascript\|perl'
"     if &ft =~ 'go'
"         lua require('go.format').gofmt()
"         return
"     endif
"
"     lua vim.lsp.buf.formatting_sync()
" endfun
"
" autocmd BufWritePre * call Formatting()


" remaps
let mapleader = ' '

" Text edits
nmap ,P "0P
nmap ,p "0p

" Plugins mapping
nnoremap \s :ScratchOpenFloat<Cr>

" windows
nnoremap <silent><leader>h :wincmd h<Cr>
nnoremap <silent><leader>j :wincmd j<Cr>
nnoremap <silent><leader>k :wincmd k<Cr>
nnoremap <silent><leader>l :wincmd l<Cr>
nnoremap <silent><leader>= <C-w>=
nnoremap <silent><leader>v :vsplit<Cr>

nnoremap <silent><ESC> :nohlsearch<Bar>:echo<Cr>

" Buffers
" Tab switch buffer
nnoremap <silent><TAB> :BufferLineCycleNext<CR>
nnoremap <silent><S-TAB> :BufferLineCyclePrev<CR>
nnoremap <silent><leader>dd :Bdelete<CR>
" Close all buffers except current one
nnoremap <silent><leader>da <C-b>:%bd\|e#<CR> 
nnoremap <silent><leader>1 <Cmd>BufferLineGoToBuffer 1<CR>
nnoremap <silent><leader>2 <Cmd>BufferLineGoToBuffer 2<CR>
nnoremap <silent><leader>3 <Cmd>BufferLineGoToBuffer 3<CR>
nnoremap <silent><leader>4 <Cmd>BufferLineGoToBuffer 4<CR>
nnoremap <silent><leader>5 <Cmd>BufferLineGoToBuffer 5<CR>
"
" Telescope mappings
" nnoremap <leader>ff <cmd>Telescope find_files<cr>
" nnoremap <leader>fg <cmd>Telescope live_grep<cr>
" nnoremap <leader>fb <cmd>Telescope buffers<cr>
" nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <silent><leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <silent><leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <silent><leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <silent><leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
nnoremap <silent><leader>fs <cmd>lua require('telescope.builtin').grep_string()<cr>
nnoremap <silent><leader>fc <cmd>lua require('telescope.builtin').git_files()<cr>

" NvimTree mappings
nnoremap <silent><C-b> :NvimTreeToggle<CR>
nnoremap <silent><leader>r :NvimTreeRefresh<CR>

" Trouble mappings
" https://github.com/folke/trouble.nvim
nnoremap <leader>xx <cmd>TroubleToggle<cr>
nnoremap <leader>xw <cmd>TroubleToggle workspace_diagnostics<cr>
nnoremap <leader>xd <cmd>TroubleToggle document_diagnostics<cr>
nnoremap <leader>xq <cmd>TroubleToggle quickfix<cr>
nnoremap <leader>xl <cmd>TroubleToggle loclist<cr>
nnoremap gR <cmd>TroubleToggle lsp_references<cr>

" Lspsaga mappings
" https://github.com/glepnir/lspsaga.nvim
" nnoremap <silent>gh :Lspsaga lsp_finder<CR>
" nnoremap <silent><leader>ca :Lspsaga code_action<CR>
" vnoremap <silent><leader>ca :<C-U>Lspsaga range_code_action<CR>
" nnoremap <silent>T :Lspsaga open_floaterm<CR>
" tnoremap <silent>T <C-\><C-n>:Lspsaga close_floaterm<CR>

" vim edit configuration
nnoremap <S-Up> :m-2<CR>
nnoremap <S-Down> :m+<CR>
inoremap <S-Up> <Esc>:m-2<CR>
inoremap <S-Down> <Esc>:m+<CR>

" colorscheme nord
" colorscheme nightfox
" colorscheme dawnfox
" colorscheme terafox
" colorscheme duskfox
" colorscheme nordfox
" colorscheme tender
colorscheme dracula

