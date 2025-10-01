return {
  "folke/snacks.nvim",
  opts = {
    dashboard = {
      preset = {
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = " ", key = "s", desc = "Restore Session", section = "session" },
          { icon = " ", key = "S", desc = "Load Named Session", action = ":SessionManager load_session<cr>" },

          -- Custom shortcuts
          { icon = " ", key = "o", desc = "Obsidian Notes", action = function()
            -- Load obsidian plugin and open vault search
            require("lazy").load({ plugins = { "obsidian.nvim" } })
            vim.cmd("ObsidianSearch")
          end },
          { icon = " ", key = "t", desc = "Today's Note", action = function()
            -- Load obsidian plugin and open today's note
            require("lazy").load({ plugins = { "obsidian.nvim" } })
            vim.cmd("ObsidianToday")
          end },

          { icon = "󰏖 ", key = "p", desc = "Browse Plugins", action = function()
            -- Open telescope to browse available plugins
            local pickers = require('telescope.pickers')
            local finders = require('telescope.finders')
            local conf = require('telescope.config').values
            local actions = require('telescope.actions')
            local action_state = require('telescope.actions.state')
            
            -- Popular Neovim plugins list
            local plugins = {
              { name = "nvim-treesitter/nvim-treesitter", desc = "Treesitter configurations and abstraction layer" },
              { name = "neovim/nvim-lspconfig", desc = "Quickstart configs for Nvim LSP" },
              { name = "hrsh7th/nvim-cmp", desc = "A completion plugin for neovim" },
              { name = "nvim-telescope/telescope.nvim", desc = "Find, Filter, Preview, Pick. All lua, all the time." },
              { name = "folke/lazy.nvim", desc = "💤 A modern plugin manager for Neovim" },
              { name = "lewis6991/gitsigns.nvim", desc = "Git integration for buffers" },
              { name = "nvim-lualine/lualine.nvim", desc = "blazing fast and easy to configure statusline" },
              { name = "folke/which-key.nvim", desc = "💥 Create key bindings that stick" },
              { name = "kyazdani42/nvim-web-devicons", desc = "lua fork of vim-web-devicons" },
              { name = "folke/trouble.nvim", desc = "🚦 A pretty diagnostics list" },
              { name = "windwp/nvim-autopairs", desc = "autopairs for neovim written by lua" },
              { name = "numToStr/Comment.nvim", desc = "🧠 Smart and Powerful commenting plugin" },
              { name = "akinsho/bufferline.nvim", desc = "A snazzy bufferline for Neovim" },
              { name = "lukas-reineke/indent-blankline.nvim", desc = "Indent guides for Neovim" },
              { name = "folke/tokyonight.nvim", desc = "🏙  A clean, dark Neovim theme" },
              { name = "catppuccin/nvim", desc = "🍨 Soothing pastel theme for (Neo)vim" },
              { name = "nvim-neo-tree/neo-tree.nvim", desc = "Neovim plugin to manage the file system" },
              { name = "folke/noice.nvim", desc = "💥 Highly experimental plugin that replaces the UI" },
              { name = "rcarriga/nvim-notify", desc = "A fancy, configurable notification manager" },
              { name = "stevearc/conform.nvim", desc = "Lightweight yet powerful formatter plugin" },
              { name = "mfussenegger/nvim-lint", desc = "An asynchronous linter plugin" },
              { name = "folke/zen-mode.nvim", desc = "🧘  Distraction-free coding for Neovim" },
              { name = "tpope/vim-surround", desc = "quoting/parenthesizing made simple" },
              { name = "ggandor/leap.nvim", desc = "Neovim's answer to the mouse 🦘" },
              { name = "ThePrimeagen/harpoon", desc = "Getting you where you want with the fewest keystrokes" },
            }
            
            pickers.new({}, {
              prompt_title = "🔍 Browse Neovim Plugins",
              finder = finders.new_table {
                results = plugins,
                entry_maker = function(entry)
                  return {
                    value = entry,
                    display = entry.name .. " - " .. entry.desc,
                    ordinal = entry.name .. " " .. entry.desc,
                  }
                end,
              },
              sorter = conf.generic_sorter({}),
              attach_mappings = function(prompt_bufnr, map)
                actions.select_default:replace(function()
                  actions.close(prompt_bufnr)
                  local selection = action_state.get_selected_entry()
                  local plugin = selection.value
                  
                  -- Open GitHub page for the plugin
                  local url = "https://github.com/" .. plugin.name
                  vim.fn.system("open " .. url) -- macOS
                  
                  -- Also show info
                  vim.notify("Opening: " .. plugin.name .. "\n" .. plugin.desc, vim.log.levels.INFO)
                end)
                
                -- Add plugin to config with Enter
                map('i', '<C-a>', function()
                  actions.close(prompt_bufnr)
                  local selection = action_state.get_selected_entry()
                  local plugin = selection.value
                  
                  -- Create a new plugin file
                  local plugin_name = plugin.name:match("([^/]+)$")
                  local plugin_file = vim.fn.stdpath('config') .. "/lua/plugins/" .. plugin_name .. ".lua"
                  
                  vim.cmd("edit " .. plugin_file)
                  vim.api.nvim_buf_set_lines(0, 0, -1, false, {
                    'return {',
                    '  "' .. plugin.name .. '",',
                    '  -- ' .. plugin.desc,
                    '  config = function()',
                    '    -- Add your configuration here',
                    '  end,',
                    '}',
                  })
                end)
                
                return true
              end,
            }):find()
          end },
          
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
        header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
        ]],
      },
      sections = {
        { section = "header" },
        { section = "keys", gap = 1, padding = 1 },
        {
          section = "recent_files",
          title = "Recent Files",
          limit = 8,
          padding = 1,
          cwd = true,
        },
        {
          section = "projects",
          title = "Recent Projects",
          limit = 5,
          padding = 1,
        },
        { section = "startup" },
      },
    },
  },
}