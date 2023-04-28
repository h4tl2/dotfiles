vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)
require('lazy').setup({
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',
      { 'j-hui/fidget.nvim',       opts = {} },
      'folke/neodev.nvim',
    },
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-path',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip'
    },
  },
  { 'onsails/lspkind-nvim' },
  {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup(
        { check_ts = true }, { disable_filetype = { "TelescopePrompt", "vim" } }
      )
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local cmp_status_ok, cmp = pcall(require, "cmp")
      if not cmp_status_ok then return end
      cmp.event:on('confirm_done',
        cmp_autopairs.on_confirm_done({ map_char = { tex = '' } }))
    end
  },
  { 'windwp/nvim-spectre' },
  {
    'cappyzawa/trim.nvim',
    opts = {
      ft_blocklist = { "markdown" }
    }
  },
  { 'rafamadriz/friendly-snippets' },


  -- UI (Tab, status, indicators)
  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    opts = {
      show_end_of_line = true,
      space_char_blankline = " ",
      show_trailing_blankline_indent = false,
    },
  },
  -- GIT
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
  },
  {
    'sindrets/diffview.nvim',
    config = function()
      require('diffview').setup {}
    end
  },

  -- Themes
  {
    'navarasu/onedark.nvim',
  },
  {
    'kkga/vim-envy',
  },

  -- Others
  { 'folke/which-key.nvim',        opts = {} },
  {
    'folke/trouble.nvim',
  },
  { 'numToStr/Comment.nvim',         opts = {} },
  { 'nvim-telescope/telescope.nvim', version = '*', dependencies = { 'nvim-lua/plenary.nvim' } },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ":TSUpdate",
  },

  -- Language specific
  { 'mattn/vim-goaddtags' },
  { 'buoto/gotests-vim' },
  { 'towolf/vim-helm' },

  require 'nv.plugins.autoformat',
  -- require 'nv.plugins.debug',

  { import = 'custom.plugins' },
}, {
  performance = {
    rtp = {
      disabled_plugins = {
        "2html_plugin",
        "getscript",
        "getscriptPlugin",
        "gzip",
        "logipat",
        "netrw",
        "netrwPlugin",
        "netrwSettings",
        "netrwFileHandlers",
        -- "matchit",
        -- "matchparen",
        "tar",
        "tarPlugin",
        "rrhelper",
        -- "vimball",
        -- "vimballPlugin",
        "zip",
        "zipPlugin",
      },
    },
  },
})

-- [[ Setting options ]]
require('nv.settings')
require('nv.keymaps')
require('nv.telescope')
require('nv.treesitter')
require('nv.colors')
require('nv.yasl')
require('nv.autocmd')
require('nv.cmp')
require('nv.lsp')
require('nv.scratches')

vim.cmd [[ colorscheme envy ]]
-- vim: ts=2 sts=2 sw=2 et
