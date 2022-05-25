require("bufferline").setup {
    options = {
        numbers = "ordinal",
        diagnostics = "nvim_lsp",
        offsets = {
            {
                filetype = "NvimTree",
                text = "File Explorer",
                text_align = "center"
            }
        },
    }
}
