-- Theme persistence system
local M = {}

local theme_file = vim.fn.stdpath("data") .. "/current_theme.txt"

-- Save current theme to file
function M.save_theme(theme_name)
  local file = io.open(theme_file, "w")
  if file then
    file:write(theme_name)
    file:close()
    return true
  end
  return false
end

-- Load saved theme
function M.load_theme()
  if vim.fn.filereadable(theme_file) == 1 then
    local file = io.open(theme_file, "r")
    if file then
      local theme = file:read("*line")
      file:close()
      return theme
    end
  end
  return nil
end

-- Get available themes
function M.get_available_themes()
  return {
    { name = "gruvbox", display = "Gruvbox (warm, retro)" },
    { name = "tokyonight", display = "TokyoNight (modern, vibrant)" },
    { name = "tokyonight-night", display = "TokyoNight Night" },
    { name = "tokyonight-storm", display = "TokyoNight Storm" },
    { name = "tokyonight-moon", display = "TokyoNight Moon" },
    { name = "tokyonight-day", display = "TokyoNight Day" },
    { name = "catppuccin", display = "Catppuccin (pastel, soothing)" },
    { name = "catppuccin-mocha", display = "Catppuccin Mocha" },
    { name = "catppuccin-macchiato", display = "Catppuccin Macchiato" },
    { name = "catppuccin-frappe", display = "Catppuccin Frappe" },
    { name = "catppuccin-latte", display = "Catppuccin Latte" },
  }
end

-- Apply theme and save preference
function M.set_theme(theme_name)
  local ok, err = pcall(vim.cmd.colorscheme, theme_name)
  if ok then
    M.save_theme(theme_name)
    vim.notify("Theme set to: " .. theme_name, vim.log.levels.INFO)
    return true
  else
    vim.notify("Failed to set theme: " .. theme_name .. "\n" .. tostring(err), vim.log.levels.ERROR)
    return false
  end
end

-- Theme picker with Telescope
function M.theme_picker()
  local themes = M.get_available_themes()

  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local previewers = require("telescope.previewers")

  pickers.new({}, {
    prompt_title = "Select Theme",
    finder = finders.new_table({
      results = themes,
      entry_maker = function(entry)
        return {
          value = entry.name,
          display = entry.display,
          ordinal = entry.display,
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      -- Preview theme on hover
      map("i", "<C-p>", function()
        local selection = action_state.get_selected_entry()
        if selection then
          pcall(vim.cmd.colorscheme, selection.value)
        end
      end)

      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if selection then
          M.set_theme(selection.value)
        end
      end)

      return true
    end,
  }):find()
end

return M
