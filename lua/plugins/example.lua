-- Example plugin configuration
-- This file demonstrates common plugin configuration patterns
-- Remove this file or set enabled = false if you don't need it

-- stylua: ignore
if true then return {} end  -- Disabled by default

return {
  -- Example: Add a new plugin
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    },
  },

  -- Example: Override LazyVim plugin configuration
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
      },
    },
  },

  -- Example: Disable a plugin
  { "folke/noice.nvim", enabled = false },

  -- Example: Add Mason tools
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "shfmt",
      },
    },
  },
}
