-- Colorscheme configuration with persistence

return {
  -- Gruvbox (warm, retro theme)
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("gruvbox").setup({
        undercurl = true,
        underline = true,
        bold = true,
        italic = {
          strings = true,
          comments = true,
          operators = false,
          folds = true,
        },
        contrast = "hard", -- "hard", "soft" or "" (normal)
        palette_overrides = {
          dark0_hard = "#1d2021",
        },
      })
    end,
  },

  -- TokyoNight (modern, vibrant theme)
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night", -- "storm", "moon", "night", "day"
        transparent = false,
        styles = {
          sidebars = "dark",
          floats = "dark",
        },
      })
    end,
  },

  -- Catppuccin (pastel, soothing theme)
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- "latte", "frappe", "macchiato", "mocha"
        transparent_background = false,
        integrations = {
          telescope = true,
          nvimtree = true,
          which_key = true,
          mason = true,
        },
      })
    end,
  },

  -- Theme persistence and management
  {
    "nvim-lua/plenary.nvim",
    config = function()
      local theme_persistence = require("config.theme-persistence")

      -- Load saved theme on startup
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          local saved_theme = theme_persistence.load_theme()

          if saved_theme then
            -- Apply saved theme with delay to ensure plugins are loaded
            vim.defer_fn(function()
              pcall(vim.cmd.colorscheme, saved_theme)
            end, 100)
          else
            -- Default theme if none saved
            vim.defer_fn(function()
              vim.cmd.colorscheme("gruvbox")
              theme_persistence.save_theme("gruvbox")
            end, 100)
          end
        end,
      })

      -- Auto-save any colorscheme change (works with LazyVim's picker too!)
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          local current_theme = vim.g.colors_name
          if current_theme then
            theme_persistence.save_theme(current_theme)
          end
        end,
      })

      -- Create commands
      vim.api.nvim_create_user_command("ThemeSelect", function()
        theme_persistence.theme_picker()
      end, { desc = "Select and save theme" })

      vim.api.nvim_create_user_command("ThemeSet", function(opts)
        theme_persistence.set_theme(opts.args)
      end, { nargs = 1, desc = "Set and save theme" })
    end,
    keys = {
      { "<leader>ut", "<cmd>ThemeSelect<cr>", desc = "Select Theme" },
    },
  },
}
