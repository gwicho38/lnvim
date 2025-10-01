# Task Management Integrations

This Neovim configuration integrates with multiple task management services:
- **Google Tasks**
- **Microsoft To-Do (Office 365)**
- **Todoist**
- **Obsidian Vault TODOs** (local)

## Quick Access

Press `<leader>TT` (Space+T+T) to open the unified task manager menu.

## Keybindings

| Key | Action |
|-----|--------|
| `<leader>TT` | Task Manager Menu (choose service) |
| `<leader>Tg` | View Google Tasks |
| `<leader>TG` | Add Google Task |
| `<leader>Tm` | View Microsoft To-Do |
| `<leader>TM` | Add Microsoft To-Do Task |
| `<leader>To` | Update Obsidian TODOs |
| `<leader>TO` | Open Obsidian TODO.md |

## Setup Instructions

### Google Tasks

1. **Get OAuth Token:**
   - Visit: https://developers.google.com/oauthplayground/
   - Select "Tasks API v1" → "https://www.googleapis.com/auth/tasks"
   - Click "Authorize APIs"
   - Exchange authorization code for tokens
   - Copy the "Access token"

2. **Save Token:**
   ```bash
   echo "YOUR_ACCESS_TOKEN" > ~/.config/nvim/google-tasks-token.txt
   ```

3. **Test:**
   ```vim
   :GoogleTasks
   ```

**Note:** Access tokens expire. For production use, implement OAuth refresh tokens or use service accounts.

### Microsoft To-Do (Office 365)

1. **Get OAuth Token:**
   - Register app at: https://portal.azure.com/#blade/Microsoft_AAD_RegisteredApps/ApplicationsListBlade
   - Add "Tasks.ReadWrite" permission
   - Get token via OAuth flow or use Microsoft Graph Explorer:
     - Visit: https://developer.microsoft.com/en-us/graph/graph-explorer
     - Sign in with your Microsoft account
   - Copy the access token

2. **Save Token:**
   ```bash
   echo "YOUR_ACCESS_TOKEN" > ~/.config/nvim/microsoft-todo-token.txt
   ```

3. **Test:**
   ```vim
   :MicrosoftTodo
   ```

### Todoist

1. **Get API Token:**
   - Go to: https://todoist.com/app/settings/integrations/developer
   - Copy your API token

2. **Set Environment Variable:**

   Add to your `~/.zshrc` or `~/.bashrc`:
   ```bash
   export TODOIST_API_TOKEN="your_token_here"
   ```

   Or set in your Neovim config:
   ```lua
   vim.env.TODOIST_API_TOKEN = "your_token_here"
   ```

3. **Test:**
   ```vim
   :TodoistTasks
   ```

### Obsidian Vault TODOs

Works automatically with your local vault at `~/repos/lefv-vault`.

- Auto-generates from TODO items and checkboxes in all notes
- Updates on every markdown file save
- Manual update: `<leader>oT` or `:ObsidianUpdateTodos`

## Commands

- `:Tasks` - Open unified task manager menu
- `:GoogleTasks` - Show Google Tasks
- `:GoogleTasksAdd [title]` - Add a Google Task
- `:MicrosoftTodo` - Show Microsoft To-Do tasks
- `:MicrosoftTodoAdd [title]` - Add a Microsoft To-Do task
- `:TodoistTasks` - Show Todoist tasks (requires token)
- `:ObsidianUpdateTodos` - Refresh vault TODOs

## Features

- **View tasks** from all services in Telescope picker
- **Complete tasks** by selecting them in the picker
- **Add new tasks** with quick commands
- **Unified menu** to switch between services
- **Local TODO tracking** with Obsidian vault integration

## Security Notes

- API tokens are stored in plain text files
- For production/shared environments, consider:
  - Encrypting token files
  - Using environment variables
  - Implementing proper OAuth refresh flows
  - Setting restrictive file permissions: `chmod 600 ~/.config/nvim/*-token.txt`

## Token Refresh

OAuth tokens expire. To refresh:

1. **Google Tasks:** Re-run the OAuth playground process
2. **Microsoft To-Do:** Re-authenticate via Graph Explorer or your app
3. **Todoist:** API tokens don't expire unless revoked

For automated refresh, implement OAuth refresh token flows in the respective Lua modules.

## Troubleshooting

**"Token not found" errors:**
- Check file paths: `~/.config/nvim/google-tasks-token.txt`
- Verify file permissions: `ls -la ~/.config/nvim/*-token.txt`
- Ensure tokens are on first line with no extra whitespace

**"Failed to fetch" errors:**
- Verify token is valid (not expired)
- Check internet connection
- Ensure API permissions are granted
- Check `:messages` for detailed error info

**Telescope picker empty:**
- Verify you have tasks in that service
- Check token permissions include read access
- Try refreshing: close and reopen the picker
