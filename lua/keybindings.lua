-- The main file with keybindings
-- Some mappings are also in configuration files

vim.keymap.set('n', '<leader>df', vim.diagnostic.open_float, {})
vim.keymap.set('n', '<leader>[d', vim.diagnostic.goto_prev, {})
vim.keymap.set('n', '<leader>]d', vim.diagnostic.goto_next, {})
