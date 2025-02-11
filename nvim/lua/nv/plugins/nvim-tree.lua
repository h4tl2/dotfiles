return {
  'nvim-tree/nvim-tree.lua',
  version = '*',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('nvim-tree').setup {
      view = {
        width = 30,
      },
      update_focused_file = {
        enable = true,
      },
      auto_reload_on_write = false,
      renderer = {
        indent_markers = {
          enable = true,
        },
        icons = {
          -- git_placement = 'signcolumn',
          show = {
            file = true,
            folder = false,
            folder_arrow = true,
            git = true,
          },
          glyphs = {
            git = {
              unstaged = '',
              staged = '',
              unmerged = '',
              renamed = '',
              untracked = '',
              deleted = '',
            },
          },
        },
      },
      filters = {
        dotfiles = false,
        custom = { '^.git$', '.DS_Store' },
        exclude = { '.env', '.debug' },
      },
      diagnostics = {
        enable = false,
        show_on_dirs = false,
        icons = {
          hint = '',
          info = '',
          warning = '',
          error = '',
        },
      },
      git = {
        enable = true,
      },
    }
  end,
}
