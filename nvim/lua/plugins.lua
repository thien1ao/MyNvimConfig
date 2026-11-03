-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable',
    'https://github.com/folke/lazy.nvim.git', lazypath })
end
vim.opt.runtimepath:prepend(lazypath)

local function telescope(picker, opts)
  return function() require('telescope.builtin')[picker](opts) end
end

require('lazy').setup({
  ---------------------------------------------------------------- appearance
  {
    'aliqyan-21/darkvoid.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('darkvoid').setup({
        transparent = true, -- let alacritty's window opacity show through
        glow = false,
        show_end_of_buffer = true,
        -- darkvoid's default syntax palette is all greys; give the main groups muted colors
        colors = {
          kw = '#c792ea',           -- keywords: def, return, if, import
          func = '#82aaff',         -- function names / calls
          string = '#a8c97f',
          type = '#e5c07b',         -- classes / types
          type_builtin = '#e5c07b',
          identifier = '#c0c0c0',   -- variables
          constant = '#f78c6c',     -- numbers / constants
          bool = '#f78c6c',
          preprocessor = '#89ddff', -- decorators
        },
      })
      vim.cmd.colorscheme('darkvoid')
      -- slightly yellow comments (darkvoid default is grey #585858)
      vim.api.nvim_set_hl(0, 'Comment', { fg = '#a89f68', italic = true })
      vim.api.nvim_set_hl(0, '@comment', { link = 'Comment' })
    end,
  },
  { 'nvim-tree/nvim-web-devicons' },
  {
    'nvim-lualine/lualine.nvim',
    lazy = false,
    opts = {
      options = { theme = 'auto' },
      -- buffers on the left, tabs on the right of the top line
      tabline = { lualine_a = { 'buffers' }, lualine_z = { 'tabs' } },
    },
  },
  {
    'goolord/alpha-nvim',
    lazy = false,
    config = function()
      local dashboard = require('alpha.themes.dashboard')
      dashboard.section.header.val = {
        [[  ███▄    █ ▓█████  ▒█████   ██▒   █▓ ██▓ ███▄ ▄███▓]],
        [[  ██ ▀█   █ ▓█   ▀ ▒██▒  ██▒▓██░   █▒▓██▒▓██▒▀█▀ ██▒]],
        [[ ▓██  ▀█ ██▒▒███   ▒██░  ██▒ ▓██  █▒░▒██▒▓██    ▓██░]],
        [[ ▓██▒  ▐▌██▒▒▓█  ▄ ▒██   ██░  ▒██ █░░░██░▒██    ▒██]],
        [[ ▒██░   ▓██░░▒████▒░ ████▓▒░   ▒▀█░  ░██░▒██▒   ░██▒]],
        [[ ░ ▒░   ▒ ▒ ░░ ▒░ ░░ ▒░▒░▒░    ░ ▐░  ░▓  ░ ▒░   ░  ░]],
        [[ ░ ░░   ░ ▒░ ░ ░  ░  ░ ▒ ▒░    ░ ░░   ▒ ░░  ░      ░]],
        [[    ░   ░ ░    ░   ░ ░ ░ ▒       ░░   ▒ ░░      ░]],
        [[          ░    ░  ░    ░ ░        ░   ░         ░]],
        [[                                 ░]],
      }
      dashboard.section.buttons.val = {
        dashboard.button('f', '  Find file', '<cmd>Telescope find_files<CR>'),
        dashboard.button('e', '  New file', '<cmd>ene <BAR> startinsert<CR>'),
        dashboard.button('r', '  Recently used files', '<cmd>Telescope oldfiles<CR>'),
        dashboard.button('t', '  Find text', '<cmd>Telescope live_grep<CR>'),
        dashboard.button('c', '  Configuration', '<cmd>e $MYVIMRC<CR>'),
        dashboard.button('q', '  Quit Neovim', '<cmd>qa<CR>'),
      }
      dashboard.section.header.opts.hl = 'Include'
      dashboard.section.buttons.opts.hl = 'Keyword'
      dashboard.section.footer.opts.hl = 'Type'
      dashboard.opts.opts.noautocmd = true
      require('alpha').setup(dashboard.opts)
    end,
  },

  ---------------------------------------------------------------- navigation
  {
    'nvim-tree/nvim-tree.lua',
    lazy = false,
    opts = {},
    keys = {
      { '<leader>n', '<cmd>NvimTreeOpen<CR>', desc = 'Open file tree' },
      { '<leader>e', '<cmd>NvimTreeToggle<CR>', desc = 'Toggle file tree' },
    },
  },
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = 'Telescope',
    opts = {
      defaults = {
        preview = { treesitter = { enable = false } },
        file_ignore_patterns = { 'build/', 'target/' },
      },
    },
    keys = {
      { '<leader>ff', telescope('find_files'), desc = 'Find files' },
      { '<C-p>', telescope('find_files'), desc = 'Find files' },
      { '<leader>fg', telescope('live_grep'), desc = 'Grep project' },
      { '<C-f>', telescope('live_grep'), desc = 'Grep project' },
      { '<leader>*', telescope('grep_string'), desc = 'Grep word under cursor' },
      { '<leader>fb', telescope('buffers'), desc = 'Buffers' },
      { '<C-b>', telescope('buffers'), desc = 'Buffers' },
      { '<leader>fd', telescope('lsp_definitions'), desc = 'LSP definitions' },
      { '<leader>fr', telescope('lsp_references'), desc = 'LSP references' },
      { '<leader>fi', telescope('diagnostics'), desc = 'Diagnostics' },
    },
  },
  {
    'caenrique/swap-buffers.nvim',
    opts = { ignore_filetypes = { 'NvimTree' } },
    keys = {
      { '<C-Left>', function() require('swap-buffers').swap_buffers('h') end, desc = 'Swap buffer left' },
      { '<C-Down>', function() require('swap-buffers').swap_buffers('j') end, desc = 'Swap buffer down' },
      { '<C-Up>', function() require('swap-buffers').swap_buffers('k') end, desc = 'Swap buffer up' },
      { '<C-Right>', function() require('swap-buffers').swap_buffers('l') end, desc = 'Swap buffer right' },
    },
  },
  {
    'yssl/QFEnter', -- open quickfix entries in splits
    ft = 'qf',
    init = function()
      vim.g.qfenter_keymap = {
        hopen = { '<Leader><Space>', '<C-x>' },
        vopen = { '<Leader><CR>', '<C-v>' },
      }
    end,
  },
  {
    'unblevable/quick-scope', -- highlight f/F jump targets
    keys = { 'f', 'F' },
    init = function() vim.g.qs_highlight_on_keys = { 'f', 'F' } end,
  },

  ---------------------------------------------------------------- editing
  { 'tpope/vim-surround', event = 'VeryLazy', dependencies = { 'tpope/vim-repeat' } },
  {
    'junegunn/vim-easy-align',
    keys = { { 'ga', '<Plug>(EasyAlign)', mode = { 'n', 'x' }, desc = 'Align' } },
  },

  ---------------------------------------------------------------- dev tools
  { 'tpope/vim-fugitive', cmd = { 'Git', 'G', 'Gdiffsplit', 'Gread', 'Gwrite', 'GBrowse' } },
  -- :Make! builds in the background, :Copen shows results (makeprg is set per filetype)
  { 'tpope/vim-dispatch', ft = { 'c', 'cpp', 'fortran', 'cmake' }, cmd = { 'Make', 'Dispatch', 'Copen' } },
  {
    'nvim-treesitter/nvim-treesitter', -- syntax highlighting; :TSUpdate needs the tree-sitter CLI
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      if vim.fn.executable('tree-sitter') == 1 then -- installs missing parsers (no-op if present)
        require('nvim-treesitter').install({ 'c', 'cpp', 'arduino', 'rust', 'python', 'rst', 'lua', 'vim', 'json', 'cmake' })
      end
      if vim.fn.executable('tree-sitter') == 1 then -- installs missing parsers (no-op if present)
        require('nvim-treesitter').install({ 'c', 'cpp', 'arduino', 'rust', 'python', 'rst', 'lua', 'vim', 'json', 'cmake' })
      end
      local skip = { fortran = true, tex = true, markdown = true }
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(ev)
          if skip[ev.match] then return end
          -- use treesitter only if highlight rules load; otherwise keep regex highlighting
          local lang = vim.treesitter.language.get_lang(ev.match) or ev.match
          local ok, query = pcall(vim.treesitter.query.get, lang, 'highlights')
          if ok and query then
            pcall(vim.treesitter.start, ev.buf, lang)
          end
        end,
      })
    end,
  },
  {
    'folke/trouble.nvim',
    cmd = 'Trouble',
    opts = {},
    keys = { { '<leader>xd', '<cmd>Trouble diagnostics toggle filter.buf=0<CR>', desc = 'Buffer diagnostics' } },
  },
  {
    'yuukiflow/Arduino-Nvim',
    ft = 'arduino',
    dependencies = { 'nvim-telescope/telescope.nvim', 'neovim/nvim-lspconfig' },
    config = function() require('Arduino-Nvim') end,
  },

  ---------------------------------------------------------------- completion / LSP
  { 'neovim/nvim-lspconfig', lazy = false }, -- default server configs used by lua/lsp.lua
  {
    'saghen/blink.cmp',
    version = '1.*',
    lazy = false, -- registers LSP completion capabilities on load
    opts = {
      completion = {
        list = { selection = { preselect = false } },
        accept = { auto_brackets = { enabled = false } },
      },
      -- default preset (C-space, C-e, C-n/C-p, arrows, S-Tab) plus these:
      keymap = {
        -- Tab: open the menu after a word, then cycle through it; otherwise a normal Tab
        ['<Tab>'] = {
          function(cmp)
            if cmp.snippet_active() then return cmp.accept() end
            if cmp.is_visible() then return cmp.select_next() end
            local col = vim.api.nvim_win_get_cursor(0)[2]
            if col > 0 and not vim.api.nvim_get_current_line():sub(col, col):match('%s') then
              return cmp.show()
            end
          end,
          'snippet_forward',
          'fallback',
        },
        ['<CR>'] = { 'accept', 'snippet_forward', 'fallback' },
      },
      appearance = { use_nvim_cmp_as_default = true }, -- darkvoid only styles nvim-cmp's highlight groups
      signature = { enabled = true },
    },
  },
}, {
  defaults = { lazy = true },
})
