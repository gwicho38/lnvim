return {
  "williamboman/mason.nvim",
  opts = {
    ensure_installed = {
      -- Formatters
      "stylua", -- Lua formatter
      "prettier", -- JS/TS/JSON/YAML/Markdown formatter
      "black", -- Python formatter
      "isort", -- Python import sorter
      "shfmt", -- Shell script formatter

      -- Linters
      "shellcheck", -- Shell script linter
      "flake8", -- Python linter
      "eslint_d", -- Fast ESLint daemon

      -- LSP servers (optional, LazyVim handles most)
      "lua-language-server",
      "typescript-language-server",
      "pyright",
      "rust-analyzer",
      "gopls",

      -- DAP (Debug Adapter Protocol)
      "codelldb", -- Rust/C++ debugger
    },
  },
}
