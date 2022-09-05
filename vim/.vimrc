syntax on
filetype plugin indent on
set nu

" General colors
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

set clipboard=unnamed
if &term == "alacritty"
	set term=xterm-256color
endif

call plug#begin('~/.vim/plugged')
 Plug 'preservim/nerdtree'
 Plug 'vim-airline/vim-airline'
 Plug 'vim-airline/vim-airline-themes'
 Plug 'pangloss/vim-javascript'
 Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
call plug#end()

nnoremap <C-b> :NERDTreeToggle<CR>
let g:airline_theme='minimalist'
" vim-go configuration
let g:go_doc_popup_window = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_operators = 1
let g:go_fmt_command = "goimports"
let g:go_auto_type_info = 1
let g:go_fmt_autosave = 1
" Navigation commands
au FileType go nmap <Leader>ds <Plug>(go-def-split)
au FileType go nmap <Leader>dv <Plug>(go-def-vertical)
" Alternate commands
au FileType go nmap <Leader>ae <Plug>(go-alternate-edit)
au FileType go nmap <Leader>av <Plug>(go-alternate-vertical)
" Common Go commands
au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>t <Plug>(go-test)
au FileType go nmap <leader>c <Plug>(go-coverage-toggle)
au FileType go nmap <Leader>e <Plug>(go-rename)
au FileType go nmap <Leader>s <Plug>(go-implements)
au FileType go nmap <Leader>i <Plug>(go-info)
au Filetype go inoremap <buffer> . .<C-x><C-o>

autocmd CompleteDone * pclose
autocmd BufWritePre *.go %s/\s\+$//e
