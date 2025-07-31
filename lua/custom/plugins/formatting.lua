return {
  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
      notify_on_error = true,
      default_format_opts = {
        lsp_format = 'fallback',
      },
      format_on_save = {
        timeout_ms = 500,
      },
      format_after_save = {
        timeout_ms = 2500,
      },

      formatters_by_ft = {
        lua = { 'stylua' },
        typescript = { 'prettierd', stop_after_first = false },
        typescriptreact = { 'prettierd', stop_after_first = false },
        javascript = { 'prettierd', 'prettier', stop_after_first = false },
        javascriptreact = { 'prettierd', 'prettier', stop_after_first = false },
        sql = { 'sql_formatter' },
      },
    },
  },
}
