---@diagnostic disable: undefined-doc-name
-- tokyonight
-- ENABLE_TRANSPARENT
require("tokyonight").setup({
    -- your configuration comes here
    -- or leave it empty to use the default settings
    style = "storm", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
    light_style = "day", -- The theme is used when the background is set to light
    transparent = false, -- Enable this to disable setting the background color
    terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
    styles = {
        -- Style to be applied to different syntax groups
        -- Value is any valid attr-list value for `:help nvim_set_hl`
        comments = { italic = false },
        keywords = { italic = false },
        functions = {},
        variables = {},
        -- Background styles. Can be "dark", "transparent" or "normal"
        sidebars = "transparent", -- style for sidebars, see below
        floats = "dark", -- style for floating windows
    },
    sidebars = { "qf", "help", "NvimTree" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
    day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
    hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
    dim_inactive = false, -- dims inactive windows
    lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold

    --- You can override specific color groups to use other groups or a hex color
    --- function will be called with a ColorScheme table
    ---@param colors ColorScheme
    on_colors = function(colors)
        ---@diagnostic disable-next-line: undefined-field
        colors.border = colors.dark5
        colors.fg = "#e0e6ff"
        colors.comment = "#c0caf5"
        colors.gitSigns = { add = "#309c98", change = "#778fbb" }
    end,

    --- You can override specific highlights to use other groups or a hex color
    --- function will be called with a Highlights and ColorScheme table
    ---@param highlights Highlights
    ---@param colors ColorScheme
    on_highlights = function(highlights, colors) end,
})

local M = {}

M.set_background = function(bg)
    vim.cmd([[colorscheme tokyonight]])
    vim.api.nvim_command("set bg=" .. bg)
end

M.set_tokyonight = function()
    local config = require("tokyonight.config")
    local c = require("tokyonight.colors").setup(config)
    local util = require("tokyonight.util")
    local cmd = vim.cmd
    -- for tokyonight only, to support BufferLineFill
    -- https://github.com/akinsho/bufferline.nvim/issues/112
    -- highlight BufferlineFill guibg=#24283b
    util.highlight("BufferlineFill", { bg = "NONE", }) -- ENABLE_TRANSPARENT
    -- util.highlight("BufferlineFill", { bg = c.bg, })
    -- replace undercurl w/ underline
    util.highlight("DiagnosticUnderlineError", { style = "underline", sp = c.error })
    util.highlight("DiagnosticUnderlineWarn", { style = "underline", sp = c.warning })
    util.highlight("DiagnosticUnderlineInfo", { style = "underline", sp = c.info })
    util.highlight("DiagnosticUnderlineHint", { style = "underline", sp = c.hint })
    util.highlight("CursorLineNr", { fg = "#e9ecfc" })
    util.highlight("LineNr", { fg = "#7b8fea" })

    -- clear nvimtree highlight
    cmd("hi clear NvimTreeFolderIcon")
    -- extra hl for yasl
    -- cmd("hi StatusLineAccent guifg=" .. c.black .. " guibg=" .. c.blue5)
    -- cmd("hi StatusLineInsertAccent guifg=" .. c.black .. " guibg=" .. c.green)
    -- cmd("hi StatusLineVisualAccent guifg=" .. c.black .. " guibg=" .. c.magenta)
    -- cmd("hi StatusLineReplaceAccent guifg=" .. c.black .. " guibg=" .. c.red)
    -- cmd("hi StatusLineCmdLineAccent guifg=" .. c.black .. " guibg=" .. c.yellow)
    -- cmd("hi StatuslineTerminalAccent guifg=" .. c.black .. " guibg=" .. c.yellow)
    -- cmd("hi StatusLineExtra guifg=" .. c.fg)

    -- cursorline as underline
    cmd("hi CursorLine gui=underline cterm=underline")
end

vim.api.nvim_create_user_command("SetTokyonight", M.set_tokyonight, {})
vim.cmd([[autocmd ColorScheme tokyonight SetTokyonight]])
-- return M

-- local time = os.date("*t")
-- if time.hour < 8 or time.hour > 19 then
--     vim.g.tokyonight_style="night"
--     vim.cmd([[colorscheme tokyonight]])
-- else
--     vim.cmd([[colorscheme gruvbox]])
-- end
