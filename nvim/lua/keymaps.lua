local map = vim.keymap.set

-- insert a single character without leaving normal mode
map('n', '<Space>', function()
  vim.cmd.normal({ 'i' .. vim.fn.getcharstr(), bang = true })
end, { desc = 'Insert one character' })

-- leave insert / terminal mode
map('i', 'jj', '<Esc>')
map('i', 'jk', '<Esc>')
map('t', '<Esc>', [[<C-\><C-n>]])

-- buffers and tabs
map('n', '<Tab>', '<cmd>bnext<CR>')
map('n', '<S-Tab>', '<cmd>bprev<CR>')
map('n', '<C-e>', ':set nomore <Bar> :ls <Bar> :set more <CR>:b<Space>', { silent = true, desc = 'Pick buffer' })
map('n', '<leader>tn', '<cmd>tabprevious<CR>')
map('n', '<leader>tm', '<cmd>tabnext<CR>')

-- windows: move with Ctrl+hjkl, resize with arrows
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')
map('', '<Up>', '<C-w>2-')
map('', '<Down>', '<C-w>2+')
map('', '<Left>', '<C-w>2<')
map('', '<Right>', '<C-w>2>')
map('', '<leader>th', '<C-w>t<C-w>H', { desc = 'Splits side by side' })
map('', '<leader>tk', '<C-w>t<C-w>K', { desc = 'Splits stacked' })

-- editing
map('n', '<leader>s', [[:%s/\<<C-r><C-w>\>//g<Left><Left>]], { desc = 'Replace word under cursor' })
map('x', '<leader>p', '"_dP', { desc = 'Paste without yanking selection' })
map('v', '<C-c>', '"+y', { desc = 'Copy to system clipboard' })
map('n', 'Q', '<nop>')
