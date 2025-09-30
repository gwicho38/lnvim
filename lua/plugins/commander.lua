return {
  "FeiyouG/commander.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  keys = {
    {
      "<C-S-P>", -- Ctrl+Shift+P 
      function() require("commander").show() end,
      desc = "Open Command Palette",
    },
    {
      "<leader>cp", -- Space + c + p as alternative
      function() require("commander").show() end,
      desc = "Open Command Palette",
    },
  },
  config = function()
    local commander = require("commander")
    
    commander.setup({
      components = {
        "DESC",
        "KEYS",
        "CAT",
      },
      sort_by = {
        "DESC",
        "KEYS",
        "CAT",
        "CMD"
      },
      integration = {
        telescope = {
          enable = true,
          -- Theme for telescope
          theme = "commander",
        },
        lazy = {
          enable = true,
          set_plugin_name_as_cat = true,
        }
      }
    })

    -- Add commander-specific commands (avoid duplicating keymaps.lua)
    -- Focus on commands that benefit from discoverability
    commander.add({
      {
        desc = "Hawtkeys: Find Duplicate Keybindings",
        cmd = "<cmd>HawtkeysDupes<cr>",
        cat = "tools"
      },
      {
        desc = "Hawtkeys: Show All Keybindings",
        cmd = "<cmd>Hawtkeys<cr>",
        cat = "tools"
      },
      {
        desc = "Mason: Package Manager",
        cmd = "<cmd>Mason<cr>",
        cat = "tools"
      },
      {
        desc = "Copilot: Toggle Enable/Disable",
        cmd = function()
          vim.cmd("Copilot toggle")
        end,
        cat = "ai"
      },
      {
        desc = "Copilot: Status",
        cmd = "<cmd>Copilot status<cr>",
        cat = "ai"
      },
      {
        desc = "Gen: AI Generate",
        cmd = "<cmd>Gen<cr>",
        cat = "ai"
      },
      {
        desc = "Telescope: Browse Plugins",
        cmd = "<cmd>Telescope lazy<cr>",
        cat = "tools"
      },
      {
        desc = "Telescope: Import Navigation",
        cmd = "<cmd>Telescope import<cr>",
        cat = "navigation"
      },
      {
        desc = "Transfer: Init SFTP Config",
        cmd = "<cmd>TransferInit<cr>",
        cat = "remote"
      },
      {
        desc = "Distant: Connect to Remote",
        cmd = "<cmd>DistantConnect<cr>",
        cat = "remote"
      },
      {
        desc = "Hot: Restart Runner",
        cmd = function() require("hot").restart() end,
        cat = "dev"
      },
      {
        desc = "Hot: Run Tests",
        cmd = function() require("hot").test_restart() end,
        cat = "dev"
      },
    })
  end,
}
