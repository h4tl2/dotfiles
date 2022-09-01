-- Plug 'shaunsingh/nord.nvim'
-- Example config in lua
-- vim.g.nord_contrast = true
-- vim.g.nord_borders = false
-- vim.g.nord_disable_background = false
-- vim.g.nord_italic = false vim.g.nord_cursorline_transparent = false Load the colorscheme
-- require('nord').set()

-- nordic
-- vim.g.nord_underline_option = 'none'
-- vim.g.nord_italic = false
-- vim.g.nord_italic_comments = false
-- vim.g.nord_minimal_mode = true -- Minimal mode: different choice of colors for Tabs and StatusLine
-- vim.g.nord_alternate_backgrounds = false

-- tokyonight
-- setup when first startup
vim.g.tokyonight_italic_comments = false
vim.g.tokyonight_italic_keywords = false
vim.g.tokyonight_dark_sidebar = false
vim.g.tokyonight_colors = {
    border = "dark5",
    fg = "#e0e6ffl",
    gitSigns = { add = "#309c98", change = "#778fbb" }
}

-- local M = {}
--
-- M.set_background = function(bg)
--     vim.cmd([[colorscheme tokyonight]])
--     vim.api.nvim_command("set bg=" .. bg)
-- end
--
-- M.set_tokyonight = function()
--     local config = require("tokyonight.config")
--     local c = require("tokyonight.colors").setup(config)
--     local util = require("tokyonight.util")
--     local cmd = vim.cmd
--     -- for tokyonight only, to support BufferLineFill
--     -- https://github.com/akinsho/bufferline.nvim/issues/112
--     -- highlight BufferlineFill guibg=#24283b
--     util.highlight("BufferlineFill", { bg = c.bg, })
--     -- replace undercurl w/ underline
--     -- util.highlight("DiagnosticUnderlineError", { style = "underline", sp = c.error })
--     -- util.highlight("DiagnosticUnderlineWarn", { style = "underline", sp = c.warn })
--     -- util.highlight("DiagnosticUnderlineInfo", { style = "underline", sp = c.info })
--     -- util.highlight("DiagnosticUnderlineHint", { style = "underline", sp = c.hint })
--     -- extra hl for yasl
--     cmd("hi StatusLineAccent guifg=" .. c.black .. " guibg=" .. c.blue5)
--     cmd("hi StatusLineInsertAccent guifg=" .. c.black .. " guibg=" .. c.green)
--     cmd("hi StatusLineVisualAccent guifg=" .. c.black .. " guibg=" .. c.magenta)
--     cmd("hi StatusLineReplaceAccent guifg=" .. c.black .. " guibg=" .. c.red)
--     cmd("hi StatusLineCmdLineAccent guifg=" .. c.black .. " guibg=" .. c.yellow)
--     cmd("hi StatuslineTerminalAccent guifg=" .. c.black .. " guibg=" .. c.yellow)
--     cmd("hi StatusLineExtra guifg=" .. c.fg)
--     -- cursorline as underline
--     cmd("hi CursorLine gui=underline cterm=underline")
-- end
--
-- Theme = setmetatable(M, {
--     __call = function(self, mode)
--         return self["set_" .. mode](self)
--     end,
-- })
--
-- vim.cmd([[autocmd ColorScheme tokyonight lua Theme.set_tokyonight()]])
--
-- return M
-- local time = os.date("*t")
-- if time.hour < 8 or time.hour > 19 then
--     vim.g.tokyonight_style="night"
--     vim.cmd([[colorscheme tokyonight]])
-- else
--     vim.cmd([[colorscheme gruvbox]])
-- end
