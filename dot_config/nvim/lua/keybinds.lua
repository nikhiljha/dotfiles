-- telescope
vim.keymap.set('n', '<leader>p', ':Telescope ')
vim.keymap.set('n', '<leader>pp', '<cmd>Telescope find_files<cr>')
vim.keymap.set('n', '<leader>pg', '<cmd>Telescope live_grep<cr>')
vim.keymap.set('n', '<leader>pd', '<cmd>Telescope diagnostics<cr>')

-- sidebar toggle
vim.keymap.set('n', '<leader>s', function() require("nvim-tree.api").tree.toggle() end)

-- tab settings
vim.keymap.set('n', '<leader>t', ':set et sw=0 ts=')
vim.keymap.set('n', '<leader>tt', '<cmd>set et sw=0 ts=4<cr>')

vim.keymap.set('n', '<leader>bf', function() vim.lsp.buf.formatting() end)
vim.keymap.set('n', '<leader>bh', function() vim.lsp.buf.hover() end)
vim.keymap.set('n', '<leader>ba', function() vim.lsp.buf.code_action() end)
