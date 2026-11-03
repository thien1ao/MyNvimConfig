local M = {}

--- Point :make (and vim-dispatch's :Make) at <git root><subdir>, e.g. "/build".
function M.set_makeprg(subdir)
  local root = vim.fs.root(0, '.git')
  if root then
    vim.opt_local.makeprg = 'make -C ' .. root .. subdir
  end
end

--- Settings for code buffers.
function M.code(indent)
  local opt = vim.opt_local
  opt.shiftwidth = indent
  opt.tabstop = indent
  opt.softtabstop = indent
end

--- Indent-based folding, open by default (za / zc to fold).
function M.indent_folds()
  local opt = vim.opt_local
  opt.foldmethod = 'indent'
  opt.foldnestmax = 10
  opt.foldlevel = 1
  opt.foldenable = false
end

--- Settings for prose buffers (markdown, text, rst, tex).
function M.prose()
  local opt = vim.opt_local
  opt.wrap = true
  opt.linebreak = true
  opt.list = false
  opt.spell = true
  opt.spelllang = 'en_us'
  -- move by screen line on wrapped text
  vim.keymap.set({ 'n', 'x' }, 'j', 'gj', { buffer = true })
  vim.keymap.set({ 'n', 'x' }, 'k', 'gk', { buffer = true })
end

local function strip_trailing(range)
  local view = vim.fn.winsaveview()
  vim.cmd('keeppatterns ' .. range .. [[s/\s\+$//e]])
  vim.fn.winrestview(view)
end

function M.setup()
  -- highlight trailing whitespace in red (not while typing at the cursor)
  local group = vim.api.nvim_create_augroup('ExtraWhitespace', {})
  local function set_hl()
    vim.api.nvim_set_hl(0, 'ExtraWhitespace', { bg = 'red', ctermbg = 'red' })
  end
  local function show(pattern)
    return function()
      vim.fn.clearmatches()
      if vim.bo.buftype == '' then
        vim.fn.matchadd('ExtraWhitespace', pattern)
      end
    end
  end
  set_hl()
  vim.api.nvim_create_autocmd('ColorScheme', { group = group, callback = set_hl })
  vim.api.nvim_create_autocmd({ 'BufWinEnter', 'InsertLeave' }, { group = group, callback = show([[\s\+$]]) })
  vim.api.nvim_create_autocmd('InsertEnter', { group = group, callback = show([[\s\+\%#\@<!$]]) })

  -- :UnfuckLine strips trailing whitespace on this line, :Unfuck on the whole file (+ tabs -> spaces)
  vim.api.nvim_create_user_command('UnfuckLine', function() strip_trailing('') end, {})
  vim.api.nvim_create_user_command('Unfuck', function()
    vim.cmd.retab()
    strip_trailing('%')
  end, {})
  vim.keymap.set('n', '<leader>u', '<cmd>UnfuckLine<CR>', { desc = 'Strip trailing whitespace (line)' })
end

return M
