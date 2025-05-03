vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('config.lazy')

require('config.settings')
require('config.keymaps')
require('config.telescope')
require('config.colors')
require('config.cmd')
require('config.autocmp')
require('config.lsp')

require('custom.scratches')
require('custom.yasl')
require('custom.go')

-- Load the colorscheme
vim.cmd [[ colorscheme envy ]]
-- vim: ts=2 sts=2 sw=2 et
