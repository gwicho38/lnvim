return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = function(_, opts)
    -- Merge with LazyVim defaults instead of replacing
    opts = opts or {}

    -- Override window configuration
    opts.win = vim.tbl_deep_extend("force", opts.win or {}, {
      border = "rounded",
      position = "bottom",
      padding = { 1, 2 },
      wo = {
        winblend = 0,
      },
    })

    -- Override layout
    opts.layout = vim.tbl_deep_extend("force", opts.layout or {}, {
      width = { min = 20, max = 50 },
      spacing = 3,
      align = "center",
    })

    -- Set delay
    opts.delay = 200 -- Reduced to 200ms for faster response

    -- Add our custom groups (don't duplicate LazyVim's)
    opts.spec = opts.spec or {}

    -- Add only our custom groups that LazyVim doesn't define
    vim.list_extend(opts.spec, {
      { "<leader>o", group = "obsidian", mode = { "n", "v" } },
      { "<leader>p", group = "plugins", mode = { "n", "v" } },
      { "<leader>S", group = "session", mode = { "n", "v" } },
      { "<leader>T", group = "tasks", mode = { "n", "v" } },
      { ";", group = "quick actions", mode = { "n", "v" } },
    })

    return opts
  end,
}
