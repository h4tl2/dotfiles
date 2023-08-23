return {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        require("nvim-tree").setup {
            view = { adaptive_size = true },
            update_focused_file = {
                enable = true,
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
            git = {
                enable = false,
            },
        }
    end,
}
