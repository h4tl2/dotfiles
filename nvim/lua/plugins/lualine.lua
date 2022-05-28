-- Using external source for git diff
-- local function diff_source()
--     local gitsigns = vim.b.gitsigns_status_dict
--     if gitsigns then
--         return {
--             added = gitsigns.added,
--             modified = gitsigns.changed,
--             removed = gitsigns.removed
--         }
--     end
-- end

require('lualine').setup {
    options = {
        disabled_filetypes = { 'NvimTree' },
        global_status = true
    },
    sections = {
        lualine_c = {
            {
                'filename',
                path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
            }
        }
        -- lualine_b = { { 'diff', source = diff_source }, },
    }
}
