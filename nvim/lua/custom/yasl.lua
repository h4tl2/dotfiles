-- credit to elianiva
-- https://elianiva.my.id/post/neovim-lua-statusline
local fn = vim.fn
local api = vim.api

local modes = setmetatable({
  ['n'] = 'N',
  ['no'] = 'N·Pending',
  ['v'] = 'V',
  ['V'] = 'V·Line',
  [''] = 'V·Block',
  ['s'] = 'Select',
  ['S'] = 'S·Line',
  [''] = 'S·Block',
  ['i'] = 'I', -- INSERT
  ['ic'] = 'I', -- INSERT
  ['R'] = 'R', -- REPLACE
  ['Rv'] = 'V·Replace',
  ['c'] = 'Command',
  ['cv'] = 'Vim·Ex',
  ['ce'] = 'Ex',
  ['r'] = 'Prompt',
  ['rm'] = 'More',
  ['r?'] = 'Confirm',
  ['!'] = 'Shell',
  ['t'] = 'Terminal',
}, {
  __index = function()
    return { 'Unknown' } -- handle edge cases
  end,
})

local function mode()
  local current_mode = api.nvim_get_mode().mode
  return string.format(' %s ', modes[current_mode]):upper()
end

local function update_mode_colors()
  local current_mode = api.nvim_get_mode().mode
  local mode_color = '%#StatusLineAccent#'
  if current_mode == 'n' then
    mode_color = '%#StatuslineAccent#'
  elseif current_mode == 'i' or current_mode == 'ic' then
    mode_color = '%#StatuslineInsertAccent#'
  elseif current_mode == 'v' or current_mode == 'V' or current_mode == '' then
    mode_color = '%#StatuslineVisualAccent#'
  elseif current_mode == 'R' then
    mode_color = '%#StatuslineReplaceAccent#'
  elseif current_mode == 'c' then
    mode_color = '%#StatuslineCmdLineAccent#'
  elseif current_mode == 't' then
    mode_color = '%#StatuslineTerminalAccent#'
  end
  return mode_color
end

local function get_git_status()
  -- use fallback because it doesn't set this variable on the initial `BufEnter`
  local signs = vim.b.gitsigns_status_dict or { head = '', added = 0, changed = 0, removed = 0 }
  local is_head_empty = signs.head ~= ''

  return is_head_empty
      and string.format(
        -- 
        '  %s [+%s~%s-%s] ',
        string.sub(signs.head, 0, 10),
        signs.added or 0,
        signs.changed or 0,
        signs.removed or 0
        -- signs.head, signs.added, signs.changed, signs.removed
      )
    or ''
end

local function get_filepath()
  local fpath = fn.fnamemodify(fn.expand '%', ':~:.:h')
  if fpath == '' or fpath == '.' then
    return ' '
  end
  -- 
  return string.format(' %%<%s/', fpath)
end

local function get_filename()
  local filename = fn.expand '%:t'
  return filename == '' and '' or filename
end

local function get_filetype()
  local file_name, file_ext = fn.expand '%:t', fn.expand '%:e'
  local icon = require('nvim-web-devicons').get_icon(file_name, file_ext, { default = true })
  local filetype = vim.bo.filetype

  if filetype == '' then
    return ''
  end
  return string.format(' %s %s', icon, filetype):lower()
end

local function get_line_info()
  -- return ' %l:%c '"%-0"
  -- return ' [󱀳:%-03p :%-03l]'
  return ' [:%-02p]'
end

local function get_lsp_diagnostic()
  local count = {}
  local levels = {
    errors = 'Error',
    warnings = 'Warn',
    info = 'Info',
    hints = 'Hint',
  }

  for k, level in pairs(levels) do
    count[k] = vim.tbl_count(vim.diagnostic.get(0, { severity = level }))
  end

  local errors = ''
  local warnings = ''
  local hints = ''
  local info = ''

  if count['errors'] ~= 0 then
    errors = ' %#DiagnosticError#E:' .. count['errors']
  end
  if count['warnings'] ~= 0 then
    warnings = ' %#DiagnosticWarn#W:' .. count['warnings']
  end
  if count['hints'] ~= 0 then
    hints = ' %#DiagnosticHint#H:' .. count['hints']
  end
  if count['info'] ~= 0 then
    info = ' %#DiagnosticInfo#I:' .. count['info']
  end

  return table.concat { errors, warnings, hints, info, '%#Normal# ' }
end

-- https://alpha2phi.medium.com/neovim-for-beginners-lsp-part-2-37f9f72779b6#3249
local function get_lsp_client()
  local bufnr = vim.fn.bufnr()
  local buf_clients = vim.lsp.get_clients { bufnr }
  if next(buf_clients) == nil then
    return ''
  end
  local buf_client_names = {}
  for _, client in pairs(buf_clients) do
    table.insert(buf_client_names, client.name)
  end
  return ' ' .. table.concat(buf_client_names, ',') .. ' '
end

local M = {}

M.set_active = function(self)
  return table.concat {
    -- update_mode_colors(),
    '%#Normal#',
    mode(),
    '%#Normal#',
    get_git_status(),
    -- "%=",
    get_filepath(),
    get_filename(),
    get_lsp_diagnostic(),
    '%=',
    get_lsp_client(),
    -- update_mode_colors(),
    get_filetype(),
    get_line_info(),
  }
end

M.set_inactive = function()
  return '%= %F %='
end

M.set_explorer = function()
  return '  '
end

Statusline = setmetatable(M, {
  __call = function(self, mode)
    return self['set_' .. mode](self)
  end,
})

vim.api.nvim_exec(
  [[
  augroup Statusline
  au!
  au WinEnter,BufEnter * setlocal statusline=%!v:lua.Statusline('active')
  au WinLeave,BufLeave * setlocal statusline=%!v:lua.Statusline('inactive')
  au WinEnter,BufEnter,FileType NvimTree setlocal statusline=%!v:lua.Statusline('explorer')
  augroup END
]],
  false
)
