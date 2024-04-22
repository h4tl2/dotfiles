-- modifier (CMD on mac, CTRL on other)
local withModifier = function(key)
  local mod = vim.fn.has 'mac' == 1 and 'D' or 'C'
  return '<' .. mod .. '-' .. key .. '>'
end
vim.keymap.set('n', withModifier 's', ':write <CR>', { desc = 'Save buffer', remap = true })
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
-- Remap for dealing with word wrap
-- vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
-- vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Telescope mappings
vim.keymap.set('n', '<leader>fc', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, { desc = '[F]ind [F]iles' })
vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = '[F]ind [H]elp' })
vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, { desc = '[F]ind by [G]rep' })
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader>gs', require('telescope.builtin').git_status, { desc = '[?] Git status' })
vim.keymap.set('n', '<C-b>', require('telescope.builtin').buffers, { desc = '[B]uffers' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- navigate windows
-- vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
-- vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
-- vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
-- vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- easier way to deal with register when yank text
vim.cmd [[
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
nnoremap <C-c><C-c> :qa<CR>
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

" Netrw
" nnoremap <silent><C-f> :Explore<CR>
" nnoremap <silent><leader>r :Vexplore<CR>
" Buffers
" nnoremap <silent><TAB> :BufferLineCycleNext<CR>
" nnoremap <silent><S-TAB> :BufferLineCyclePrev<CR>
nnoremap <silent><leader>dd :Bdelete this<CR>
nnoremap <silent><leader>da :Bdelete other<CR>

nnoremap <silent><leader>1 <Cmd>BufferLineGoToBuffer 1<CR>
nnoremap <silent><leader>2 <Cmd>BufferLineGoToBuffer 2<CR>
nnoremap <silent><leader>3 <Cmd>BufferLineGoToBuffer 3<CR>
nnoremap <silent><leader>4 <Cmd>BufferLineGoToBuffer 4<CR>
nnoremap <silent><leader>5 <Cmd>BufferLineGoToBuffer 5<CR>
nnoremap <silent><leader>6 <Cmd>BufferLineGoToBuffer 6<CR>
nnoremap <silent><leader>7 <Cmd>BufferLineGoToBuffer 7<CR>
" Trouble
nnoremap <leader>tt <cmd>TroubleToggle<cr>
nnoremap <leader>tw <cmd>TroubleToggle workspace_diagnostics<cr>
nnoremap <leader>td <cmd>TroubleToggle document_diagnostics<cr>
nnoremap <leader>tq <cmd>TroubleToggle quickfix<cr>
nnoremap <leader>tl <cmd>TroubleToggle loclist<cr>
nnoremap gR <cmd>TroubleToggle lsp_references<cr>
" Spectre
nnoremap <leader>S <cmd>lua require('spectre').open()<CR>
nnoremap <leader>sw <cmd>lua require('spectre').open_visual({select_word=true})<CR>
nnoremap <leader>sc <cmd>lua require('spectre').open_file_search()<cr>
" Git
nnoremap \dv <cmd>DiffviewOpen<cr>
nnoremap \dc <cmd>DiffviewClose<cr>
nnoremap \df <cmd>DiffviewFileHistory %<cr>
nnoremap \gb <cmd>Gitsigns blame_line<cr>
nnoremap \gp <cmd>Gitsigns preview_hunk<cr>
nnoremap \gr <cmd>Gitsigns reset_hunk<cr>
" Scratches
nnoremap <silent>\s <cmd>lua require('nv/scratches').open_scratch_file_floating()<CR>
nnoremap <silent>\c <cmd>lua require('nv/scratches').open_scratch_file_floating({filename="codesnip"})<CR>
nnoremap <silent>\m <cmd>lua require('nv/scratches').open_scratch_file_floating({filename="vim"})<CR>
]]
