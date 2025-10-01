return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",
    delay = 300, -- Time in ms before which-key popup appears
    win = {
      -- Centered window configuration
      border = "rounded",
      position = "bottom", -- Position at bottom for better centering
      padding = { 1, 2 }, -- Vertical, horizontal padding
      wo = {
        winblend = 0, -- Transparency (0 = opaque)
      },
    },
    layout = {
      width = { min = 20, max = 50 }, -- Width constraints
      spacing = 3, -- Spacing between columns
      align = "center", -- Center align the content
    },
    show_help = true,
    show_keys = true,
    triggers = {
      { "<leader>", mode = { "n", "v" } },
      { ";", mode = { "n", "v" } },
      { "g", mode = { "n", "v" } },
      { "z", mode = { "n", "v" } },
      { "[", mode = { "n", "v" } },
      { "]", mode = { "n", "v" } },
    },
    spec = {
      {
        mode = { "n", "v" },
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>f", group = "file/find" },
        { "<leader>g", group = "git" },
        { "<leader>o", group = "obsidian" },
        { "<leader>p", group = "plugins" },
        { "<leader>q", group = "quit/session" },
        { "<leader>s", group = "search" },
        { "<leader>S", group = "session" },
        { "<leader>T", group = "tasks" },
        { "<leader>u", group = "ui" },
        { "<leader>w", group = "windows" },
        { "<leader>x", group = "diagnostics/quickfix" },
        { "<leader><tab>", group = "tabs" },
        { "[", group = "prev" },
        { "]", group = "next" },
        { "g", group = "goto" },
        { "z", group = "fold" },
        { ";", group = "quick actions" },
      },
    },
  },
}
