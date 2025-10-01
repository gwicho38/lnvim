return {
  -- Universal task management with REST APIs
  {
    "nvim-lua/plenary.nvim",
    lazy = false,
    config = function()
      -- Create user commands for task integrations

      -- Google Tasks
      vim.api.nvim_create_user_command("GoogleTasks", function()
        require("tasks.google-tasks").show_tasks()
      end, { desc = "Show Google Tasks" })

      vim.api.nvim_create_user_command("GoogleTasksAdd", function(opts)
        local title = opts.args
        if title == "" then
          title = vim.fn.input("Task title: ")
        end
        if title ~= "" then
          local lists = require("tasks.google-tasks").get_task_lists()
          if lists and #lists > 0 then
            require("tasks.google-tasks").add_task(lists[1].id, title)
          end
        end
      end, { nargs = "?", desc = "Add Google Task" })

      -- Microsoft To-Do
      vim.api.nvim_create_user_command("MicrosoftTodo", function()
        require("tasks.microsoft-todo").show_tasks()
      end, { desc = "Show Microsoft To-Do" })

      vim.api.nvim_create_user_command("MicrosoftTodoAdd", function(opts)
        local title = opts.args
        if title == "" then
          title = vim.fn.input("Task title: ")
        end
        if title ~= "" then
          local lists = require("tasks.microsoft-todo").get_task_lists()
          if lists and #lists > 0 then
            require("tasks.microsoft-todo").add_task(lists[1].id, title)
          end
        end
      end, { nargs = "?", desc = "Add Microsoft To-Do Task" })

      -- Todoist (if token is set)
      local todoist_token = os.getenv("TODOIST_API_TOKEN")
      if todoist_token then
        vim.api.nvim_create_user_command("TodoistTasks", function()
          require("tasks.todoist").show_tasks()
        end, { desc = "Show Todoist Tasks" })
      end

      -- Unified task menu
      vim.api.nvim_create_user_command("Tasks", function()
        local options = {
          "Google Tasks",
          "Microsoft To-Do",
          "Todoist",
          "Obsidian Vault TODOs",
        }

        vim.ui.select(options, {
          prompt = "Select Task Service:",
        }, function(choice)
          if choice == "Google Tasks" then
            vim.cmd("GoogleTasks")
          elseif choice == "Microsoft To-Do" then
            vim.cmd("MicrosoftTodo")
          elseif choice == "Todoist" then
            if todoist_token then
              vim.cmd("TodoistTasks")
            else
              vim.notify("Todoist token not set. Set TODOIST_API_TOKEN environment variable.", vim.log.levels.WARN)
            end
          elseif choice == "Obsidian Vault TODOs" then
            vim.cmd("ObsidianUpdateTodos")
            vim.cmd("edit ~/repos/lefv-vault/TODO.md")
          end
        end)
      end, { desc = "Open Task Manager" })
    end,
    keys = {
      -- Unified task menu
      { "<leader>TT", "<cmd>Tasks<cr>", desc = "Task Manager Menu" },

      -- Google Tasks
      { "<leader>Tg", "<cmd>GoogleTasks<cr>", desc = "Google Tasks" },
      { "<leader>TG", "<cmd>GoogleTasksAdd<cr>", desc = "Add Google Task" },

      -- Microsoft To-Do
      { "<leader>Tm", "<cmd>MicrosoftTodo<cr>", desc = "Microsoft To-Do" },
      { "<leader>TM", "<cmd>MicrosoftTodoAdd<cr>", desc = "Add Microsoft Task" },

      -- Obsidian Vault TODOs
      { "<leader>To", "<cmd>ObsidianUpdateTodos<cr>", desc = "Update Obsidian TODOs" },
      { "<leader>TO", "<cmd>edit ~/repos/lefv-vault/TODO.md<cr>", desc = "Open Obsidian TODOs" },
    },
  },
}
