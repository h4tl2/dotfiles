local telescope = require('telescope')
local actions = require("telescope.actions")
local previewers = require("telescope.previewers")

local Job = require "plenary.job"

-- ignore binary file and file with a size bigger than 300kb
local preview_maker = function(filepath, bufnr, opts)
    filepath = vim.fn.expand(filepath)
    Job
        :new({
            command = "file",
            args = { "--mime-type", "-b", filepath },
            on_exit = function(j)
                local mime_type = vim.split(j:result()[1], "/")[1]

                if mime_type == "text" then
                    -- Check file size
                    vim.loop.fs_stat(filepath, function(_, stat)
                        if not stat then
                            return
                        end
                        if stat.size > 300000 then
                            return
                        else
                            previewers.buffer_previewer_maker(filepath, bufnr, opts)
                        end
                    end)
                else
                    vim.schedule(function()
                        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "BINARY FILE" })
                    end)
                end
            end,
        })
        :sync()
end

telescope.setup {
    defaults = {
        preview = {
            treesitter = false,
        },
        buffer_previewer_maker = preview_maker,
        mappings = {
            i = {
                ["<esc>"] = actions.close
            },
        },
        file_ignore_patterns = { ".git/", "^node_modules/", "^vendor/", "*%.min%.*", "*.svg" },
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
            find_command = { "fd", "--no-ignore", "-E", ".DS_Store", "-E", ".git", "--type", "f", "--strip-cwd-prefix" },
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
