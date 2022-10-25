local treesitter = require('nvim-treesitter.configs')

treesitter.setup {
    ensure_installed = {
        "bash",
        "rust",
        "go",
        "gomod",
        "gowork",
        "graphql",
        -- "lua",
        -- "markdown",
        "make",
        "vim",
        "tsx",
        "toml",
        "http",
        -- "json",
        -- "jsonc",
        "jsdoc",
        "hcl",
        "yaml",
        "html",
        "css",
        "dockerfile",
        "javascript",
        "typescript",
        "python",
    },
    highlight = {
        enable = true,
        -- https://github.com/nvim-treesitter/nvim-treesitter/blob/16c773c0f826785760dce92bf713fb7e8e19e70c/doc/nvim-treesitter.txt#L108
        ---@diagnostic disable-next-line: unused-local
        disable = function(lang, bufnr)
            -- return lang == "json" and vim.api.nvim_buf_line_count(bufnr) > 50000
            return vim.api.nvim_buf_line_count(bufnr) > 10000
        end,
    },
    sync_install = false,
}

-- local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
-- parser_config.tsx.used_by = { "javascript", "typescript.tsx" }
