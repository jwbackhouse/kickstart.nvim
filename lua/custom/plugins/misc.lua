return {
  {
    'nvzone/typr',
    dependencies = 'nvzone/volt',
    opts = {},
    cmd = { 'Typr', 'TyprStats' },
  },
  {
    'm4xshen/hardtime.nvim',
    dependencies = { 'MunifTanjim/nui.nvim' },
    opts = {
      disabled_filetypes = { 'Outline', 'grapple', 'oil', 'dap-view' },
      disabled_keys = {
        ['<Down>'] = {},
        ['<Up>'] = {},
      },
    },
  },
}
