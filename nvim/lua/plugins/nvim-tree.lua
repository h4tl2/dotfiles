require('nvim-tree').setup {
    auto_reload_on_write = true,
    renderer = {
        indent_markers = {
            enable = true
        }
    },
    filters = {
        dotfiles = false,
        custom = { "^.git$" },
    },
    diagnostics = {
        enable = false,
        show_on_dirs = false,
        icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
        },
    },
}
