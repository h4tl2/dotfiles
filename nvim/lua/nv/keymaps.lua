vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
-- Remap for dealing with word wrap
-- vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
-- vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Telescope mappings
vim.keymap.set('n', '<leader>fc', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>fs', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<C-b>', require('telescope.builtin').buffers, { desc = '[B]uffers' })

vim.cmd([[ 
nmap ,P "0P
nmap ,p "0p
" still got no time to study macros
nnoremap q <nop>
nnoremap <silent><ESC> :nohlsearch<Bar>:echo<Cr>
" vim edit configuration
nnoremap <S-Up> :m-2<CR>
nnoremap <S-Down> :m+<CR>
inoremap <S-Up> <Esc>:m-2<CR>
inoremap <S-Down> <Esc>:m+<CR>
inoremap <C-c> <Esc>
nnoremap <leader>yp :let @+ = expand("%")<CR>
" easy indent
vnoremap <silent>> >gv
vnoremap <silent>< <gv
" windows mapping
nnoremap <silent><leader>h :wincmd h<Cr>
nnoremap <silent><leader>j :wincmd j<Cr>
nnoremap <silent><leader>k :wincmd k<Cr>
nnoremap <silent><leader>l :wincmd l<Cr>
nnoremap <silent><leader>= <C-w>=
nnoremap <silent>\v :vsplit<Cr>
nnoremap <silent>\h :split<Cr>
" LSP
nnoremap \L :LspStop<cr>
nnoremap \l :LspRestart<cr>
" NvimTree
nnoremap <silent><C-f> :NvimTreeFindFileToggle<CR>
nnoremap <silent><leader>r :NvimTreeRefresh<CR>
]])
