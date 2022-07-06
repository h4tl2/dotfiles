local colors = require("dracula").colors()

require("scrollbar").setup({
    handle = {
        color = colors.gutter_fg,
    },
    marks = {
        Search = { color = colors.orange },
        Error = { color = colors.bright_red },
        Warn = { color = colors.orange },
        Info = { color = colors.bright_yellow },
        Hint = { color = colors.yellow },
        Misc = { color = colors.purple },
    }
})
