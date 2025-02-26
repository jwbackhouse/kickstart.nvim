return {
  {
    'nvim-telescope/telescope-frecency.nvim',
    version = '*',
    enabled = false,
    config = function()
      local telescope = require 'telescope'
      telescope.setup {
        extensions = {
          ---@type FrecencyOpts
          frecency = {
            show_scores = false,
            matcher = 'fuzzy',
            default_workspace = 'CWD',
            filter_delimiter = ';',
            enable_prompt_mappings = true,
            hide_current_buffer = true,
            ignore_patterns = { 'private/*' },
            path_display = { 'truncate' },
            theme = 'ivy',
            show_filter_column = false,
            workspaces = {
              ['nv'] = vim.fn.stdpath 'config',
              ['car'] = vim.fn.getcwd() .. '/packages/carbon-navigator',
              ['pri'] = vim.fn.getcwd() .. '/packages/privco-client',
              ['mld'] = vim.fn.getcwd() .. 'packages/multi-level-data',
              ['ser'] = vim.fn.getcwd() .. '/packages/server',
              ['dom'] = vim.fn.getcwd() .. '/packages/domain',
              ['com'] = vim.fn.getcwd() .. '/packages/common',
            },
          },
        },
      }

      telescope.load_extension 'frecency'
    end,
  },
}
