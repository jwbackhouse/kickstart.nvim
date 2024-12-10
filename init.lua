-- vim-lazy - plugins
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup {
  { 'knubie/vim-kitty-navigator' },
}

-- vim-kitty-navigator
if os.getenv 'TERM' == 'xterm-kitty' then
  vim.g.kitty_navigator_no_mappings = 1
  vim.g.tmux_navigator_no_mappings = 1

  vim.api.nvim_set_keymap('n', 'C-h', ':KittyNavigateLeft <CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', 'C-j', ':KittyNavigateDown <CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', 'C-k', ':KittyNavigateUp <CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', 'C-l', ':KittyNavigateRight <CR>', { noremap = true, silent = true })
end
