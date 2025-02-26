local M = {}

-- From https://github.com/anasrar/.dotfiles/blob/fdf4b88dfd2255b90f03c62dfc0f3f9458dc99a9/neovim/.config/nvim/lua/rin/DAP/languages/typescript.lua
M.setup = function()
  vim.print 'Setting up DAP'
  -- local ok = require('rin.utils.check_requires').check {
  --   'dap',
  --   'dapui',
  --   'nvim-dap-virtual-text',
  -- }
  -- if not ok then
  --   return
  -- end

  local dap = require 'dap'
  local dapui = require 'dapui'
  local dap_ext_vscode = require 'dap.ext.vscode'
  local dap_virtual_text = require 'nvim-dap-virtual-text'

  -- This bit adapted from DAP docs: https://github.com/mfussenegger/nvim-dap/issues/82
  -- and https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#javascript
  dap.adapters['node-terminal'] = {
    type = 'server',
    host = '127.0.0.1',
    port = 8124,
    -- name = 'node-terminal',
    -- command = 'node',

    -- executable = {
    --   command = 'node',
    --   -- args = { vim.fn.stdpath 'data' .. '/mason/bin/js-debug-adapter', '${port}' },
    -- args = { '/Users/james.backhouse/Downloads/js-debug-dap-v1.96.0/js-debug/src/dapDebugServer.js', '8000' },
    -- },
  }
  dap.adapters.node = {
    type = 'executable',
    name = 'node-terminal',
    command = 'node',

    -- executable = {
    --   command = 'node',
    --   -- args = { vim.fn.stdpath 'data' .. '/mason/bin/js-debug-adapter', '${port}' },
    args = { '/Users/james.backhouse/Downloads/js-debug-dap-v1.96.0/js-debug/src/dapDebugServer.js', '8124' },
    -- type = 'server',
    -- host = 'localhost',
    -- port = '${port}',
    -- executable = {
    --   command = 'node',
    --   -- args = { vim.fn.stdpath 'data' .. '/mason/bin/js-debug-adapter', '${port}' },
    --   args = { '/Users/james.backhouse/Downloads/js-debug-dap-v1.96.0/js-debug/src/dapDebugServer.js', '${port}' },
    -- },
  }

  dap.configurations.typescript = {
    -- {
    --   -- use nvim-dap-vscode-js's pwa-node debug adapter
    --   type = 'node-terminal',
    --   -- attach to an already running node process with --inspect flag
    --   -- default port: 9222
    --   request = 'attach',
    --   -- allows us to pick the process using a picker
    --   processId = require('dap.utils').pick_process,
    --   -- name of the debug action you have to select for this config
    --   name = 'Attach debugger to existing `node --inspect` process',
    --   -- for compiled languages like TypeScript or Svelte.js
    --   sourceMaps = true,
    --   -- resolve source maps in nested locations while ignoring node_modules
    --   resolveSourceMapLocations = {
    --     '${workspaceFolder}/**',
    --     '!**/node_modules/**',
    --   },
    --   -- path to src in vite based projects (and most other projects as well)
    --   cwd = '${workspaceFolder}/src',
    --   -- we don't want to debug code inside node_modules, so skip it!
    --   skipFiles = { '${workspaceFolder}/node_modules/**/*.js' },
    -- },

    {
      name = 'Run server',
      -- command = 'npm run start -w @novata/server',
      request = 'launch',
      program = '${workspaceFolder}/node_modules/vitest/vitest.mjs',
      -- skipFiles = { '<node_internals>/**' },
      type = 'node-terminal',
    },
    -- {
    --   type = 'pwa-node',
    --   request = 'launch',
    --   name = 'Launch file',
    --   program = '${file}',
    --   cwd = '${workspaceFolder}',
    -- },
  }

  -- # Sign
  vim.fn.sign_define('DapBreakpoint', { text = '🟥', texthl = '', linehl = '', numhl = '' })
  vim.fn.sign_define('DapBreakpointCondition', { text = '🟧', texthl = '', linehl = '', numhl = '' })
  vim.fn.sign_define('DapLogPoint', { text = '🟩', texthl = '', linehl = '', numhl = '' })
  vim.fn.sign_define('DapStopped', { text = '🈁', texthl = '', linehl = '', numhl = '' })
  vim.fn.sign_define('DapBreakpointRejected', { text = '⬜', texthl = '', linehl = '', numhl = '' })

  -- # DAP Virtual Text
  dap_virtual_text.setup {
    enabled = true,
    enabled_commands = true,
    highlight_changed_variables = true,
    highlight_new_as_changed = false,
    show_stop_reason = true,
    commented = false,
    only_first_definition = true,
    all_references = false,
    filter_references_pattern = '<module',
    virt_text_pos = 'eol',
    all_frames = false,
    virt_lines = false,
    virt_text_win_col = nil,
  }

  -- # DAP UI
  dapui.setup {
    icons = { expanded = '▾', collapsed = '▸' },
    mappings = {
      expand = { '<CR>', '<2-LeftMouse>' },
      open = 'o',
      remove = 'd',
      edit = 'e',
      repl = 'r',
      toggle = 't',
    },
    expand_lines = vim.fn.has 'nvim-0.7',
    layouts = {
      {
        elements = {
          -- Elements can be strings or table with id and size keys.
          { id = 'scopes', size = 0.25 },
          'breakpoints',
          'stacks',
          'watches',
        },
        size = 40,
        position = 'right',
      },
      {
        elements = {
          { id = 'repl', size = 0.5 },
          { id = 'console', size = 0.5 },
        },
        size = 10,
        position = 'bottom',
      },
    },
    floating = {
      max_height = nil, -- These can be integers or a float between 0 and 1.
      max_width = nil, -- Floats will be treated as percentage of your screen.
      border = 'rounded', -- Border style. Can be "single", "double" or "rounded"
      mappings = {
        close = { 'q', '<Esc>' },
      },
    },
    windows = { indent = 1 },
    render = {
      max_type_length = nil,
    },
  }
  dap.listeners.after.event_initialized['dapui_config'] = function()
    vim.cmd 'tabfirst|tabnext'
    dapui.open()
  end
  -- dap.listeners.before.event_terminated["dapui_config"] = function()
  --   dapui.close()
  -- end
  -- dap.listeners.before.event_exited["dapui_config"] = function()
  --   dapui.close()
  -- end

  -- # Keymap
  -- local keymap = require('rin.utils.keymap').keymap

  vim.keymap.set('n', '<Leader>xi', dap.toggle_breakpoint)
  vim.keymap.set('n', '<Leader>xI', ':lua require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>')
  vim.keymap.set('n', '<Leader>xp', ':lua require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<CR>')
  vim.keymap.set('n', '<Leader>xs', ':lua require("dap").continue()<CR>')
  vim.keymap.set('n', '<Leader>xl', ':lua require("dap").run_to_cursor()<CR>')
  vim.keymap.set('n', '<Leader>xS', ':lua require("dap").disconnect()<CR>')
  vim.keymap.set('n', '<Leader>xn', ':lua require("dap").step_over()<CR>')
  vim.keymap.set('n', '<Leader>xN', ':lua require("dap").step_into()<CR>')
  vim.keymap.set('n', '<Leader>xo', ':lua require("dap").step_out()<CR>')

  vim.keymap.set('n', '<Leader>xww', ':lua require("dapui").toggle()<CR>')
  vim.keymap.set('n', '<Leader>xw[', ':lua require("dapui").toggle(1)<CR>')
  vim.keymap.set('n', '<Leader>xw]', ':lua require("dapui").toggle(2)<CR>')

  -- # DAP Config
  -- require 'rin.DAP.languages.python'
  require 'custom.typescript'
  -- require 'rin.DAP.languages.cpp'
  -- require 'rin.DAP.languages.go'

  -- ## DAP `launch.json`
  --   dap_ext_vscode.load_launchjs(nil, {
  --     ['python'] = {
  --       'python',
  --     },
  --     ['pwa-node'] = {
  --       'javascript',
  --       'typescript',
  --     },
  --     ['node'] = {
  --       'javascript',
  --       'typescript',
  --     },
  --     ['cppdbg'] = {
  --       'c',
  --       'cpp',
  --     },
  --     ['dlv'] = {
  --       'go',
  --     },
  --   })
end
--
return {
  'mfussenegger/nvim-dap',
  enabled = false,
  dependencies = {
    {
      'rcarriga/nvim-dap-ui',
      dependencies = {
        'nvim-neotest/nvim-nio',
      },
    },
    -- 'nvim-treesitter/nvim-treesitter',
    'theHamsta/nvim-dap-virtual-text',
    'mxsdev/nvim-dap-vscode-js',
  },
  event = 'VeryLazy',
  config = function()
    M.setup()
  end,
}
-- return {
--   'mfussenegger/nvim-dap',
--   dependencies = {
--     'mxsdev/nvim-dap-vscode-js',
--     -- build debugger from source
--     {
--       'microsoft/vscode-js-debug',
--       version = '1.x',
--       build = 'npm i && npm run compile vsDebugServerBundle && mv dist out',
--     },
--   },
--   keys = {
--     -- normal mode is default
--     {
--       '<leader>d',
--       function()
--         require('dap').toggle_breakpoint()
--       end,
--     },
--     {
--       '<leader>c',
--       function()
--         require('dap').continue()
--       end,
--     },
--     {
--       "<C-'>",
--       function()
--         require('dap').step_over()
--       end,
--     },
--     {
--       '<C-;>',
--       function()
--         require('dap').step_into()
--       end,
--     },
--     {
--       '<C-:>',
--       function()
--         require('dap').step_out()
--       end,
--     },
--   },
--   config = function()
--     -- https://www.reddit.com/r/neovim/comments/y7dvva/typescript_debugging_in_neovim_with_nvimdap/
--     -- setup adapters
--     require('dap-vscode-js').setup {
--       debugger_path = vim.fn.stdpath 'data' .. '/mason/packages/js-debug-adapter',
--       debugger_cmd = { 'js-debug-adapter' },
--       adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
--     }
--
--     -- https://theosteiner.de/debugging-javascript-frameworks-in-neovim
--     --   require('dap-vscode-js').setup {
--     --     debugger_path = vim.fn.stdpath 'data' .. '/lazy/vscode-js-debug',
--     --     adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
--     --   }
--     --
--     --   for _, language in ipairs { 'typescript', 'javascript', 'svelte' } do
--     --     require('dap').configurations[language] = {
--     --       -- attach to a node process that has been started with
--     --       -- `--inspect` for longrunning tasks or `--inspect-brk` for short tasks
--     --       -- npm script -> `node --inspect-brk ./node_modules/.bin/vite dev`
--     --       {
--     --         -- use nvim-dap-vscode-js's pwa-node debug adapter
--     --         type = 'pwa-node',
--     --         -- attach to an already running node process with --inspect flag
--     --         -- default port: 9222
--     --         request = 'attach',
--     --         -- allows us to pick the process using a picker
--     --         processId = require('dap.utils').pick_process,
--     --         -- name of the debug action you have to select for this config
--     --         name = 'Attach debugger to existing `node --inspect` process',
--     --         -- for compiled languages like TypeScript or Svelte.js
--     --         sourceMaps = true,
--     --         -- resolve source maps in nested locations while ignoring node_modules
--     --         resolveSourceMapLocations = {
--     --           '${workspaceFolder}/**',
--     --           '!**/node_modules/**',
--     --         },
--     --         -- path to src in vite based projects (and most other projects as well)
--     --         cwd = '${workspaceFolder}/src',
--     --         -- we don't want to debug code inside node_modules, so skip it!
--     --         skipFiles = { '${workspaceFolder}/node_modules/**/*.js' },
--     --       },
--     --       {
--     --         type = 'pwa-chrome',
--     --         name = 'Launch Chrome to debug client',
--     --         request = 'launch',
--     --         url = 'http://localhost:5173',
--     --         sourceMaps = true,
--     --         protocol = 'inspector',
--     --         port = 9222,
--     --         webRoot = '${workspaceFolder}/src',
--     --         -- skip files from vite's hmr
--     --         skipFiles = { '**/node_modules/**/*', '**/@vite/*', '**/src/client/*', '**/src/*' },
--     --       },
--     --       -- only if language is javascript, offer this debug action
--     --       language == 'javascript'
--     --           and {
--     --             -- use nvim-dap-vscode-js's pwa-node debug adapter
--     --             type = 'pwa-node',
--     --             -- launch a new process to attach the debugger to
--     --             request = 'launch',
--     --             -- name of the debug action you have to select for this config
--     --             name = 'Launch file in new node process',
--     --             -- launch current file
--     --             program = '${file}',
--     --             cwd = '${workspaceFolder}',
--     --           }
--     --         or nil,
--     --     }
--     --   end
--     --
--     --   require('dapui').setup()
--     --   local dap, dapui = require 'dap', require 'dapui'
--     --   dap.listeners.after.event_initialized['dapui_config'] = function()
--     --     dapui.open { reset = true }
--     --   end
--     --   dap.listeners.before.event_terminated['dapui_config'] = dapui.close
--     --   dap.listeners.before.event_exited['dapui_config'] = dapui.close
--   end,
-- }
-- -- return {
-- --   'mfussenegger/nvim-dap',
-- --   lazy = true,
-- --   dependencies = {
-- --     -- 'rcarriga/nvim-dap-ui',
-- --     'mxsdev/nvim-dap-vscode-js',
-- --     'nvim-neotest/nvim-nio',
-- --   },
-- --   keys = {
-- --     {
-- --       '<leader>xd',
-- --       function()
-- --         require('dap').toggle_breakpoint()
-- --       end,
-- --     },
-- --     {
-- --       '<leader>xc',
-- --       function()
-- --         require('dap').continue()
-- --       end,
-- --     },
-- --     -- {'<leader>dr', function() require 'dap'.repl.toggle() end},
-- --     {
-- --       '<leader>xs',
-- --       function()
-- --         require('dap').step_over()
-- --       end,
-- --     },
-- --     {
-- --       '<leader>xi',
-- --       function()
-- --         require('dap').step_into()
-- --       end,
-- --     },
-- --     {
-- --       '<leader>xo',
-- --       function()
-- --         require('dap').step_out()
-- --       end,
-- --     },
-- --     {
-- --       '<leader>xu',
-- --       function()
-- --         require('dap').up()
-- --       end,
-- --     },
-- --     {
-- --       '<leader>xd',
-- --       function()
-- --         require('dap').down()
-- --       end,
-- --     },
-- --     {
-- --       '<leader>xl',
-- --       function()
-- --         require('dap').run_last()
-- --       end,
-- --     },
-- --   },
-- --
-- --   config = function()
-- --     require('dap-vscode-js').setup {
-- --       debugger_path = vim.fn.stdpath 'data' .. '/mason/bin/js-debug-adapter',
-- --       debugger_cmd = { 'js-debug-adapter' },
-- --       adapters = { 'node', 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
-- --     }
-- --
-- --     local dap = require 'dap'
-- --     dap.configurations.typescript = {
-- --       {
-- --         type = 'pwa-node',
-- --         request = 'launch',
-- --         name = 'Launch Test Program (pwa-node with vitest)',
-- --         cwd = '${workspaceFolder}',
-- --         program = '${workspaceFolder}/node_modules/vitest/vitest.mjs',
-- --         args = { '--threads', 'false' },
-- --         autoAttachChildProcesses = false,
-- --         trace = true,
-- --         console = 'integratedTerminal',
-- --         sourceMaps = true,
-- --         smartStep = true,
-- --       },
-- --     }
-- --     -- for _, language in ipairs { 'typescript', 'javascript', 'svelte' } do
-- --     --   dap.configurations[language] = {
-- --     --     -- attach to a node process that has been started with
-- --     --     -- `--inspect` for longrunning tasks or `--inspect-brk` for short tasks
-- --     --     -- npm script -> `node --inspect-brk ./node_modules/.bin/vite dev`
-- --     --     {
-- --     --       -- use nvim-dap-vscode-js's pwa-node debug adapter
-- --     --       type = 'pwa-node',
-- --     --       -- attach to an already running node process with --inspect flag
-- --     --       -- default port: 9222
-- --     --       request = 'attach',
-- --     --       -- allows us to pick the process using a picker
-- --     --       processId = require('dap.utils').pick_process,
-- --     --       -- name of the debug action you have to select for this config
-- --     --       name = 'Attach debugger to existing `node --inspect` process',
-- --     --       -- for compiled languages like TypeScript or Svelte.js
-- --     --       sourceMaps = true,
-- --     --       -- resolve source maps in nested locations while ignoring node_modules
-- --     --       resolveSourceMapLocations = {
-- --     --         '${workspaceFolder}/**',
-- --     --         '!**/node_modules/**',
-- --     --       },
-- --     --       -- path to src in vite based projects (and most other projects as well)
-- --     --       cwd = '${workspaceFolder}/src',
-- --     --       -- we don't want to debug code inside node_modules, so skip it!
-- --     --       skipFiles = { '${workspaceFolder}/node_modules/**/*.js' },
-- --     --     },
-- --     --     {
-- --     --       type = 'pwa-chrome',
-- --     --       name = 'Launch Chrome to debug client',
-- --     --       request = 'launch',
-- --     --       url = 'http://localhost:5173',
-- --     --       sourceMaps = true,
-- --     --       protocol = 'inspector',
-- --     --       port = 9222,
-- --     --       webRoot = '${workspaceFolder}/src',
-- --     --       -- skip files from vite's hmr
-- --     --       skipFiles = { '**/node_modules/**/*', '**/@vite/*', '**/src/client/*', '**/src/*' },
-- --     --     },
-- --     --     -- only if language is javascript, offer this debug action
-- --     --     language == 'javascript'
-- --     --         and {
-- --     --           -- use nvim-dap-vscode-js's pwa-node debug adapter
-- --     --           type = 'pwa-node',
-- --     --           -- launch a new process to attach the debugger to
-- --     --           request = 'launch',
-- --     --           -- name of the debug action you have to select for this config
-- --     --           name = 'Launch file in new node process',
-- --     --           -- launch current file
-- --     --           program = '${file}',
-- --     --           cwd = '${workspaceFolder}',
-- --     --         }
-- --     --       or nil,
-- --     --   }
-- --     -- end
-- --     -- dap.configurations.typescript = {
-- --     --   -- {
-- --     --   --   name = 'Run server',
-- --     --   --   command = 'npm run start -w @novata/server',
-- --     --   --   request = 'launch',
-- --     --   --   skipFiles = { '<node_internals>/**' },
-- --     --   --   type = 'node-terminal',
-- --     --   -- },
-- --     --   {
-- --     --     name = 'Attach to existing server',
-- --     --     type = 'node-terminal',
-- --     --     request = 'attach',
-- --     --     processId = require('dap.utils').pick_process,
-- --     --     sourceMaps = true,
-- --     --   },
-- --     -- }
-- --
-- --     -- require('dapui').setup()
-- --     -- local dapui = require 'dapui'
-- --     -- dap.listeners.after.event_initialized['dapui_config'] = function()
-- --     --   dapui.open { reset = true }
-- --     -- end
-- --     -- dap.listeners.before.event_terminated['dapui_config'] = dapui.close
-- --     -- dap.listeners.before.event_exited['dapui_config'] = dapui.close
-- --   end,
-- -- }
