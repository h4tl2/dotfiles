syntax on
filetype plugin indent on
set nu


call plug#begin('~/.vim/plugged')
 Plug 'preservim/nerdtree'
 Plug 'vim-airline/vim-airline'
 Plug 'vim-airline/vim-airline-themes'
 Plug 'pangloss/vim-javascript'
 Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
call plug#end()

nnoremap <C-b> :NERDTreeToggle<CR>

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
