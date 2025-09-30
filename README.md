# 💤 LazyVim Configuration

Personal Neovim configuration built on [LazyVim](https://github.com/LazyVim/LazyVim) with extensive customizations for AI-assisted development and note-taking.

## Features

### 🤖 AI Coding Integration
- **Claude Code** - Toggle with `<C-,>` (Ctrl+Comma) in normal or terminal mode
  - `<leader>cC` - Continue most recent conversation
  - `<leader>cV` - Launch with verbose output
  - Auto-refreshes files on change detection
  - Auto-detects git root directory
- **GitHub Copilot** - AI pair programming assistant
- **Gen.nvim** - `<leader>ag` for AI text generation with local models

### 🎨 Custom Dashboard
Press Space in the dashboard to access:
- **Zettelkasten Notes** (`z`) - Browse/create markdown notes with templates
  - Auto-creates `~/notes` directory
  - Press `<C-n>` in picker to create new note with template
- **Plugin Browser** (`p`) - Discover and install new plugins
  - Opens GitHub page for selected plugin
  - Press `<C-a>` to add plugin to your config

### ⌨️ Command Palette
- `<C-S-P>` (Ctrl+Shift+P) - VSCode-style command palette via commander.nvim
- `<leader>cp` - Alternative trigger

### 🔧 Developer Tools
- **Hot Reload** (hot.nvim) - Auto-run/test on save
  - `<F3>` - Restart runner
  - `<F4>` - Silent mode
  - `<F5>` - Stop runner
  - `<F6>` - Test restart
  - `<F7>` - Open output buffer
  - `<F8>` - Close output buffer
- **Hawtkeys** - Keymap analyzer for conflicts
  - `:Hawtkeys` - Show all keybindings
  - `:HawtkeysDupes` - Find duplicates
- **Lazygit** - `<leader>gg` (git root) or `<leader>gG` (cwd)

### 🔗 Git Integration
- `<leader>gY` - Copy current line/selection GitHub URL to clipboard (browse without opening)
- `<leader>gB` - Open current line/selection on GitHub
- `<leader>gb` - Git blame current line
- Auto-organize imports on save for TS/JS/Python/Go/Rust

### 📝 Note-taking & Markdown
- Enhanced markdown support with image pasting (img-clip.nvim)
- Follow markdown links with `gx`
- Toggle checkboxes in markdown
- Auto-pandoc for document conversion

### 🚀 Remote Development
- **Distant.nvim** - Edit files on remote servers
  - `:DistantConnect` - Connect to remote
  - `:DistantLaunch` - Launch distant server
- **Transfer.nvim** - SFTP/SCP file transfers
  - `:TransferInit` - Initialize transfer config
  - `:TransferUpload` / `:TransferDownload` - Sync files

## Requirements

### Minimum
- **Neovim >= 0.10.2** (v0.11.2 recommended)
- **Git >= 2.19.0**
- A [Nerd Font](https://www.nerdfonts.com/) (optional but recommended for icons)
- True color terminal support

### Recommended Tools
- **ripgrep** - For telescope live grep
  ```bash
  # macOS
  brew install ripgrep
  # Ubuntu/Debian
  sudo apt install ripgrep
  ```

- **fd** - For faster file finding
  ```bash
  # macOS
  brew install fd
  # Ubuntu/Debian
  sudo apt install fd-find
  ```

- **lazygit** - For git integration (`<leader>gg`)
  ```bash
  # macOS
  brew install lazygit
  # Ubuntu/Debian
  # See https://github.com/jesseduffield/lazygit#installation
  ```

### Optional (AI Features)
- **Claude Code CLI** - For AI coding assistant
  ```bash
  # Install from https://docs.claude.com/claude-code
  ```

- **GitHub Copilot** - Requires GitHub Copilot subscription
  ```vim
  # After first launch, run in Neovim:
  :Copilot setup
  ```

- **Ollama + llama3.2** - For local AI with gen.nvim
  ```bash
  # Install Ollama
  # macOS
  brew install ollama
  # Then pull model
  ollama pull llama3.2
  ```

### Optional (Remote Development)
- **distant** - For remote file editing
  ```bash
  # Install from https://github.com/chipsenkbeil/distant
  cargo install distant
  ```

## Installation

1. Backup existing config:
   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   ```

2. Clone this repository:
   ```bash
   git clone https://github.com/gwicho38/lnvim.git ~/.config/nvim
   ```

3. Start Neovim - plugins will auto-install:
   ```bash
   nvim
   ```

4. Install Claude Code CLI (for AI integration):
   ```bash
   # Follow instructions at https://docs.claude.com/claude-code
   ```

## Key Bindings Summary

| Key | Description |
|-----|-------------|
| `<C-,>` | Toggle Claude Code terminal |
| `<C-S-P>` | Command palette |
| `<leader>gg` | Lazygit |
| `<leader>gY` | Copy GitHub URL |
| `<leader>ag` | AI generate |
| `<leader>cC` | Continue Claude conversation |
| `<F3-F8>` | Hot reload controls |
| `jj` | Escape to normal mode |

## Documentation

- [CLAUDE.md](./CLAUDE.md) - Detailed architecture and development guidelines
- [TROUBLESHOOTING.md](./TROUBLESHOOTING.md) - Common issues and solutions

## Troubleshooting

Having issues? Check the [Troubleshooting Guide](./TROUBLESHOOTING.md) or run `:checkhealth` in Neovim.

## Credits

Built on [LazyVim](https://github.com/LazyVim/LazyVim) - A Neovim config starter template.
