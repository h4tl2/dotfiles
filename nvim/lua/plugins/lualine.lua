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

-- local custom_theme = require 'lualine.themes.auto'
-- custom_theme.normal.b.fg = "#c0caf5"
-- custom_theme.normal.b.bg = "#24283b"
-- custom_theme.normal.c.fg = "#c0caf5"
-- custom_theme.normal.c.bg = "#24283b"
-- guifg=#c0caf5 guibg=#24283b from tokyonight
require('lualine').setup {
    options = {
        -- disabled_filetypes = { 'NvimTree', 'TelescopePrompt' },
        -- theme = 'tokyonight',
        -- theme = custom_theme,
        global_status = true,
        component_separators = '|',
        section_separators = { left = '', right = '' },
    },
    sections = {
        -- lualine_b = { { 'diff', source = diff_source }, },
        lualine_b = { { 'branch', icon = { '' }, color = { fg = '#c0caf5' } }, 'diff', 'diagnostics' },
        lualine_c = {
            {
                'filename',
                path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
                color = { fg = '#c0caf5' }
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
