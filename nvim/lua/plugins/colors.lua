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

local M = {}

M.set_background = function(bg)
    vim.cmd([[colorscheme tokyonight]])
    vim.api.nvim_command("set bg=" .. bg)
    if bg == "dark" then
        vim.cmd("hi BufferlineFill guibg=#24283b)")
    end
end

return M

-- local time = os.date("*t")
-- if time.hour < 8 or time.hour > 19 then
--     vim.g.tokyonight_style="night"
--     vim.cmd([[colorscheme tokyonight]])
-- else
--     vim.cmd([[colorscheme gruvbox]])
-- end
