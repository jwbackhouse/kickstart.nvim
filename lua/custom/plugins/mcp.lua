return {
  {
    'ravitemer/mcphub.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    build = 'npm install -g mcp-hub@latest',
    config = function()
      require('mcphub').setup {
        port = 3010,
        shutdown_delay = 10,
        config = vim.fn.expand '~/.config/nvim/mcp/mcpservers.json', -- Absolute path required
        auto_approve = true,
        extensions = {
          codecompanion = {
            show_result_in_chat = true,
            make_vars = true, -- Create chat variables from resources
            make_slash_commands = true, -- Create slash commands from MCP server prompts
          },
        },
        log = {
          level = vim.log.levels.WARN, -- DEBUG, INFO, WARN, ERROR
          to_file = true, -- Creates ~/.local/state/nvim/mcphub.log
        },
        on_ready = function()
          vim.notify 'MCP Hub is online!'
        end,
      }
    end,
  },
}
