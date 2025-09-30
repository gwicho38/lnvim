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
          
          -- Custom shortcuts
          { icon = "󱞁 ", key = "z", desc = "Zettelkasten Notes", action = function()
            -- Create notes directory if it doesn't exist
            local notes_dir = vim.fn.expand("~/notes")
            if vim.fn.isdirectory(notes_dir) == 0 then
              vim.fn.mkdir(notes_dir, "p")
            end
            
            -- Open telescope file picker in notes directory
            require('telescope.builtin').find_files({
              prompt_title = "🧠 Zettelkasten Notes",
              cwd = notes_dir,
              find_command = { "find", notes_dir, "-type", "f", "-name", "*.md" },
              attach_mappings = function(prompt_bufnr, map)
                local actions = require('telescope.actions')
                local action_state = require('telescope.actions.state')
                
                -- Create new note with Ctrl+n
                map('i', '<C-n>', function()
                  actions.close(prompt_bufnr)
                  local note_name = vim.fn.input("Note name: ")
                  if note_name ~= "" then
                    local note_file = notes_dir .. "/" .. note_name .. ".md"
                    vim.cmd("edit " .. note_file)
                    -- Add basic template
                    vim.api.nvim_buf_set_lines(0, 0, -1, false, {
                      "# " .. note_name,
                      "",
                      "Created: " .. os.date("%Y-%m-%d %H:%M"),
                      "",
                      "## Tags",
                      "",
                      "## Content",
                      "",
                    })
                  end
                end)
                
                return true
              end,
            })
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
        { section = "startup" },
      },
    },
  },
}