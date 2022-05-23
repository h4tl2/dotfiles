local telescope = require('telescope')
local actions = require("telescope.actions")

telescope.setup {
    defaults = {
        mappings = {
            i = {
                ["<esc>"] = actions.close
            },
        },
        file_ignore_patterns = { "node_modules", ".git" },
    },
    pickers = {
        find_files = { hidden = true },
        live_grep = { additional_args = function(opts) return { "--hidden" } end }
    },
}

-- To get fzf loaded and working with telescope,
-- you need to call load_extension, somewhere after
-- the setup function.
telescope.load_extension('fzf')
