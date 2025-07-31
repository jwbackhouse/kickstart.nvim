-- Folding
vim.opt.foldlevel = 99 -- Start with all folds open
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldtext = ''

-- Open test files with folding enabled
-- vim.api.nvim_create_autocmd('BufWinEnter', {
--   pattern = { '*' },
--   callback = function()
--     local file_name = vim.fn.expand '%:t'
--     if file_name:match '%.ts$' or file_name:match '%.test%.tsx$' then
--       vim.opt.foldlevel = 2
--       vim.opt.foldnestmax = 6
--     else
--       vim.opt.foldlevel = 99
--     end
--   end,
-- })
