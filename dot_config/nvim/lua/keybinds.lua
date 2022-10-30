local sidebar = require("sidebar-nvim")
local baropen = false

-- telescope
vim.keymap.set('n', '<leader>p', ':Telescope ')
vim.keymap.set('n', '<leader>pp', '<cmd>Telescope find_files<cr>')
vim.keymap.set('n', '<leader>pg', '<cmd>Telescope live_grep<cr>')

-- sidebar toggle
vim.keymap.set('n', '<leader>s', function() baropen = (not baropen) if (baropen) then sidebar.open() else sidebar.close() end end)

-- tab settings
vim.keymap.set('n', '<leader>t', ':set et sw=0 ts=')
vim.keymap.set('n', '<leader>tt', '<cmd>set et sw=0 ts=4<cr>')

-- lsp
vim.cmd [[
	augroup lspconfig
		au!
		" diagnostic on hover
		au CursorHold * lua vim.diagnostic.open_float({focus = false})
	augroup END
]]

