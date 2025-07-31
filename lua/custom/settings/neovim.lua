vim.g.have_nerd_font = true

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- KEYMAPS
local default_options = { noremap = true, silent = true }
-- Remap Ctrl-i to move up by half a page
-- vim.api.nvim_set_keymap('n', '<C-i>', '<C-u>', default_options)
-- Map 'jj' to exit insert mode
vim.keymap.set('i', 'jj', '<Esc>', default_options)
-- CmdS save
vim.keymap.set('n', '<D-s>', ':w<CR>', { noremap = true, silent = true, desc = 'Save' })
vim.keymap.set('i', '<D-s>', '<Esc>:w<CR>', { noremap = true, silent = true, desc = 'Save' })
-- Diagnostics
vim.keymap.set('n', '<leader>e', function()
  vim.diagnostic.open_float()
  -- TODO: temporarily toggle tiny-inline-diagnostics
end, default_options)
-- Opens virtual lines but no line wrapping
-- vim.keymap.set('n', '<leader>e', function()
--   vim.diagnostic.config { virtual_lines = { current_line = true }, virtual_text = false }
--   vim.api.nvim_create_autocmd('CursorMoved', {
--     group = vim.api.nvim_create_augroup('line-diagnostics', { clear = true }),
--     callback = function()
--       vim.diagnostic.config { virtual_lines = false, virtual_text = true }
--       return true
--     end,
--   })
-- end)
