require('nvim-treesitter.configs').setup {
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
  },
}
