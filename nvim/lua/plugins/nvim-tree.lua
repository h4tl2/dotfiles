require('nvim-tree').setup {
    -- view = {
    --     width = 30,
    --     height = 30,
    --     side = "right",
    -- },
    -- view = {
    --     float = {
    --         enable = true,
    --     },
    --     open_win_config = {
    --         relative = "editor",
    --         border = "rounded",
    --         width = 100,
    --     height = 30,
    --     row = 5,
    --     col = 5,
    --     },
    -- },
    update_focused_file = {
        enable = false,
    },
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
