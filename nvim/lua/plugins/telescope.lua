local telescope = require('telescope')
local actions = require("telescope.actions")
telescope.setup {
    defaults = {
        mappings = {
            i = {
                ["<esc>"] = actions.close
            },
        },
        file_ignore_patterns = { ".git/", "^node_modules/", "^vendor/" },
        vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '-u',
            '--hidden',
            "--glob=!.git/",
        },
        path_display = { 'smart' },
    },
    pickers = {
        find_files = { hidden = true },
    },
}

-- To get fzf loaded and working with telescope,
-- you need to call load_extension, somewhere after
-- the setup function.
telescope.load_extension('fzf')
