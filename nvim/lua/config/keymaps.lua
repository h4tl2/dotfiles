local git_utils = require 'custom.git'

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

-- TODO: Telescope mappings (migrate to fzf-lua)
vim.keymap.set('n', '<leader>df', git_utils.fzf_diff_file, { desc = 'Diff file with current buffer' })
vim.keymap.set('n', '<leader>dg', git_utils.fzf_diff_from_history, { desc = 'Diff from git history' })


-- Main find commands
vim.keymap.set('n', '<leader>fc', '<cmd>FzfLua git_files<cr>', { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>ff', '<cmd>FzfLua files<cr>', { desc = '[F]ind [F]iles' })
vim.keymap.set('n', '<leader>fh', '<cmd>FzfLua help_tags<cr>', { desc = '[F]ind [H]elp' })
vim.keymap.set('n', '<leader>fg', '<cmd>FzfLua live_grep<cr>', { desc = '[F]ind by [G]rep' })
vim.keymap.set('n', '<leader>?', '<cmd>FzfLua oldfiles<cr>', { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<C-b>', '<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>', { desc = '[B]uffers' })

-- Git commands
vim.keymap.set('n', '<leader>gs', '<cmd>FzfLua git_status<cr>', { desc = '[G]it [S]tatus' })
vim.keymap.set('n', '<leader>gc', '<cmd>FzfLua git_commits<CR>', { desc = 'Commits' })

-- Search commands
vim.keymap.set('n', '<leader>sa', '<cmd>FzfLua autocmds<cr>', { desc = 'Auto Commands' })
vim.keymap.set('n', '<leader>sb', '<cmd>FzfLua grep_curbuf<cr>', { desc = 'Buffer' })
vim.keymap.set('n', '<leader>sc', '<cmd>FzfLua command_history<cr>', { desc = 'Command History' })

-- LSP symbols
vim.keymap.set('n', '<leader>fs', function() require('fzf-lua').lsp_document_symbols {} end, { desc = 'Goto Symbol' })
vim.keymap.set('n', '<leader>ws', function() require('fzf-lua').lsp_live_workspace_symbols {} end,
  { desc = 'Goto Symbol (Workspace)' })

-- Miscellaneous
vim.keymap.set('n', '<leader>sk', '<cmd>FzfLua keymaps<cr>', { desc = 'Key Maps' })
vim.keymap.set('n', '<leader>uC', '<cmd>FzfLua colorschemes<cr>', { desc = 'Colorscheme with Preview' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
vim.keymap.set('n', '<leader>dd', '<cmd>FzfLua diagnostics_document<cr>', { desc = 'Document Diagnostics' })
vim.keymap.set('n', '<leader>wd', '<cmd>FzfLua diagnostics_workspace<cr>', { desc = 'Workspace Diagnostics' })

-- navigate windows
-- vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
-- vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
-- vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
-- vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
vim.keymap.set('n', '<leader>gtg', function()
  local url = git_utils.get_line_on_remote()
  vim.fn.setreg('+', url)

  vim.notify('Copied to clipboard\n' .. url, vim.log.levels.INFO, { title = 'Git URL' })
end, { desc = 'Copy Git File Path URL' })
-- easier way to deal with register when yank text
vim.cmd [[
nmap ,P "0P
nmap ,p "0p
" nnoremap q <nop>
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
