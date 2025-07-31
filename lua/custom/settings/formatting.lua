vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = { '*.tsx', '*.ts', '*.jsx', '*.js', '*.json' },
  group = vim.api.nvim_create_augroup('EslintFixAll', { clear = true }),
  command = 'silent! LspEslintFixAll',
})
