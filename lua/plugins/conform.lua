return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      python = { "isort", "black" },
      lua = { "stylua" },
      javascript = { "prettier" },
      typescript = { "prettier" },
      json = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
      sh = { "shfmt" },
    },
  },
}
