-- must be set before calling require
vim.g.nvim_tree_indent_markers = 1 -- this option shows indent markers when folders are open

require('nvim-tree').setup {
    view = {
        auto_resize = true,
    }
}

vim.api.nvim_set_keymap('n', '<Leader>b', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
