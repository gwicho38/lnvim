-- Plugin Management System
-- Provides interactive GitHub plugin search, installation, and management

return {
  -- Add telescope for UI
  {
    "nvim-telescope/telescope.nvim",
    optional = true,
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  -- Add curl for HTTP requests (if not available)
  {
    "nvim-lua/plenary.nvim",
    config = function()
      -- Plugin Manager Module
      local M = {}
      local telescope = require("telescope.builtin")
      local pickers = require("telescope.pickers")
      local finders = require("telescope.finders")
      local conf = require("telescope.config").values
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")
      local Job = require("plenary.job")
      local Path = require("plenary.path")

      -- Configuration
      M.config = {
        plugins_dir = vim.fn.stdpath("data") .. "/lazy",
        user_plugins_file = vim.fn.stdpath("config") .. "/lua/plugins/user-installed.lua",
        github_api_url = "https://api.github.com",
        search_limit = 50,
      }

      -- Utility functions
      local function notify(msg, level)
        vim.notify("[Plugin Manager] " .. msg, level or vim.log.levels.INFO)
      end

      local function file_exists(path)
        return Path:new(path):exists()
      end

      local function read_file(path)
        if not file_exists(path) then
          return nil
        end
        local file = io.open(path, "r")
        if not file then
          return nil
        end
        local content = file:read("*all")
        file:close()
        return content
      end

      local function write_file(path, content)
        local file = io.open(path, "w")
        if not file then
          return false
        end
        file:write(content)
        file:close()
        return true
      end

      -- GitHub API functions
      function M.search_github_plugins(query, callback)
        local search_query = query .. " neovim plugin language:lua"
        local url = string.format("%s/search/repositories?q=%s&sort=stars&order=desc&per_page=%d", 
          M.config.github_api_url, vim.fn.shellescape(search_query), M.config.search_limit)

        Job:new({
          command = "curl",
          args = {
            "-s",
            "-H", "Accept: application/vnd.github.v3+json",
            url,
          },
          on_exit = function(j, return_val)
            if return_val == 0 then
              local success, result = pcall(vim.fn.json_decode, table.concat(j:result(), ""))
              if success and result.items then
                callback(result.items)
              else
                callback({})
                notify("Failed to parse GitHub search results", vim.log.levels.ERROR)
              end
            else
              callback({})
              notify("Failed to search GitHub: " .. table.concat(j:stderr_result(), " "), vim.log.levels.ERROR)
            end
          end,
        }):start()
      end

      function M.get_repo_info(owner, repo, callback)
        local url = string.format("%s/repos/%s/%s", M.config.github_api_url, owner, repo)
        
        Job:new({
          command = "curl",
          args = {
            "-s",
            "-H", "Accept: application/vnd.github.v3+json",
            url,
          },
          on_exit = function(j, return_val)
            if return_val == 0 then
              local success, result = pcall(vim.fn.json_decode, table.concat(j:result(), ""))
              if success then
                callback(result)
              else
                callback(nil)
                notify("Failed to parse repository info", vim.log.levels.ERROR)
              end
            else
              callback(nil)
              notify("Failed to get repository info", vim.log.levels.ERROR)
            end
          end,
        }):start()
      end

      -- Plugin management functions
      function M.get_installed_plugins()
        local lazy_ok, lazy = pcall(require, "lazy")
        if not lazy_ok then
          return {}
        end

        local plugins = {}
        local ok, lazy_plugins = pcall(lazy.plugins)
        if not ok or type(lazy_plugins) ~= "table" then
          return plugins
        end
        for name, plugin in pairs(lazy_plugins) do
          table.insert(plugins, {
            name = name,
            url = plugin.url or "",
            dir = plugin.dir or "",
            enabled = not plugin._.disabled,
          })
        end
        return plugins
      end

      function M.is_plugin_installed(repo_name)
        local plugins = M.get_installed_plugins()
        for _, plugin in ipairs(plugins) do
          if plugin.name == repo_name or plugin.url:match(repo_name) then
            return true
          end
        end
        return false
      end

      function M.create_user_plugins_file()
        if not file_exists(M.config.user_plugins_file) then
          local content = [[-- User installed plugins via Plugin Manager
-- This file is automatically managed by the Plugin Manager

return {
  -- Add your manually installed plugins here
}
]]
          write_file(M.config.user_plugins_file, content)
        end
      end

      function M.add_plugin_to_config(repo_full_name, plugin_config)
        M.create_user_plugins_file()
        
        local content = read_file(M.config.user_plugins_file)
        if not content then
          notify("Failed to read user plugins file", vim.log.levels.ERROR)
          return false
        end

        -- Simple approach: append before the closing brace
        local plugin_entry = string.format('  { "%s"%s },\n}', 
          repo_full_name, 
          plugin_config and (", " .. plugin_config) or ""
        )
        
        content = content:gsub("}", plugin_entry)
        
        if write_file(M.config.user_plugins_file, content) then
          notify("Plugin added to configuration: " .. repo_full_name)
          return true
        else
          notify("Failed to write plugin configuration", vim.log.levels.ERROR)
          return false
        end
      end

      function M.install_plugin(repo_full_name, plugin_config)
        if M.is_plugin_installed(repo_full_name:match("([^/]+)$")) then
          notify("Plugin already installed: " .. repo_full_name, vim.log.levels.WARN)
          return
        end

        if M.add_plugin_to_config(repo_full_name, plugin_config) then
          -- Reload lazy.nvim configuration
          vim.schedule(function()
            local lazy_ok, lazy = pcall(require, "lazy")
            if lazy_ok then
              lazy.reload()
              notify("Plugin installed successfully: " .. repo_full_name)
              notify("Restart Neovim or run :Lazy sync to complete installation")
            else
              notify("Failed to reload Lazy configuration", vim.log.levels.ERROR)
            end
          end)
        end
      end

      function M.remove_plugin(plugin_name)
        local content = read_file(M.config.user_plugins_file)
        if not content then
          notify("Failed to read user plugins file", vim.log.levels.ERROR)
          return false
        end

        -- Remove plugin line (simple pattern matching)
        local pattern = string.format('  { "%s"[^}]*},?\n', plugin_name:gsub("%-", "%%-"))
        local new_content = content:gsub(pattern, "")
        
        if new_content ~= content then
          if write_file(M.config.user_plugins_file, new_content) then
            notify("Plugin removed from configuration: " .. plugin_name)
            notify("Run :Lazy clean to remove plugin files")
            return true
          end
        else
          notify("Plugin not found in user configuration: " .. plugin_name, vim.log.levels.WARN)
        end
        
        return false
      end

      -- UI functions
      function M.show_plugin_search()
        vim.ui.input({ prompt = "Search GitHub plugins: " }, function(query)
          if not query or query == "" then
            return
          end

          notify("Searching GitHub for: " .. query)
          
          M.search_github_plugins(query, function(repos)
            if #repos == 0 then
              notify("No plugins found for: " .. query, vim.log.levels.WARN)
              return
            end

            local items = {}
            for _, repo in ipairs(repos) do
              table.insert(items, {
                repo = repo,
                display = string.format("%s ⭐%d - %s", 
                  repo.full_name, 
                  repo.stargazers_count, 
                  repo.description or "No description"
                ),
              })
            end

            pickers.new({}, {
              prompt_title = "GitHub Neovim Plugins - " .. query,
              finder = finders.new_table({
                results = items,
                entry_maker = function(entry)
                  return {
                    value = entry,
                    display = entry.display,
                    ordinal = entry.repo.full_name,
                  }
                end,
              }),
              sorter = conf.generic_sorter({}),
              attach_mappings = function(prompt_bufnr, map)
                actions.select_default:replace(function()
                  local selection = action_state.get_selected_entry()
                  actions.close(prompt_bufnr)
                  
                  if selection then
                    M.show_plugin_details(selection.value.repo)
                  end
                end)
                return true
              end,
            }):find()
          end)
        end)
      end

      function M.show_plugin_details(repo)
        local info_lines = {
          "Repository: " .. repo.full_name,
          "Stars: " .. repo.stargazers_count,
          "Language: " .. (repo.language or "Unknown"),
          "Updated: " .. repo.updated_at,
          "",
          "Description:",
          repo.description or "No description available",
          "",
        }

        if repo.homepage and repo.homepage ~= "" then
          table.insert(info_lines, "Homepage: " .. repo.homepage)
          table.insert(info_lines, "")
        end

        local is_installed = M.is_plugin_installed(repo.name)
        if is_installed then
          table.insert(info_lines, "✅ Plugin is already installed")
        else
          table.insert(info_lines, "📦 Plugin is not installed")
        end

        table.insert(info_lines, "")
        table.insert(info_lines, "Actions:")
        if not is_installed then
          table.insert(info_lines, "  <Enter> - Install plugin")
          table.insert(info_lines, "  <C-c>   - Configure and install")
        end
        table.insert(info_lines, "  <C-o>   - Open in browser")
        table.insert(info_lines, "  <Esc>   - Close")

        -- Create a buffer with the information
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, info_lines)
        vim.api.nvim_buf_set_option(buf, "modifiable", false)
        vim.api.nvim_buf_set_option(buf, "buftype", "nofile")

        -- Create a floating window
        local width = 80
        local height = #info_lines + 2
        local win = vim.api.nvim_open_win(buf, true, {
          relative = "editor",
          width = width,
          height = height,
          col = (vim.o.columns - width) / 2,
          row = (vim.o.lines - height) / 2,
          style = "minimal",
          border = "rounded",
          title = " Plugin Details ",
          title_pos = "center",
        })

        -- Set keymaps for the floating window
        local opts = { buffer = buf, nowait = true }
        
        if not is_installed then
          vim.keymap.set("n", "<CR>", function()
            vim.api.nvim_win_close(win, true)
            M.install_plugin(repo.full_name)
          end, opts)
          
          vim.keymap.set("n", "<C-c>", function()
            vim.api.nvim_win_close(win, true)
            M.configure_and_install_plugin(repo)
          end, opts)
        end
        
        local function get_open_cmd()
          local os_name = (jit and jit.os:lower()) or (vim.loop and vim.loop.os_uname().sysname:lower()) or ""
          if os_name:find("windows") then
            return "start"
          elseif os_name:find("darwin") or os_name:find("mac") then
            return "open"
          else
            return "xdg-open"
          end
        end

        vim.keymap.set("n", "<C-o>", function()
          local open_cmd = get_open_cmd()
          vim.fn.system(open_cmd .. " " .. repo.html_url)
        end, opts)

        vim.keymap.set("n", "<Esc>", function()
          vim.api.nvim_win_close(win, true)
        end, opts)
        
        vim.keymap.set("n", "q", function()
          vim.api.nvim_win_close(win, true)
        end, opts)
      end

      function M.configure_and_install_plugin(repo)
        vim.ui.input({ 
          prompt = "Plugin configuration (optional, e.g., 'config = function() ... end'): " 
        }, function(config)
          M.install_plugin(repo.full_name, config)
        end)
      end

      function M.show_installed_plugins()
        local plugins = M.get_installed_plugins()
        
        if #plugins == 0 then
          notify("No plugins installed", vim.log.levels.WARN)
          return
        end

        pickers.new({}, {
          prompt_title = "Installed Plugins",
          finder = finders.new_table({
            results = plugins,
            entry_maker = function(plugin)
              local status = plugin.enabled and "✅" or "❌"
              return {
                value = plugin,
                display = string.format("%s %s - %s", status, plugin.name, plugin.url),
                ordinal = plugin.name,
              }
            end,
          }),
          sorter = conf.generic_sorter({}),
          attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
              local selection = action_state.get_selected_entry()
              actions.close(prompt_bufnr)
              
              if selection then
                M.show_installed_plugin_actions(selection.value)
              end
            end)
            return true
          end,
        }):find()
      end

      function M.show_installed_plugin_actions(plugin)
        local choices = {
          "Update plugin",
          "Remove plugin",
          "Toggle enable/disable",
          "Open plugin directory",
        }

        vim.ui.select(choices, {
          prompt = "Action for " .. plugin.name .. ":",
        }, function(choice)
          if choice == "Update plugin" then
            M.update_plugin(plugin.name)
          elseif choice == "Remove plugin" then
            M.remove_plugin(plugin.name)
          elseif choice == "Toggle enable/disable" then
            M.toggle_plugin(plugin.name)
          elseif choice == "Open plugin directory" then
            if plugin.dir and plugin.dir ~= "" then
              vim.cmd("edit " .. plugin.dir)
            else
              notify("Plugin directory not found", vim.log.levels.WARN)
            end
          end
        end)
      end

      function M.update_plugin(plugin_name)
        local lazy_ok, lazy = pcall(require, "lazy")
        if lazy_ok then
          lazy.update({ plugins = { plugin_name } })
          notify("Updating plugin: " .. plugin_name)
        else
          notify("Lazy.nvim not available", vim.log.levels.ERROR)
        end
      end

      function M.toggle_plugin(plugin_name)
        notify("Plugin toggle functionality requires manual editing of plugin configuration", vim.log.levels.INFO)
      end

      function M.show_plugin_manager_ui()
        local choices = {
          "🔍 Search GitHub Plugins",
          "📦 List Installed Plugins", 
          "🔄 Update All Plugins",
          "🧹 Clean Unused Plugins",
          "⚙️  Open Plugin Configuration",
        }

        vim.ui.select(choices, {
          prompt = "Plugin Manager:",
        }, function(choice)
          if choice and choice:match("Search GitHub") then
            M.show_plugin_search()
          elseif choice and choice:match("List Installed") then
            M.show_installed_plugins()
          elseif choice and choice:match("Update All") then
            local lazy_ok, lazy = pcall(require, "lazy")
            if lazy_ok then
              lazy.update()
            end
          elseif choice and choice:match("Clean Unused") then
            local lazy_ok, lazy = pcall(require, "lazy")
            if lazy_ok then
              lazy.clean()
            end
          elseif choice and choice:match("Open Plugin Configuration") then
            vim.cmd("edit " .. M.config.user_plugins_file)
          end
        end)
      end

      -- Create user commands
      vim.api.nvim_create_user_command("PluginSearch", function(opts)
        if opts.args and opts.args ~= "" then
          M.search_github_plugins(opts.args, function(repos)
            if #repos > 0 then
              print("Found " .. #repos .. " plugins:")
              for i = 1, math.min(5, #repos) do
                local repo = repos[i]
                print(string.format("  %d. %s ⭐%d - %s", 
                  i, repo.full_name, repo.stargazers_count, repo.description or ""))
              end
            else
              print("No plugins found for: " .. opts.args)
            end
          end)
        else
          M.show_plugin_search()
        end
      end, { nargs = "?", desc = "Search GitHub plugins" })

      vim.api.nvim_create_user_command("PluginInstall", function(opts)
        if opts.args and opts.args ~= "" then
          M.install_plugin(opts.args)
        else
          M.show_plugin_search()
        end
      end, { nargs = "?", desc = "Install plugin from GitHub" })

      vim.api.nvim_create_user_command("PluginList", function()
        M.show_installed_plugins()
      end, { desc = "List installed plugins" })

      vim.api.nvim_create_user_command("PluginUpdate", function(opts)
        if opts.args and opts.args ~= "" then
          M.update_plugin(opts.args)
        else
          local lazy_ok, lazy = pcall(require, "lazy")
          if lazy_ok then
            lazy.update()
          end
        end
      end, { nargs = "?", desc = "Update plugin(s)" })

      vim.api.nvim_create_user_command("PluginRemove", function(opts)
        if opts.args and opts.args ~= "" then
          M.remove_plugin(opts.args)
        else
          M.show_installed_plugins()
        end
      end, { nargs = "?", desc = "Remove plugin" })

      vim.api.nvim_create_user_command("PluginManager", function()
        M.show_plugin_manager_ui()
      end, { desc = "Open Plugin Manager UI" })

      -- Make the module globally available
      _G.PluginManager = M
      
      notify("Plugin Manager loaded! Use :PluginManager to get started")
    end,
  },
}