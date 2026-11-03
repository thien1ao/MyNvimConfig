-- Language servers. Defaults come from nvim-lspconfig; completion capabilities from blink.cmp.
-- Check what's attached with :checkhealth vim.lsp

vim.lsp.config('jedi_language_server', {
  -- jedi runs in its own pipx venv; point it at the active (conda) python so imports like numpy resolve
  init_options = { workspace = { environmentPath = vim.fn.exepath('python3') } },
})
vim.lsp.config('fortls', {
  cmd = { 'fortls', '--autocomplete_name_only', '--incremental_sync' },
  root_markers = { '.git' },
})

-- enable each server only if its program is installed
local servers = {
  jedi_language_server = 'jedi-language-server', -- python
  ruff = 'ruff',                                  -- python lint
  clangd = 'clangd',                              -- c / c++
  fortls = 'fortls',                              -- fortran
  rust_analyzer = 'rust-analyzer',                -- rust
  neocmake = 'neocmakelsp',                       -- cmake (preferred)
}
if vim.fn.executable('neocmakelsp') == 0 then
  servers.cmake = 'cmake-language-server'
end
for name, exe in pairs(servers) do
  if vim.fn.executable(exe) == 1 then
    vim.lsp.enable(name)
  end
end

-- diagnostics: no inline text/underline; show a popup when the cursor rests on a line
vim.diagnostic.config({
  virtual_text = false,
  underline = false,
  float = { source = true },
})
vim.api.nvim_create_autocmd('CursorHold', {
  callback = function() vim.diagnostic.open_float(nil, { focus = false }) end,
})

-- keymaps (Neovim also provides K hover, grn rename, gra code action, grr references, gO symbols)
local map = vim.keymap.set
map('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
map('n', 'gD', vim.lsp.buf.declaration, { desc = 'Go to declaration' })
map('n', 'gr', vim.lsp.buf.references, { desc = 'References' })
map('n', 'gI', vim.lsp.buf.implementation, { desc = 'Go to implementation' })
map('n', 'gT', vim.lsp.buf.type_definition, { desc = 'Go to type definition' })
map('n', 'gW', vim.lsp.buf.workspace_symbol, { desc = 'Workspace symbols' })
map('n', '<C-s>', vim.lsp.buf.signature_help, { desc = 'Signature help' })
map('n', '<leader>di', vim.diagnostic.open_float, { desc = 'Line diagnostics' })
map({ 'n', 'x' }, '<leader>fm', function() vim.lsp.buf.format({ async = true }) end, { desc = 'Format' })
