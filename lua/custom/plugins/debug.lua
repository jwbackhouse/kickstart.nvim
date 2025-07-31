return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      {
        'igorlfs/nvim-dap-view',
        ---@module 'dap-view'
        ---@type dapview.Config
        opts = {
          winbar = {
            sections = { 'breakpoints', 'scopes', 'watches', 'repl', 'exceptions', 'threads' },
            default_section = 'breakpoints',
          },
          windows = {
            position = 'right',
            terminal = {
              hide = { 'pwa-node' },
            },
          },
        },
      },
      -- Installs the debug adapters for you
      'williamboman/mason.nvim',
      'jay-babu/mason-nvim-dap.nvim',
    },
    keys = function(_, keys)
      local dap = require 'dap'
      return {
        { '<F5>', dap.continue, desc = 'Debug = Start/Continue' },
        { '<F1>', dap.step_into, desc = 'Debug = Step Into' },
        { '<F2>', dap.step_over, desc = 'Debug = Step Over' },
        { '<F3>', dap.step_out, desc = 'Debug = Step Out' },
        { '<leader>T', dap.toggle_breakpoint, desc = 'Debug = Toggle Breakpoint' },
        -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
        -- { '<F7>', dapui.toggle, desc = 'Debug = See last session result.' },
        -- View evaluated value of word under the cursor
        -- { '<leader>E', dapui.eval, desc = 'Debug = Evaluate' },

        unpack(keys),
      }
    end,
    config = function()
      local dap = require 'dap'
      local dv = require 'dap-view'

      -- Auto open/close dap-view
      -- Have to stop lualine controlling the winbar
      dap.listeners.before.attach['dap-view-config'] = function()
        dv.open()
        require('lualine').hide { place = { 'winbar' }, unhide = false }
      end
      dap.listeners.before.launch['dap-view-config'] = function()
        dv.open()
        require('lualine').hide { place = { 'winbar' }, unhide = false }
      end
      dap.listeners.before.event_terminated['dap-view-config'] = function()
        dv.close()
        require('lualine').hide { unhide = true }
      end
      dap.listeners.before.event_exited['dap-view-config'] = function()
        dv.close()
        require('lualine').hide { unhide = true }
      end

      require('mason-nvim-dap').setup {
        -- Makes a best effort to setup the various debuggers with
        -- reasonable debug configurations
        automatic_installation = true,

        handlers = {},
        ensure_installed = {},
      }

      -- Change breakpoint icons
      vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
      vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
      vim.api.nvim_set_hl(0, 'NvimDapViewControlDisconnect', { fg = '#ffcc00' })
      vim.api.nvim_set_hl(0, 'NvimDapViewControlTerminate', { fg = '#f21cf0' })
      local breakpoint_icons = vim.g.have_nerd_font
          and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
        or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
      for type, icon in pairs(breakpoint_icons) do
        local tp = 'Dap' .. type
        local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
        vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
      end

      require('dap').adapters['pwa-node'] = {
        type = 'server',
        host = 'localhost',
        port = '${port}',
        executable = {
          command = 'node',
          args = { os.getenv 'HOME' .. '/vscode-js-debug/dist/src/dapDebugServer.js', '${port}' },
        },
      }

      -- Copied from .vscode/launch.json
      -- Not all properties work - for example, `skipFiles` will break things
      require('dap').configurations.typescript = {
        {
          name = 'Attach to Novata Server',
          port = 9229,
          protocol = 'inspector',
          request = 'attach',
          restart = true,
          type = 'pwa-node',
        },
        {
          name = 'Launch Novata Server',
          console = 'integratedTerminal',
          internalConsoleOptions = 'neverOpen',
          port = '${port}',
          cwd = '${workspaceFolder}/packages/server',
          env = {
            DEBUG = 'server*',
            NODE_ENV = 'development',
          },
          program = '${workspaceFolder}/packages/server/src/dev.ts',
          request = 'launch',
          runtimeArgs = '[ "--inspect", "--expose-gc", "-r", "@swc-node/register", "-r", "dotenv/config" ]',
          runtimeExecutable = 'node',
          type = 'pwa-node',
        },
        {
          name = 'Debug Data Workspace API Tests',
          type = 'pwa-node',
          request = 'launch',
          runtimeExecutable = 'npm',
          runtimeArgs = {
            'run',
            'test',
            '-w',
            '@novata/data-workspace-api',
            '--runInBand',
          },
          program = '${file}',
          cwd = '${workspaceFolder}',
          console = 'integratedTerminal',
          internalConsoleOptions = 'neverOpen',
          port = '${port}',
        },
        {
          name = 'Debug Domain Tests',
          type = 'pwa-node',
          request = 'launch',
          runtimeExecutable = 'npm',
          runtimeArgs = {
            'run',
            'test:integration',
            '-w',
            '@novata/domain',
            '--runInBand',
          },
          program = '${file}',
          cwd = '${workspaceFolder}',
          console = 'integratedTerminal',
          internalConsoleOptions = 'neverOpen',
          port = '${port}',
        },
        {
          name = 'Debug Server Tests',
          type = 'pwa-node',
          request = 'launch',
          runtimeExecutable = 'npm',
          runtimeArgs = {
            'run',
            'test:integration',
            '-w',
            '@novata/server',
            '--runInBand',
          },
          program = '${file}',
          cwd = '${workspaceFolder}',
          console = 'integratedTerminal',
          internalConsoleOptions = 'neverOpen',
          port = '${port}',
        },
        {
          name = 'Launch current file',
          request = 'launch',
          type = 'pwa-node',
          program = '${file}',
          cwd = '${workspaceFolder}',
        },
      }
    end,
  },
}
