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
        adapters = {
          openai = function()
            return require('codecompanion.adapters').extend('openai', {
              env = {
                api_key = 'cmd:op read "op://Private/OpenAI MCP key/credential"',
              },
            })
          end,
        },
        log_level = 'DEBUG',
        strategies = {
          chat = {
            adapter = { name = 'openai', model = 'gpt-4o' },
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
  {
    'yetone/avante.nvim',
    build = vim.fn.has 'win32' ~= 0 and 'powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false' or 'make',
    event = 'VeryLazy',
    version = false,
    ---@module 'avante'
    ---@type avante.Config
    opts = {
      provider = 'openai',
      auto_suggestions_provider = 'openai',
      providers = {
        morph = {
          model = 'morph-v3-large',
        },
        claude = {
          endpoint = 'https://api.anthropic.com',
          model = 'claude-sonnet-4-20250514',
          timeout = 30000, -- Timeout in milliseconds
          extra_request_body = {
            temperature = 0.75,
            max_tokens = 20480,
          },
        },
        moonshot = {
          endpoint = 'https://api.moonshot.ai/v1',
          model = 'kimi-k2-0711-preview',
          timeout = 30000, -- Timeout in milliseconds
          extra_request_body = {
            temperature = 0.75,
            max_tokens = 32768,
          },
        },
      },
      input = {
        provider = 'snacks',
        provider_opts = {
          title = 'Avante Input',
          icon = ' ',
        },
      },
      behaviour = {
        enable_fastapply = true,
      },
      rag_service = {
        enabled = false,
        host_mount = os.getenv 'HOME',
        runner = 'docker',
        llm = {
          provider = 'openai',
          endpoint = 'https://api.openai.com/v1',
          api_key = 'OPENAI_API_KEY',
          model = 'gpt-4o-mini',
          extra = nil,
        },
        embed = {
          provider = 'openai',
          endpoint = 'https://api.openai.com/v1',
          api_key = 'OPENAI_API_KEY',
          model = 'text-embedding-3-large',
          extra = nil,
        },
        docker_extra_args = '',
      },
      system_prompt = function()
        local hub = require('mcphub').get_hub_instance()
        return hub and hub:get_active_servers_prompt() or ''
      end,
      -- Using function prevents requiring mcphub before it's loaded
      custom_tools = function()
        return {
          require('mcphub.extensions.avante').mcp_tool(),
        }
      end,
      selector = {
        --- @alias avante.SelectorProvider "native" | "fzf_lua" | "mini_pick" | "snacks" | "telescope" | fun(selector: avante.ui.Selector): nil
        --- @type avante.SelectorProvider
        provider = 'snacks',
        -- Options override for custom providers
        provider_opts = {},
      },
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      --- The below dependencies are optional,
      -- 'stevearc/dressing.nvim', -- for input provider dressing
      'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
      'zbirenbaum/copilot.lua', -- for providers='copilot'
      {
        -- support for image pasting
        'HakonHarnes/img-clip.nvim',
        event = 'VeryLazy',
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { 'markdown', 'Avante' },
        },
        ft = { 'markdown', 'Avante' },
      },
    },
  },
}
