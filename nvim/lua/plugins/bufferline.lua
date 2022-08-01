require("bufferline").setup {
    options = {
        numbers = "none",
        diagnostics = "nvim_lsp",
        tab_size = 10,
        separator_style = { '', '' },
        ---@diagnostic disable-next-line: unused-local
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
            local icon = level:match("error") and " " or " "
            return "" .. icon .. count
        end,
        always_show_bufferline = true,
        show_buffer_close_icons = false,
        right_mouse_command = function(bufnum)
            require('bufdelete').bufdelete(bufnum, true)
        end
        -- offsets = {
        --     {
        --         filetype = "NvimTree",
        --         text = "File Explorer",
        --         text_align = "center"
        --     }
        -- },
    }
}
