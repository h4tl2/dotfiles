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
      {
        'j-hui/fidget.nvim',
        tag = "legacy",
        event = "LspAttach",
        opts = {}
      },
    },
  },
  {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = "make install_jsregexp"
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
    lazy = true,
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
  {
    'nvim-pack/nvim-spectre',
    lazy = true,
    config = function()
      require('spectre').setup({
        mapping = {
          ['run_replace'] = {
            map = "<leader>ra",
            cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
            desc = "replace all"
          },
        }
      })
    end
  },
  {
    'cappyzawa/trim.nvim',
    opts = {
      ft_blocklist = { "markdown" }
    }
  },
  { 'rafamadriz/friendly-snippets' },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  },
  { 'Asheq/close-buffers.vim' },


  -- UI (Tab, status, indicators)
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("ibl").setup {}
    end,
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
  { 'kkga/vim-envy' },
  { 'Verf/deepwhite.nvim' },
  { 'https://gitlab.com/madyanov/gruber.vim' },
  -- ai (copilot, chatgpt)
  {
    "zbirenbaum/copilot.lua",
    lazy = true,
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    config = function()
      require("copilot_cmp").setup()
    end
  },
  {
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    config = function()
      require("chatgpt").setup({
        api_key_cmd = "cat " .. os.getenv('HOME') .. "/.chatgptnvim.txt"
      })
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "folke/trouble.nvim",
      "nvim-telescope/telescope.nvim"
    }
  },
  -- Others
  -- { "github/copilot.vim" },
  -- { "rest-nvim/rest.nvim",           lazy = true },
  { 'folke/trouble.nvim', },
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

  { import = 'nv.plugins' },
}, {
  spec = {
    { import = "lazyvim.plugins.extras.formatting.prettier" },
  },
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
require('nv.autocmp')
require('nv.lsp')
require('nv.scratches')

vim.g.rasmus_bold_keywords = true
vim.g.rasmus_italic_comments = false

-- Load the colorscheme
vim.cmd [[ colorscheme envy ]]
-- vim: ts=2 sts=2 sw=2 et
