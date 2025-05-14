return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',
    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
  },
  keys = function(_, keys)
    local dap = require 'dap'
    local dapui = require 'dapui'
    return {
      { '<F5>', dap.continue, desc = 'Debug = Start/Continue' },
      { '<F1>', dap.step_into, desc = 'Debug = Step Into' },
      { '<F2>', dap.step_over, desc = 'Debug = Step Over' },
      { '<F3>', dap.step_out, desc = 'Debug = Step Out' },
      { '<leader>T', dap.toggle_breakpoint, desc = 'Debug = Toggle Breakpoint' },
      -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
      { '<F7>', dapui.toggle, desc = 'Debug = See last session result.' },
      -- View evaluated value of word under the cursor
      { '<leader>E', dapui.eval, desc = 'Debug = Evaluate' },

      unpack(keys),
    }
  end,
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      handlers = {},
      ensure_installed = {},
    }

    dapui.setup {
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- Change breakpoint icons
    vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
    vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
    local breakpoint_icons = vim.g.have_nerd_font
        and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
      or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
    for type, icon in pairs(breakpoint_icons) do
      local tp = 'Dap' .. type
      local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
      vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
    end

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

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
    -- Just need to change `type = 'node'` to `type = 'pwa-node'`
    require('dap').configurations.typescript = {
      {
        name = 'Attach to Novata Server',
        port = 9229,
        protocol = 'inspector',
        request = 'attach',
        restart = true,
        skipFiles = '["<node_internals>/**"]',
        type = 'pwa-node',
      },
      {
        console = 'integratedTerminal',
        cwd = '${workspaceFolder}/packages/server',
        env = {
          DEBUG = 'server*',
          NODE_ENV = 'development',
        },
        name = 'Launch Novata Server',
        program = '${workspaceFolder}/packages/server/src/dev.ts',
        request = 'launch',
        runtimeArgs = '[ "--inspect", "--expose-gc", "-r", "@swc-node/register", "-r", "dotenv/config" ]',
        runtimeExecutable = 'node',
        skipFiles = '["<node_internals>/**"]',
        type = 'pwa-node',
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
}
