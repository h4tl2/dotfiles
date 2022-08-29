require('nvim-tree').setup {
    -- view = {
    --     width = 30,
    --     height = 30,
    --     side = "right",
    -- },
    -- update_focused_file = {
    --     enable = true,
    --     update_cwd = true,
    -- },
    auto_reload_on_write = true,
    renderer = {
        indent_markers = {
            enable = true
        }
    },
    filters = {
        dotfiles = false,
        custom = { "^.git$", ".DS_Store" },
        exclude = { ".env", ".debug" }
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
