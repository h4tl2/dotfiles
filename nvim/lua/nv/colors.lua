--  for poimandres
-- vim.cmd [[autocmd! ColorScheme poimandres highlight CursorLine guibg=#3B4252]]

-- for envy
vim.cmd [[autocmd! ColorScheme envy highlight DiagnosticInfo ctermfg=4 guifg=SkyBlue3]]
vim.cmd [[autocmd! ColorScheme envy highlight DiagnosticHint ctermfg=7 guifg=DarkBlue]]

-- for tokyonight
-- vim.cmd [[autocmd! ColorScheme tokyonight highlight BufferlineFill guibg=#24283b]]
-- vim.cmd [[autocmd! ColorScheme tokyonight highlight CursorLine gui=underline cterm=underline]]
-- vim.cmd [[autocmd! ColorScheme tokyonight highlight clear NvimTreeFolderIcon]]

-- for rasmus
vim.g.rasmus_bold_keywords = true
vim.g.rasmus_italic_comments = false

local function theme_cycler()
    local state = 0
    local themes = {
        "envy",
        "rasmus",
    }
    return function()
        state = (state + 1) % #themes
        local theme = themes[state + 1]
        vim.cmd.colorscheme(theme)
        print(theme)
    end
end

vim.keymap.set("n", "<C-x>", theme_cycler())
