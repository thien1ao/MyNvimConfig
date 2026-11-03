-- ~/.config/nvim/init.lua
--
--   lua/options.lua   editor settings
--   lua/keymaps.lua   general key mappings
--   lua/util.lua      helpers (build dir, whitespace, prose buffers)
--   lua/plugins.lua   plugins (lazy.nvim) and their settings
--   lua/lsp.lua       language servers, diagnostics, LSP keymaps
--   ftplugin/*.lua    per-filetype settings

require('options')
require('keymaps')
require('util').setup()
require('plugins')
require('lsp')
