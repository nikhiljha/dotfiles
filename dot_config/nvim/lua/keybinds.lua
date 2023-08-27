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

vim.keymap.set('n', '<leader>ba', function() vim.lsp.buf.code_action() end) -- Buffer Actions
vim.keymap.set('n', '<leader>bd', function() vim.lsp.buf.definition() end) -- Buffer Definition
vim.keymap.set('n', '<leader>be', function() vim.lsp.buf.declaration() end) -- Buffer dEclaration
vim.keymap.set('n', '<leader>bf', function() vim.lsp.buf.format {} end) -- Buffer Format
vim.keymap.set('n', '<leader>bh', function() vim.lsp.buf.hover() end) -- Buffer Hover
vim.keymap.set('n', '<leader>bp', function() vim.diagnostic.goto_next() end) -- Buffer Problem
vim.keymap.set('n', '<leader>br', function() vim.lsp.buf.references() end) -- Buffer References


