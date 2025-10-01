return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- Ensure these parsers are installed
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "dart", -- Flutter/Dart
        "lua",
        "vim",
        "vimdoc",
        "query",
        "markdown",
        "markdown_inline",
        "bash",
        "python",
        "javascript",
        "typescript",
        "tsx",
        "json",
        "yaml",
        "toml",
        "rust",
        "go",
        "c",
        "cpp",
        "html",
        "css",
        "sql",
      })

      -- Enable highlight and indent for Dart
      opts.highlight = opts.highlight or {}
      opts.highlight.enable = true
      opts.highlight.additional_vim_regex_highlighting = false

      opts.indent = opts.indent or {}
      opts.indent.enable = true

      return opts
    end,
  },
}
