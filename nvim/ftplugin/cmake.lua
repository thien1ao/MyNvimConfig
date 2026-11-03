require('util').code(2)
require('util').set_makeprg('/build')
vim.keymap.set('n', [[\l]], '<cmd>copen<CR>', { buffer = true, desc = 'Build errors' })
