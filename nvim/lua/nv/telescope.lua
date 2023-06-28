local _, telescope = pcall(require, "telescope")
local actions = require("telescope.actions")
local previewers = require("telescope.previewers")

local Job = require "plenary.job"

-- Put all filetypes that slow you down in this array
local _bad = { '.*%.json', '.*%.mod', '.*%.sum' }

local bad_files = function(filepath)
    for _, v in ipairs(_bad) do
        if filepath:match(v) then
            return false
        end
    end

    return true
end
--
-- https://github.com/nvim-telescope/telescope.nvim/issues/269#issuecomment-789704019
local preview_maker = function(filepath, bufnr, opts)
    -- turn off highlight for bad_files
    opts = opts or {}
    if opts.use_ft_detect == nil then opts.use_ft_detect = true end
    opts.use_ft_detect = opts.use_ft_detect == false and false or bad_files(filepath)

    -- ignore binary file and file with a size bigger than 300kb
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
                        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "BINARY FILE, PICTURE OR ELSE" })
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
        layout_config = {
            -- height = 0.95,
            width = 0.85,
            -- prompt_position = 'top',
        },
        buffer_previewer_maker = preview_maker,
        mappings = {
            i = {
                ["<esc>"] = actions.close
            },
        },
        file_ignore_patterns = { ".git/", "^node_modules/", "^vendor/", "*%.min%.*", "*.svg", "^target/", "*-lock.json" },
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
            -- find_command = { "fd", "--no-ignore", "-E", ".DS_Store", "-E", ".git", "--type", "f", "--strip-cwd-prefix" },
            -- find_command = { 'rg', '--files', '--hidden', '-g', '!.git' },
        },
        live_grep = {
            -- theme = "dropdown",
            previewer = false,
            path_display = { shorten = 1 },
            debounce = 500,
        },
        buffers = {
            theme = "dropdown",
            previewer = false,
            initial_mode = "insert",
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
        lsp_references = {
            -- layout_strategy = 'vertical',
            -- previewer = true,
            layout_config = { width = 0.98, height = 0.95, preview_width = 0.4 }
        },
    },
    extensions = {
        fzf = {
            override_generic_sorter = true,
            override_file_sorter = true,
        },
    },
}

telescope.load_extension('fzf')
