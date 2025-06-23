vim.keymap.set({ 'v', 'n' }, '<D-o>', ':CopilotChat<cr>', { noremap = true })
vim.keymap.set('i', '<C-J>', 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false,
})
-- vim.g.copilot_no_tab_map = true

-- Needed for CopilotChat in Neovim <0.11
vim.opt.completeopt = { 'menuone', 'popup', 'noinsert' }

return {
  {
    'copilotlsp-nvim/copilot-lsp',
    enabled = false,
    init = function()
      vim.g.copilot_nes_debounce = 500
      vim.lsp.enable 'copilot'
      vim.keymap.set('n', '<tab>', function()
        require('copilot-lsp.nes').apply_pending_nes()
      end)
    end,
  },
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
        log_level = 'DEBUG',
        strategies = {
          chat = {
            adapter = { name = 'copilot', model = 'claude-sonnet-4' },
            slash_commands = {
              ['file'] = {
                opts = {
                  provider = 'snacks',
                },
              },
            },
            tools = {
              ['next_edit_suggestion'] = {
                opts = {
                  --- the default is to open in a new tab, and reuse existing tabs
                  --- where possible
                  ---@type string|fun(path: string):integer?
                  jump_action = 'tabnew',
                },
              },
              ['mcp'] = {
                callback = function()
                  return require 'mcphub.extensions.codecompanion'
                end,
                opts = {
                  requires_approval = false,
                  temperature = 0.7,
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
          action_palette = {
            provider = 'default',
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
    enabled = true,
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
      { 'zbirenbaum/copilot.lua' }, -- or zbirenbaum/copilot.lua
      { 'nvim-lua/plenary.nvim', branch = 'master' }, -- for curl, log wrapper
    },
    build = 'make tiktoken', -- Only on MacOS or Linux
    opts = {
      model = 'claude-sonnet-4',
      window = {
        width = 0.35,
      },
      auto_insert_mode = true,
    },
  },
}
