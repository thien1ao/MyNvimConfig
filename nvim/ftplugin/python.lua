require('util').indent_folds()
vim.keymap.set('n', '<leader>b', 'Oimport pdb; pdb.set_trace()<Esc>', { buffer = true, desc = 'Insert breakpoint' })
vim.keymap.set('n', [[\l]], '<cmd>lopen<CR>', { buffer = true, desc = 'Location list' })
