local M = {}

--- Get highlight properties for a given highlight name
--- @param name string The highlight group name
--- @param fallback? table The fallback highlight properties
--- @return table properties # the highlight group properties
function M.get_hlgroup(name, fallback)
  if vim.fn.hlexists(name) == 1 then
    local group = vim.api.nvim_get_hl(0, { name = name })

    local hl = {
      fg = group.fg == nil and 'NONE' or M.parse_hex(group.fg),
      bg = group.bg == nil and 'NONE' or M.parse_hex(group.bg),
    }

    return hl
  end
  return fallback or {}
end

--- Remove a buffer by its number without affecting window layout
--- @param buf? number The buffer number to delete
function M.delete_buffer(buf)
  if buf == nil or buf == 0 then
    buf = vim.api.nvim_get_current_buf()
  end

  vim.api.nvim_command('bwipeout ' .. buf)
end

--- Switch to the previous buffer
function M.switch_to_previous_buffer()
  local ok, _ = pcall(function()
    vim.cmd 'buffer #'
  end)
  if not ok then
    vim.notify('No other buffer to switch to!', 3, { title = 'Warning' })
  end
end

--- Get the number of open buffers
--- @return number
function M.get_buffer_count()
  local count = 0
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.fn.bufname(buf) ~= '' then
      count = count + 1
    end
  end
  return count
end

--- Parse a given integer color to a hex value.
--- @param int_color number
function M.parse_hex(int_color)
  return string.format('#%x', int_color)
end

--- Create a centered floating window of a given width and height, relative to the size of the screen.
--- @param width number width of the window where 1 is 100% of the screen
--- @param height number height of the window - between 0 and 1
--- @param buf number The buffer number
--- @return number The window number
function M.open_centered_float(width, height, buf)
  buf = buf or vim.api.nvim_create_buf(false, true)
  local win_width = math.floor(vim.o.columns * width)
  local win_height = math.floor(vim.o.lines * height)
  local offset_y = math.floor((vim.o.lines - win_height) / 2)
  local offset_x = math.floor((vim.o.columns - win_width) / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = win_width,
    height = win_height,
    row = offset_y,
    col = offset_x,
    style = 'minimal',
    border = 'single',
  })

  return win
end

--- Open the help window in a floating window
--- @param buf number The buffer number
function M.open_help(buf)
  if buf ~= nil and vim.bo[buf].filetype == 'help' then
    local help_win = vim.api.nvim_get_current_win()
    local new_win = M.open_centered_float(0.6, 0.7, buf)

    -- set keymap 'q' to close the help window
    vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':q!<CR>', {
      nowait = true,
      noremap = true,
      silent = true,
    })

    -- set scroll position
    vim.wo[help_win].scroll = vim.wo[new_win].scroll

    -- close the help window
    vim.api.nvim_win_close(help_win, true)
  end
end

--- Run a shell command and return the output
--- @param cmd table The command to run in the format { "command", "arg1", "arg2", ... }
--- @param cwd? string The current working directory
--- @return table stdout, number? return_code, table? stderr
function M.get_cmd_output(cmd, cwd)
  if type(cmd) ~= 'table' then
    vim.notify('Command must be a table', 3, { title = 'Error' })
    return {}
  end

  local command = table.remove(cmd, 1)
  local stderr = {}
  local stdout, ret = require('plenary.job')
      :new({
        command = command,
        args = cmd,
        cwd = cwd,
        on_stderr = function(_, data)
          table.insert(stderr, data)
        end,
      })
      :sync()

  return stdout, ret, stderr
end

--- Write a table of lines to a file
--- @param file string Path to the file
--- @param lines table Table of lines to write to the file
function M.write_to_file(file, lines)
  if not lines or #lines == 0 then
    return
  end
  local buf = io.open(file, 'w')
  for _, line in ipairs(lines) do
    if buf ~= nil then
      buf:write(line .. '\n')
    end
  end

  if buf ~= nil then
    buf:close()
  end
end

--- Display a diff between the current buffer and a given file
--- @param file string The file to diff against the current buffer
function M.diff_file(file)
  local pos = vim.fn.getpos '.'
  local current_file = vim.fn.expand '%:p'
  vim.cmd('edit ' .. file)
  vim.cmd('vert diffsplit ' .. current_file)
  vim.fn.setpos('.', pos)
end

--- Display a diff between a file at a given commit and the current buffer
--- @param commit string The commit hash
--- @param file_path string The file path
function M.diff_file_from_history(commit, file_path)
  local extension = vim.fn.fnamemodify(file_path, ':e') == '' and '' or '.' .. vim.fn.fnamemodify(file_path, ':e')
  local temp_file_path = os.tmpname() .. extension

  local cmd = { 'git', 'show', commit .. ':' .. file_path }
  local out = M.get_cmd_output(cmd)

  M.write_to_file(temp_file_path, out)
  M.diff_file(temp_file_path)
end

--- Open an fzf picker to select a file to diff against the current buffer
function M.fzf_diff_file()
  local fzf = require('fzf-lua')
  fzf.files({
    prompt = 'Select File to Compare> ',
    actions = {
      ['default'] = function(selected)
        M.diff_file(selected[1])
      end,
    },
  })
end

--- Open an fzf picker to select a commit to diff against the current buffer
function M.fzf_diff_from_history()
  local current_file = vim.fn.fnamemodify(vim.fn.expand '%:p', ':~:.'):gsub('\\', '/')
  local fzf = require('fzf-lua')

  fzf.git_commits({
    prompt = 'Select Commit> ',
    cmd = 'git log --pretty=oneline --abbrev-commit --follow -- ' .. current_file,
    actions = {
      ['default'] = function(selected)
        -- Extract commit hash from the selected line (first word)
        local commit = selected[1]:match('^(%S+)')
        M.diff_file_from_history(commit, current_file)
      end,
    },
  })
end

function M.get_branch()
  -- get the current branch using native vim.fn
  local branch = vim.fn.system('git branch --show-current')
  if vim.v.shell_error ~= 0 then
    return nil
  end
  return branch:gsub('\n', '') -- Remove trailing newline
end

function M.get_file()
  -- get git root directory using native vim.fn
  local git_root = vim.fn.system('git rev-parse --show-toplevel')
  if vim.v.shell_error ~= 0 then
    return nil
  end

  git_root = git_root:gsub('\n', '') -- Remove trailing newline
  local file_path = vim.fn.expand('%:p')

  -- Get relative path using native vim functions
  local relative_path = vim.fn.fnamemodify(file_path, ':~:.')

  -- Remove the first folder from the relative file path
  local pos = relative_path:find('/')
  if pos then
    relative_path = relative_path:sub(pos + 1)
  end

  return relative_path
end

function M.get_remote()
  -- Use native vim.fn instead of io.popen
  local remote = vim.fn.system('git config --get remote.origin.url')
  if vim.v.shell_error ~= 0 then
    print('No remote found')
    return ''
  end

  return remote:gsub('\n', '') -- Remove trailing newline
end

function M.get_line_on_remote()
  local remote = M.get_remote()
  if not remote then
    return ''
  end

  local file_path = M.get_file()
  local line_number = vim.fn.line('.')

  -- extract parts from
  -- ssh://git@stash.something:9999/~username/dashboard.git
  if string.find(remote, 'stash') then
    local ssh, user, domain, port, group, repo = remote:match '(ssh://)([^@]+)@([^:]+):(%d+)/([^/]+)/([^/]+).git'

    local git_remote_url = ('https://%s/projects/%s/repos/%s/browse/'):format(domain, group:upper(), repo)
    return git_remote_url .. file_path .. '#' .. line_number
  end

  if string.find(remote, 'github') then
    local user, repo = remote:match 'github.com:(.+)/(.+).git'
    local github_url = 'https://github.com/' .. user .. '/' .. repo
    local branch = M.get_branch() or 'main'
    local git_remote_url_with_line = github_url .. '/blob/' .. branch .. '/' .. file_path .. '#L' .. line_number
    return git_remote_url_with_line
  end
end

return M
