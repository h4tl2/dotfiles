local treesitter = require('nvim-treesitter.configs')

treesitter.setup {
    ensure_installed = {
        "bash",
        "rust",
        "go",
        "tsx",
        "toml",
        "json",
        "yaml",
        "html",
        "css",
        "dockerfile",
        "javascript",
        "typescript",
        "python",
    },
    highlight = {
        enable = true
    },
    sync_install = false,
}

-- local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
-- parser_config.tsx.used_by = { "javascript", "typescript.tsx" }
