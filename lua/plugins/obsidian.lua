return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    workspaces = {
      {
        name = "lefv-vault",
        path = "~/repos/lefv-vault",
      },
    },

    -- Daily notes configuration
    daily_notes = {
      folder = "notes",
      date_format = "%Y%m%d",
      alias_format = "%B %-d, %Y",
    },

    -- Note ID generation (Zettelkasten timestamp format)
    note_id_func = function(title)
      -- Generate timestamp ID like Zettelkasten: YYYYMMDDHHMMSS
      return tostring(os.date("%Y%m%d%H%M%S"))
    end,

    -- Note path function (organize by domain)
    note_path_func = function(spec)
      -- Save notes to appropriate domain directory
      -- For now, default to notes/ directory
      local path = spec.dir / "notes"
      return tostring(path) .. "/" .. spec.id .. ".md"
    end,

    -- Frontmatter
    note_frontmatter_func = function(note)
      local out = {
        id = note.id,
        title = note.title,
        created = os.date("%Y-%m-%dT%H:%M:%S") .. "Z",
        modified = os.date("%Y-%m-%dT%H:%M:%S") .. "Z",
        tags = note.tags or {},
        domain = "notes", -- default domain
        status = "draft",
      }

      -- Add aliases if present
      if note.aliases ~= nil and #note.aliases > 0 then
        out.aliases = note.aliases
      end

      return out
    end,

    -- Templates with dynamic substitutions (like Templater)
    templates = {
      folder = "template",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
      substitutions = {
        -- Random ID (timestamp-based like Zettelkasten)
        random_id = function()
          return tostring(os.date("%Y%m%d%H%M%S"))
        end,
        -- Creation date/time
        creation_date = function()
          return os.date("%Y-%m-%d %H:%M")
        end,
        -- Current date/time with custom format
        now = function()
          return os.date("%Y-%m-%d.%H%M%S")
        end,
        -- ISO timestamp
        timestamp = function()
          return os.date("%Y-%m-%dT%H:%M:%S") .. "Z"
        end,
        -- Date only
        date = function()
          return os.date("%Y-%m-%d")
        end,
        -- Time only
        time = function()
          return os.date("%H:%M:%S")
        end,
        -- Year
        year = function()
          return os.date("%Y")
        end,
        -- Month name
        month = function()
          return os.date("%B")
        end,
        -- Day of month
        day = function()
          return os.date("%d")
        end,
      },
    },

    -- Completion settings (disabled - enable if you install nvim-cmp)
    -- completion = {
    --   nvim_cmp = true,
    --   min_chars = 2,
    -- },

    -- Mappings (can be customized)
    mappings = {
      -- "Obsidian follow"
      ["gf"] = {
        action = function()
          return require("obsidian").util.gf_passthrough()
        end,
        opts = { noremap = false, expr = true, buffer = true },
      },
      -- Toggle checkbox
      ["<leader>ch"] = {
        action = function()
          return require("obsidian").util.toggle_checkbox()
        end,
        opts = { buffer = true },
      },
      -- Smart action (depends on context)
      ["<cr>"] = {
        action = function()
          return require("obsidian").util.smart_action()
        end,
        opts = { buffer = true, expr = true },
      },
    },

    -- Customize how note IDs are displayed
    preferred_link_style = "wiki", -- use [[wiki-style]] links

    -- Disable wiki link syntax concealment
    disable_frontmatter = false,

    -- UI settings
    ui = {
      enable = true,
      update_debounce = 200,
      max_file_length = 5000,
      checkboxes = {
        [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
        ["x"] = { char = "", hl_group = "ObsidianDone" },
        [">"] = { char = "", hl_group = "ObsidianRightArrow" },
        ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
        ["!"] = { char = "", hl_group = "ObsidianImportant" },
      },
      bullets = { char = "•", hl_group = "ObsidianBullet" },
      external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
      reference_text = { hl_group = "ObsidianRefText" },
      highlight_text = { hl_group = "ObsidianHighlightText" },
      tags = { hl_group = "ObsidianTag" },
      block_ids = { hl_group = "ObsidianBlockID" },
      hl_groups = {
        ObsidianTodo = { bold = true, fg = "#f78c6c" },
        ObsidianDone = { bold = true, fg = "#89ddff" },
        ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
        ObsidianTilde = { bold = true, fg = "#ff5370" },
        ObsidianImportant = { bold = true, fg = "#d73128" },
        ObsidianBullet = { bold = true, fg = "#89ddff" },
        ObsidianRefText = { underline = true, fg = "#c792ea" },
        ObsidianExtLinkIcon = { fg = "#c792ea" },
        ObsidianTag = { italic = true, fg = "#89ddff" },
        ObsidianBlockID = { italic = true, fg = "#89ddff" },
        ObsidianHighlightText = { bg = "#75662e" },
      },
    },

    -- Image pasting configuration
    attachments = {
      img_folder = "assets/images",
      img_text_func = function(client, path)
        local link_path = client:vault_relative_path(path) or path
        return string.format("![%s](%s)", path.name, link_path)
      end,
    },

    -- Finder configuration
    finder = "telescope.nvim",
    finder_mappings = {
      new = "<C-x>",
    },

    -- Follow URL with system browser
    follow_url_func = function(url)
      vim.fn.jobstart({ "open", url })
    end,

    -- Customize picker (telescope)
    picker = {
      name = "telescope.nvim",
      mappings = {
        new = "<C-x>",
        insert_link = "<C-l>",
      },
    },

    -- Open notes in new split/vsplit
    open_notes_in = "current", -- or "vsplit", "hsplit"

    -- Automatically set up concealment
    conceallevel = 2,
  },

  -- Additional keymaps
  keys = {
    -- Obsidian commands
    { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "New note" },
    { "<leader>oo", "<cmd>ObsidianSearch<cr>", desc = "Search notes" },
    { "<leader>oq", "<cmd>ObsidianQuickSwitch<cr>", desc = "Quick switch" },
    { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Show backlinks" },
    { "<leader>ot", "<cmd>ObsidianToday<cr>", desc = "Open today's note" },
    { "<leader>oy", "<cmd>ObsidianYesterday<cr>", desc = "Open yesterday's note" },
    { "<leader>od", "<cmd>ObsidianDailies<cr>", desc = "Open daily notes" },
    { "<leader>ol", "<cmd>ObsidianLinks<cr>", desc = "Show links" },
    { "<leader>og", "<cmd>ObsidianTags<cr>", desc = "Search tags" },
    { "<leader>of", "<cmd>ObsidianFollowLink<cr>", desc = "Follow link" },
    { "<leader>oi", "<cmd>ObsidianPasteImg<cr>", desc = "Paste image" },
    { "<leader>or", "<cmd>ObsidianRename<cr>", desc = "Rename note" },
    { "<leader>om", "<cmd>ObsidianTemplate<cr>", desc = "Insert template" },

    -- Link operations
    { "<leader>ol", ":ObsidianLink<cr>", desc = "Link selection", mode = "v" },
    { "<leader>oln", ":ObsidianLinkNew<cr>", desc = "Link to new note", mode = "v" },

    -- Extract selection to new note
    { "<leader>oe", ":ObsidianExtractNote<cr>", desc = "Extract to new note", mode = "v" },

    -- Open in Obsidian app (if needed)
    { "<leader>oO", "<cmd>ObsidianOpen<cr>", desc = "Open in Obsidian app" },

    -- Update vault TODOs
    { "<leader>oT", "<cmd>ObsidianUpdateTodos<cr>", desc = "Update vault TODOs" },

    -- Open vault (switch project context)
    { "<leader>ov", function()
      local vault_path = vim.fn.expand("~/repos/lefv-vault")
      vim.cmd("cd " .. vault_path)
      vim.notify("Switched to Obsidian vault: " .. vault_path, vim.log.levels.INFO)
      -- Open file picker in vault
      require("telescope.builtin").find_files({ cwd = vault_path })
    end, desc = "Open vault" },
  },

  config = function(_, opts)
    require("obsidian").setup(opts)

    -- Set conceallevel for markdown files
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      callback = function()
        vim.opt_local.conceallevel = 2
      end,
    })

    -- Function to toggle checkbox in source file
    local function toggle_todo_in_source(file_path, line_num)
      local vault_path = vim.fn.expand("~/repos/lefv-vault")
      local full_path = vault_path .. "/" .. file_path

      -- Read the file
      local lines = vim.fn.readfile(full_path)
      if not lines or #lines < tonumber(line_num) then
        vim.notify("Could not read source file", vim.log.levels.ERROR)
        return false
      end

      -- Toggle the checkbox on the specified line
      local line = lines[tonumber(line_num)]
      local new_line = line

      if line:match("%[ %]") then
        new_line = line:gsub("%[ %]", "[x]", 1)
      elseif line:match("%[x%]") then
        new_line = line:gsub("%[x%]", "[ ]", 1)
      else
        vim.notify("No checkbox found on this line", vim.log.levels.WARN)
        return false
      end

      -- Update the line
      lines[tonumber(line_num)] = new_line

      -- Write back to file
      vim.fn.writefile(lines, full_path)
      vim.notify("Updated " .. file_path .. ":" .. line_num, vim.log.levels.INFO)
      return true
    end

    -- Function to update TODO.md
    local function update_vault_todos()
      local vault_path = vim.fn.expand("~/repos/lefv-vault")
      local todo_file = vault_path .. "/TODO.md"

      -- Find all TODO items in vault (both checked and unchecked)
      local todos = {}
      local handle = io.popen('cd "' .. vault_path .. '" && grep -rn "TODO\\|\\[ \\]\\|\\[x\\]" --include="*.md" --exclude="TODO.md" .')
      if handle then
        for line in handle:lines() do
          -- Parse grep output: ./path/file.md:line_number:content
          local file, line_num, content = line:match("^%./(.-):(%d+):(.*)")
          if file and line_num and content then
            -- Determine if checked
            local is_checked = content:match("%[x%]") ~= nil
            table.insert(todos, {
              file = file,
              line = line_num,
              content = content:match("^%s*(.-)%s*$"), -- trim whitespace
              checked = is_checked,
            })
          end
        end
        handle:close()
      end

      -- Separate unchecked and checked items
      local unchecked = {}
      local checked = {}
      for _, todo in ipairs(todos) do
        if todo.checked then
          table.insert(checked, todo)
        else
          table.insert(unchecked, todo)
        end
      end

      -- Generate TODO.md content
      local lines = {
        "# Vault TODO",
        "",
        "Auto-generated list of all TODO items in the vault.",
        "Toggle checkboxes with `<leader>x` or `;l` to update source files.",
        "",
        "Last updated: " .. os.date("%Y-%m-%d %H:%M:%S"),
        "",
      }

      if #unchecked > 0 then
        table.insert(lines, "## Active TODOs (" .. #unchecked .. ")")
        table.insert(lines, "")

        for _, todo in ipairs(unchecked) do
          -- Create checkbox with wiki link and store metadata
          local note_name = todo.file:match("([^/]+)%.md$") or todo.file
          local link = string.format("- [ ] [[%s#L%s|%s:%s]] %s <!-- src:%s:%s -->",
            todo.file:gsub("%.md$", ""),
            todo.line,
            note_name,
            todo.line,
            todo.content,
            todo.file,
            todo.line
          )
          table.insert(lines, link)
        end
        table.insert(lines, "")
      end

      if #checked > 0 then
        table.insert(lines, "## Completed (" .. #checked .. ")")
        table.insert(lines, "")

        for _, todo in ipairs(checked) do
          local note_name = todo.file:match("([^/]+)%.md$") or todo.file
          local link = string.format("- [x] [[%s#L%s|%s:%s]] %s <!-- src:%s:%s -->",
            todo.file:gsub("%.md$", ""),
            todo.line,
            note_name,
            todo.line,
            todo.content,
            todo.file,
            todo.line
          )
          table.insert(lines, link)
        end
      end

      if #todos == 0 then
        table.insert(lines, "No TODOs found in vault.")
      end

      -- Write TODO.md file
      local file = io.open(todo_file, "w")
      if file then
        file:write(table.concat(lines, "\n") .. "\n")
        file:close()
        vim.notify("Updated TODO.md: " .. #unchecked .. " active, " .. #checked .. " completed", vim.log.levels.INFO)
      end
    end

    -- Special toggle for TODO.md that updates source files
    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "*/TODO.md",
      callback = function()
        vim.keymap.set("n", "<leader>x", function()
          local line = vim.api.nvim_get_current_line()
          -- Extract source file and line number from comment
          local file, line_num = line:match("<!%-%- src:(.+):(%d+) %-%->")
          if file and line_num then
            if toggle_todo_in_source(file, line_num) then
              -- Refresh TODO.md after a short delay
              vim.defer_fn(function()
                update_vault_todos()
                -- Reload the buffer
                vim.cmd("edit")
              end, 100)
            end
          else
            vim.notify("Could not find source location for this TODO", vim.log.levels.WARN)
          end
        end, { buffer = true, desc = "Toggle TODO in source file" })

        vim.keymap.set("n", ";l", function()
          local line = vim.api.nvim_get_current_line()
          local file, line_num = line:match("<!%-%- src:(.+):(%d+) %-%->")
          if file and line_num then
            if toggle_todo_in_source(file, line_num) then
              vim.defer_fn(function()
                update_vault_todos()
                vim.cmd("edit")
              end, 100)
            end
          else
            vim.notify("Could not find source location for this TODO", vim.log.levels.WARN)
          end
        end, { buffer = true, desc = "Toggle TODO in source file" })
      end,
    })

    -- Create command to manually trigger TODO update
    vim.api.nvim_create_user_command("ObsidianUpdateTodos", update_vault_todos, {})

    -- Periodic update of TODO.md every 5 minutes (instead of on every save)
    local timer = vim.loop.new_timer()
    timer:start(0, 300000, vim.schedule_wrap(function()
      -- Only run if currently in vault
      local current_file = vim.fn.expand("%:p")
      if current_file:match("lefv%-vault") then
        update_vault_todos()
      end
    end))
  end,
}
