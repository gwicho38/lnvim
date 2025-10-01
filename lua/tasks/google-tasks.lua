-- Google Tasks Integration
-- Setup: Get OAuth token from https://developers.google.com/tasks/quickstart/rest
-- Store in ~/.config/nvim/google-tasks-token.txt

local M = {}

local curl = require("plenary.curl")

-- Read API token from file
local function get_token()
  local token_file = vim.fn.expand("~/.config/nvim/google-tasks-token.txt")
  if vim.fn.filereadable(token_file) == 1 then
    local token = vim.fn.readfile(token_file)[1]
    return token
  end
  return nil
end

-- Fetch all task lists
function M.get_task_lists()
  local token = get_token()
  if not token then
    vim.notify("Google Tasks token not found. See :help google-tasks-setup", vim.log.levels.ERROR)
    return
  end

  local response = curl.get("https://tasks.googleapis.com/tasks/v1/users/@me/lists", {
    headers = {
      ["Authorization"] = "Bearer " .. token,
    },
  })

  if response.status == 200 then
    local data = vim.fn.json_decode(response.body)
    return data.items or {}
  else
    vim.notify("Failed to fetch Google Task lists: " .. response.status, vim.log.levels.ERROR)
    return {}
  end
end

-- Fetch tasks from a list
function M.get_tasks(tasklist_id)
  local token = get_token()
  if not token then
    return {}
  end

  local response = curl.get(
    string.format("https://tasks.googleapis.com/tasks/v1/lists/%s/tasks", tasklist_id),
    {
      headers = {
        ["Authorization"] = "Bearer " .. token,
      },
    }
  )

  if response.status == 200 then
    local data = vim.fn.json_decode(response.body)
    return data.items or {}
  end
  return {}
end

-- Add a new task
function M.add_task(tasklist_id, title, notes)
  local token = get_token()
  if not token then
    return
  end

  local body = vim.fn.json_encode({
    title = title,
    notes = notes or "",
  })

  local response = curl.post(
    string.format("https://tasks.googleapis.com/tasks/v1/lists/%s/tasks", tasklist_id),
    {
      headers = {
        ["Authorization"] = "Bearer " .. token,
        ["Content-Type"] = "application/json",
      },
      body = body,
    }
  )

  if response.status == 200 then
    vim.notify("Task added to Google Tasks", vim.log.levels.INFO)
  else
    vim.notify("Failed to add task: " .. response.status, vim.log.levels.ERROR)
  end
end

-- Complete a task
function M.complete_task(tasklist_id, task_id)
  local token = get_token()
  if not token then
    return
  end

  local body = vim.fn.json_encode({
    status = "completed",
  })

  local response = curl.patch(
    string.format("https://tasks.googleapis.com/tasks/v1/lists/%s/tasks/%s", tasklist_id, task_id),
    {
      headers = {
        ["Authorization"] = "Bearer " .. token,
        ["Content-Type"] = "application/json",
      },
      body = body,
    }
  )

  if response.status == 200 then
    vim.notify("Task completed", vim.log.levels.INFO)
  end
end

-- Show tasks in a picker
function M.show_tasks()
  local lists = M.get_task_lists()
  if not lists or #lists == 0 then
    vim.notify("No task lists found", vim.log.levels.WARN)
    return
  end

  -- Use first list by default
  local tasklist_id = lists[1].id
  local tasks = M.get_tasks(tasklist_id)

  -- Format for telescope
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  pickers
    .new({}, {
      prompt_title = "Google Tasks: " .. lists[1].title,
      finder = finders.new_table({
        results = tasks,
        entry_maker = function(entry)
          local status_icon = entry.status == "completed" and " " or " "
          return {
            value = entry,
            display = status_icon .. " " .. entry.title,
            ordinal = entry.title,
          }
        end,
      }),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          if selection then
            M.complete_task(tasklist_id, selection.value.id)
          end
        end)
        return true
      end,
    })
    :find()
end

return M
