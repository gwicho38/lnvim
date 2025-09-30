return {
  "tsakirist/telescope-lazy.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  config = function()
    require("telescope").load_extension("lazy")

    -- Custom GitHub plugin search
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")
    local previewers = require("telescope.previewers")

    local function github_plugin_search(opts)
      opts = opts or {}

      pickers
        .new(opts, {
          prompt_title = "GitHub Neovim Plugins",
          finder = finders.new_async_job({
            command_generator = function(prompt)
              if not prompt or prompt == "" then
                return nil
              end
              return {
                "curl",
                "-s",
                "https://api.github.com/search/repositories?q="
                  .. vim.fn.shellescape(prompt .. " neovim plugin")
                  .. "&sort=stars&order=desc&per_page=50",
              }
            end,
            entry_maker = function(entry)
              local ok, decoded = pcall(vim.fn.json_decode, entry)
              if not ok or not decoded.items then
                return nil
              end

              local results = {}
              for _, item in ipairs(decoded.items) do
                table.insert(results, {
                  value = item,
                  display = string.format("%s ⭐%d", item.full_name, item.stargazers_count),
                  ordinal = item.full_name .. " " .. (item.description or ""),
                })
              end
              return results
            end,
          }),
          sorter = conf.generic_sorter(opts),
          previewer = previewers.new_buffer_previewer({
            title = "Plugin Info",
            define_preview = function(self, entry, status)
              local item = entry.value
              local lines = {
                "🏷️  " .. item.full_name,
                "⭐ " .. item.stargazers_count .. " stars",
                "🍴 " .. item.forks_count .. " forks",
                "📅 Updated: " .. item.updated_at:sub(1, 10),
                "🔗 " .. item.html_url,
                "",
                "📝 Description:",
                item.description or "No description available",
                "",
                "🏷️  Topics:",
                table.concat(item.topics or {}, ", "),
                "",
                "📄 Language: " .. (item.language or "Unknown"),
                "📏 Size: " .. item.size .. " KB",
              }

              if item.license then
                table.insert(lines, "⚖️  License: " .. item.license.name)
              end

              vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
            end,
          }),
          attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
              actions.close(prompt_bufnr)
              local selection = action_state.get_selected_entry()
              if selection then
                local repo = selection.value.full_name
                -- Copy plugin spec to clipboard
                local plugin_spec = string.format('{ "%s" }', repo)
                vim.fn.setreg("+", plugin_spec)
                vim.notify("Copied plugin spec to clipboard: " .. plugin_spec, vim.log.levels.INFO)
                -- Also open the GitHub page
                vim.fn.jobstart({ "open", selection.value.html_url }, { detach = true })
              end
            end)

            map("i", "<C-o>", function()
              local selection = action_state.get_selected_entry()
              if selection then
                vim.fn.jobstart({ "open", selection.value.html_url }, { detach = true })
              end
            end)

            return true
          end,
        })
        :find()
    end

    vim.api.nvim_create_user_command("TelescopeGithubPlugins", function()
      github_plugin_search()
    end, {})
  end,
  keys = {
    { "<leader>fP", "<cmd>Telescope lazy<cr>", desc = "Find Installed Plugins" },
    { "<leader>fG", "<cmd>TelescopeGithubPlugins<cr>", desc = "Search GitHub Plugins" },
  },
}
