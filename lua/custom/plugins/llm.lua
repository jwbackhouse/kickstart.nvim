-- Map Command-i to run :CopilotChat
-- vim.keymap.set({ 'v', 'n' }, '<D-i>', ':CopilotChat<cr>', default_options)
-- copilot - replace tab for accepting suggestions
-- vim.keymap.set('i', '<C-J>', 'copilot#Accept("\\<CR>")', {
--   expr = true,
--   replace_keycodes = false,
-- })
-- vim.g.copilot_no_tab_map = true

return {
  {
    'olimorris/codecompanion.nvim',
    enabled = true,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      local cc = require 'codecompanion'
      cc.setup {
        strategies = {
          chat = {
            adapter = 'copilot',
            slash_commands = {
              ['file'] = {
                opts = {
                  provider = 'telescope',
                },
              },
            },
          },
          inline = {
            adapter = 'copilot',
          },
        },
        display = {
          chat = {
            window = {
              width = 0.3,
            },
          },
          diff = {
            provider = 'mini_diff',
          },
        },
      }

      vim.keymap.set({ 'n', 'v' }, '<D-i>', '<Cmd>CodeCompanionActions<CR>', { noremap = true, silent = true })
      vim.cmd [[cab cc CodeCompanion]] -- map cc to CodeCompanion in command line
    end,
  },
  { 'github/copilot.vim', enabled = false, event = 'VeryLazy' },
  {
    'zbirenbaum/copilot.lua',
    event = 'VeryLazy',
    config = true,
    opts = {
      suggestion = {
        auto_trigger = true,
        keymap = {
          accept = '<Tab>',
          dismiss = '<C-e>',
        },
      },
    },
  },
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'main',
    dependencies = {
      { 'github/copilot.vim' }, -- or zbirenbaum/copilot.lua
      { 'nvim-lua/plenary.nvim', branch = 'master' }, -- for curl, log wrapper
    },
    build = 'make tiktoken', -- Only on MacOS or Linux
    opts = {
      model = 'claude-3.5-sonnet',
      window = {
        width = 0.35,
      },
      auto_insert_mode = true,
    },
  },
}
