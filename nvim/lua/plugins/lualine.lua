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
        -- disabled_filetypes = { 'NvimTree', 'TelescopePrompt' },
        global_status = true,
        component_separators = '|',
        section_separators = { left = '', right = '' },
    },
    sections = {
        -- lualine_b = { { 'diff', source = diff_source }, },
        lualine_c = {
            {
                'filename',
                path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
            }
        },
        lualine_x = {},
        lualine_y = { 'filetype' },
        lualine_z = { 'location' },
    },
    -- tabline = {
    --     lualine_a = {
    --         {
    --             "buffers",
    --             separator = { left = "", right = "" },
    --             symbols = { alternate_file = "" },
    --         },
    --     },
    -- },
}
