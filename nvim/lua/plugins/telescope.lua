local telescope = require('telescope')
local actions = require("telescope.actions")

telescope.setup {
    defaults = {
        preview = {
            treesitter = false,
        },
        mappings = {
            i = {
                ["<esc>"] = actions.close
            },
        },
        file_ignore_patterns = { ".git/", "^node_modules/", "^vendor/", "*%.min%.*" },
        vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--trim',
            '-u',
            '--hidden',
            "--glob=!.git/",
        },
        path_display = { "truncate" }, -- using smart here will impact performance
        prompt_prefix = "😼 ",
        results_title = "🐱",
    },
    pickers = {
        find_files = {
            hidden = true,
            find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
            -- find_command = {'rg', '--files', '--hidden', '-g', '!.git'},
        },
        live_grep = {
            theme = "dropdown",
            previewer = false,
            path_display = { shorten = 1 },
        },
        grep_string = {
            theme = "dropdown",
            previewer = false,
            path_display = { shorten = 1 },
        },
        buffers = {
            theme = "dropdown",
            previewer = false,
            initial_mode = "normal",
            show_all_buffers = true,
            sort_lastused = true,
            mappings = {
                i = {
                    ["<c-d>"] = actions.delete_buffer,
                },
                n = {
                    ["<c-d>"] = actions.delete_buffer,
                }
            }
        },
    },
    extensions = {
        fzf = {
            override_generic_sorter = true,
            override_file_sorter = true,
        },
        ["ui-select"] = {
            require("telescope.themes").get_dropdown {}
        }
    },
}

-- To get fzf loaded and working with telescope,
-- you need to call load_extension, somewhere after
-- the setup function.
telescope.load_extension('fzf')
telescope.load_extension('ui-select')
-- telescope.load_extension('project')
