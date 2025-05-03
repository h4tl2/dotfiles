return {
  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
    event = { "VeryLazy" },
    lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
    init = function(plugin)
      -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
      -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
      -- no longer trigger the **nvim-treesitter** module to be loaded in time.
      -- Luckily, the only things that those plugins need are the custom queries, which we make available
      -- during startup.
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
    end,
    opts = {
      ensure_installed = {
        'bash',
        'rust',
        'go',
        'gomod',
        'gowork',
        'graphql',
        'lua',
        -- "markdown",
        'make',
        'vim',
        'tsx',
        'toml',
        'http',
        'json',
        -- "jsonc",
        'jsdoc',
        'hcl',
        'yaml',
        'html',
        'css',
        'dockerfile',
        'javascript',
        'typescript',
        'python',
        'sql',
      },
      auto_install = false,
      highlight = {
        enable = true,
        -- https://github.com/nvim-treesitter/nvim-treesitter/blob/16c773c0f826785760dce92bf713fb7e8e19e70c/doc/nvim-treesitter.txt#L108
        ---@diagnostic disable-next-line: unused-local
        disable = function(lang, bufnr)
          -- return lang == "json" and vim.api.nvim_buf_line_count(bufnr) > 50000
          return vim.api.nvim_buf_line_count(bufnr) > 10000
        end,
      },
      indent = { enable = true, disable = { 'python' } },
      sync_install = false,
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ['aa'] = '@parameter.outer',
            ['ia'] = '@parameter.inner',
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            [']m'] = '@function.outer',
            [']]'] = '@class.outer',
          },
          goto_next_end = {
            [']M'] = '@function.outer',
            [']['] = '@class.outer',
          },
          goto_previous_start = {
            ['[m'] = '@function.outer',
            ['[['] = '@class.outer',
          },
          goto_previous_end = {
            ['[M'] = '@function.outer',
            ['[]'] = '@class.outer',
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ['<leader>a'] = '@parameter.inner',
          },
          swap_previous = {
            ['<leader>A'] = '@parameter.inner',
          },
        },
      }
    }
  }
}
