return {
  {
    -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        local disable_filetypes = { c = true, cpp = true }
        return {
          timeout_ms = 500,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
      default_format_opts = {
        lsp_format = 'fallback',
      },
      formatters_by_ft = {
        lua = { 'stylua' },
        javascript = { 'prettierd', 'prettier', 'eslint', stop_after_first = true },
        typescript = { 'prettierd', 'prettier', 'eslint', stop_after_first = true },
      },
    },
  },
  {
    'windwp/nvim-autopairs',
    lazy = true,
    config = function()
      require('nvim-autopairs').setup({ check_ts = true }, { disable_filetype = { 'TelescopePrompt', 'vim' } })
      local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
      local cmp_status_ok, cmp = pcall(require, 'cmp')
      if not cmp_status_ok then
        return
      end
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done { map_char = { tex = '' } })
    end,
  },
  {
    'nvim-pack/nvim-spectre',
    lazy = true,
    config = function()
      require('spectre').setup {
        mapping = {
          ['run_replace'] = {
            map = '<leader>ra',
            cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
            desc = 'replace all',
          },
        },
      }
    end,
  },
  {
    'cappyzawa/trim.nvim',
    opts = {
      ft_blocklist = { 'markdown' },
    },
  },
  {
    'kylechui/nvim-surround',
    version = '*', -- Use for stability; omit to use `main` branch for the latest features
    event = 'VeryLazy',
    config = function()
      require('nvim-surround').setup {
        -- Configuration here, or leave empty to use defaults
      }
    end,
  },
  {
    'folke/trouble.nvim',
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = 'Trouble',
    keys = {
      {
        '<leader>tt',
        '<cmd>Trouble diagnostics toggle<cr>',
        desc = 'Diagnostics (Trouble)',
      },
      {
        '<leader>tl',
        '<cmd>Trouble loclist toggle<cr>',
        desc = 'Location List (Trouble)',
      },
      {
        '<leader>tq',
        '<cmd>Trouble qflist toggle<cr>',
        desc = 'Quickfix List (Trouble)',
      },
    },
  },
  {
    'numToStr/Comment.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
        'JoosepAlviste/nvim-ts-context-commentstring',
    },
    config = function()
    local comment = require 'Comment'

    local ts_context_commentstring = require 'ts_context_commentstring.integrations.comment_nvim'

    comment.setup {
        -- for commenting tsx, jsx, svelte, html files
        pre_hook = ts_context_commentstring.create_pre_hook(),
    }
    end,
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require('ibl').setup {}
    end,
  },
  { 'tpope/vim-sleuth' },
  -- git 
  {
    -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
    config = function()
      require('gitsigns').setup {
        on_attach = function(bufnr)
          local gitsigns = require 'gitsigns'

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end
          -- Navigation
          map('n', ']c', function()
            if vim.wo.diff then
              vim.cmd.normal { ']c', bang = true }
            else
              gitsigns.nav_hunk 'next'
            end
          end)

          map('n', '[c', function()
            if vim.wo.diff then
              vim.cmd.normal { '[c', bang = true }
            else
              gitsigns.nav_hunk 'prev'
            end
          end)
        end,
      }
    end,
  },
  {
    'sindrets/diffview.nvim',
    event = 'VeryLazy',
    config = function()
      require('diffview').setup {}
    end,
  },
}
