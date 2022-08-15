" vim:fileencoding=utf-8:foldmethod=marker:foldlevel=0

" General {{{
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
set cc=80                  " set an 80 column border for good coding style
set cursorline              " highlight current cursorline
set noshowmode
set nohlsearch
set laststatus=3
set winbar=%=%m\ %f
" set signcolumn=yes       " show symbols on the column (i.e. E error)
if (has("termguicolors"))
    set termguicolors
endif

" https://github.com/kovidgoyal/kitty/issues/108#issuecomment-320492772
" if has('gui_running') || has('nvim')
"     hi Normal 		guifg=#f6f3e8 guibg=#242424
" else
"     " Set the terminal default background and foreground colors, thereby
"     " improving performance by not needing to set these colors on empty cells.
"     hi Normal guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE
"     let &t_ti = &t_ti . "\033]10;#f6f3e8\007\033]11;#242424\007"
"     let &t_te = &t_te . "\033]110\007\033]111\007"
" endif

" Code
set nowrap
filetype plugin indent on   " allow auto-indenting depending on file type
syntax on                   " syntax highlighting
filetype plugin on
set foldlevel=20
" set foldnestmax=1
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
set mousemodel=extend       " disable right click in neovim 8.0"
set clipboard=unnamedplus   " using system clipboard

" Split plane
set splitright
set splitbelow

" Others
" set spell                 " enable spell check (may need to download language package)
set noswapfile            " disable creating swap file
" set backupdir=~/.cache/vim " Directory to store backup files.
set hidden                 " navigate buffers without losing unsaved work
lua require('settings')
" }}}

" Plugins {{{
" Plug install {{{
call plug#begin('~/.config/nvim_plugins/plugged')

" Performance
Plug 'lewis6991/impatient.nvim'

" colorschemes, theme, icon
Plug 'kyazdani42/nvim-web-devicons'
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }

" Telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', {'do': 'make' }

" UI (Tab, Status, indicators)
Plug 'nvim-lualine/lualine.nvim'
Plug 'akinsho/bufferline.nvim' " TODO: might replace bufferline with lualine
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'folke/trouble.nvim'
Plug 'simrat39/symbols-outline.nvim'
Plug 'j-hui/fidget.nvim' " LSP status indicator

" Git Decorations (blame, diff)
Plug 'lewis6991/gitsigns.nvim'
Plug 'sindrets/diffview.nvim'

" LSP config
Plug 'williamboman/nvim-lsp-installer' " TODO: might replace with mason.nvim
Plug 'neovim/nvim-lspconfig'
Plug 'jose-elias-alvarez/null-ls.nvim'

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
Plug 'windwp/nvim-spectre'
Plug 'cappyzawa/trim.nvim'

" File explorer
Plug 'kyazdani42/nvim-tree.lua'

" ext.
Plug 'folke/which-key.nvim'
Plug 'famiu/bufdelete.nvim'
Plug 'NTBBloodbath/rest.nvim'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }

" Language specific
" ---
" Golang
" Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
" Use these plugins instead of vim-go
" TODO: gofillstructs is still need to find replacement
Plug 'mattn/vim-goaddtags'
Plug 'buoto/gotests-vim'

call plug#end()
" }}}

lua require('impatient')
lua require('plugins/lsp')
" lua require('plugins/null-ls')
lua require('nvim-lsp-installer').setup{}
lua require('which-key').setup{}
lua require('diffview').setup{}
lua require('Comment').setup{}
lua require('fidget').setup{}
lua require('trouble').setup{}
lua require('spectre').setup{}
lua require('rest-nvim').setup{}
lua require('plugins/telescope')
lua require('plugins/autopair')
lua require('plugins/gitsigns')
lua require('plugins/treesitter')
lua require('plugins/nvim-tree')
lua require('plugins/bufferline')
" lua require('plugins/statusline')
lua require('plugins/yasl')
" lua require('plugins/lualine')
lua require('plugins/indent-blankline')
lua require('plugins/scratches')
lua require('plugins/go')
lua require('plugins/snippets')
lua require('plugins/trim')
lua require('plugins/colors')

" }}}

" Others {{{
" let nvim-lsp handle gopls server instead of vim-go
" let g:go_gopls_enabled = 0

" will prompt you to select the code action
" autocmd BufWritePre *.go lua vim.lsp.buf.code_action({ source = { organizeImports = true } })
" }}}

" Keymap
let mapleader = ' '

" Text edits {{{
nmap ,P "0P
nmap ,p "0p
" still got no time to study macros
nmap q <nop>
nnoremap <silent><ESC> :nohlsearch<Bar>:echo<Cr>
" vim edit configuration
nnoremap <S-Up> :m-2<CR>
nnoremap <S-Down> :m+<CR>
inoremap <S-Up> <Esc>:m-2<CR>
inoremap <S-Down> <Esc>:m+<CR>
inoremap <C-c> <Esc>
" easy indent
vnoremap <silent>> >gv
vnoremap <silent>< <gv
" Symbols outline
nnoremap <silent><leader>sb :SymbolsOutline<CR>
" }}}

" Scratches mapping {{{
nnoremap <silent>\s <cmd>lua require('plugins/scratches').open_scratch_file_floating()<CR>
nnoremap <silent>\c <cmd>lua require('plugins/scratches').open_scratch_file_floating({filename="codesnip"})<CR>
nnoremap <silent>\m <cmd>lua require('plugins/scratches').open_scratch_file_floating({filename="vim"})<CR>
" }}}

" windows mapping {{{
nnoremap <silent><leader>h :wincmd h<Cr>
nnoremap <silent><leader>j :wincmd j<Cr>
nnoremap <silent><leader>k :wincmd k<Cr>
nnoremap <silent><leader>l :wincmd l<Cr>
nnoremap <silent><leader>= <C-w>=
nnoremap <silent>\v :vsplit<Cr>
nnoremap <silent>\h :split<Cr>
" }}}

" LSP {{{
nnoremap \L :LspStop<cr>
nnoremap \l :LspRestart<cr>
" }}}

" Git keymaps {{{
nnoremap \dv <cmd>DiffviewFileHistory %<cr>
nnoremap \dc <cmd>DiffviewClose<cr>
" }}}

" Buffers {{{
" Tab switch buffer
nnoremap <silent><TAB> :BufferLineCycleNext<CR>
nnoremap <silent><S-TAB> :BufferLineCyclePrev<CR>
nnoremap <silent><leader>dd :Bdelete<CR>
nnoremap <silent><leader>da <cmd>lua require('plugins/buffer-handle').close_all_buffers_except_current()<cr>
nnoremap <silent><leader>1 <Cmd>BufferLineGoToBuffer 1<CR>
nnoremap <silent><leader>2 <Cmd>BufferLineGoToBuffer 2<CR>
nnoremap <silent><leader>3 <Cmd>BufferLineGoToBuffer 3<CR>
nnoremap <silent><leader>4 <Cmd>BufferLineGoToBuffer 4<CR>
nnoremap <silent><leader>5 <Cmd>BufferLineGoToBuffer 5<CR>
nnoremap <silent><leader>6 <Cmd>BufferLineGoToBuffer 6<CR>
nnoremap <silent><leader>7 <Cmd>BufferLineGoToBuffer 7<CR>
" }}}

" Telescope mappings {{{
" nnoremap <silent><leader>fg <cmd>lua require('telescope.builtin').live_grep({ previewer=false, path_display = { "shorten" } })<cr>
nnoremap <silent><leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <silent><leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <silent><leader>b  <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <silent><leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
nnoremap <silent><leader>fs <cmd>lua require('telescope.builtin').grep_string()<cr>
nnoremap <silent><leader>fc <cmd>lua require('telescope.builtin').git_files()<cr>
" }}}

" NvimTree mappings {{{
nnoremap <silent><C-b> :NvimTreeToggle<CR>
nnoremap <silent><C-f> :NvimTreeFindFileToggle<CR>
nnoremap <silent><leader>r :NvimTreeRefresh<CR>
"}}}

" Trouble mappings {{{
" https://github.com/folke/trouble.nvim
nnoremap <leader>xx <cmd>TroubleToggle<cr>
nnoremap <leader>xw <cmd>TroubleToggle workspace_diagnostics<cr>
nnoremap <leader>xd <cmd>TroubleToggle document_diagnostics<cr>
nnoremap <leader>xq <cmd>TroubleToggle quickfix<cr>
nnoremap <leader>xl <cmd>TroubleToggle loclist<cr>
nnoremap gR <cmd>TroubleToggle lsp_references<cr>
"}}}

" Spectre mappings {{{
" https://github.com/nvim-pack/nvim-spectre
nnoremap <leader>S <cmd>lua require('spectre').open()<CR>
nnoremap <leader>sw <cmd>lua require('spectre').open_visual({select_word=true})<CR>
" vnoremap <leader>s <cmd>lua require('spectre').open_visual()<CR>
" search in current file
nnoremap <leader>sc <cmd>lua require('spectre').open_file_search()<cr>
"}}}

" Rest mappings {{{
nnoremap <silent>\rr <Plug>RestNvim
nnoremap <silent>\rp <Plug>RestNvimPreview
"}}}

" [dracula, nordic, tokyonight]
colorscheme tokyonight
" for tokyonight only, to support BufferLineFill
" https://github.com/akinsho/bufferline.nvim/issues/112
highlight BufferlineFill guibg=#24283b
