# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a **LazyVim-based** Neovim configuration that follows a modular approach built on lazy.nvim plugin manager. The configuration supports dual-mode operation for both regular Neovim and VSCode extension usage.

**Core Structure:**
- `init.lua` - Entry point that bootstraps the configuration based on environment (VSCode vs Neovim)
- `lua/config/` - Core configuration modules (lazy.lua, keymaps.lua, options.lua, autocmds.lua, vscode.lua)
- `lua/plugins/` - Individual plugin configurations (50+ plugins organized as separate files)
- `lazy-lock.json` - Plugin version lockfile for reproducible installations

**Plugin Management:**
- Uses lazy.nvim with LazyVim framework providing sensible defaults
- Plugins are lazy-loaded based on events, filetypes, or commands
- LazyVim core plugins loaded via `{ "LazyVim/LazyVim", import = "lazyvim.plugins" }`
- Custom plugins loaded via `{ import = "plugins" }` pattern
- Override pattern: custom plugin specs in `lua/plugins/` override LazyVim defaults

## Common Development Commands

### Plugin Management
- `:Lazy` - Open lazy.nvim plugin manager interface (install/uninstall/update plugins)
- `:Lazy update` - Update all plugins
- `:Lazy sync` - Synchronize plugins with lazy-lock.json
- `:Lazy clean` - Remove unused plugins
- `:LazyExtras` - Browse and install curated plugin collections (LazyVim extras)
- `<leader>fP` - Find plugins via Telescope (telescope-lazy.nvim)
- `:PluginTemplate` - Create new plugin template

### Code Formatting
- `<leader>cf` - Format current buffer/selection (uses LazyVim.format)
- Uses stylua for Lua formatting with settings: 2-space indent, 120 column width

### Claude Code Integration
- `<C-,>` - Toggle Claude Code terminal (both normal and terminal mode)
- `<leader>cC` - Continue most recent Claude Code conversation
- `<leader>cV` - Launch Claude Code with verbose output
- Terminal opens in botright position with 30% screen ratio
- Automatically sets CWD to git root when in git project

### Git Operations
- `<leader>gg` - Lazygit (git root directory)
- `<leader>gG` - Lazygit (current working directory) 
- `<leader>gf` - Git log for current file
- `<leader>gl` - Git log (git root)
- `<leader>gb` - Git blame current line
- `<leader>gB` - Git browse (open in browser)
- `<leader>gY` - Git browse (copy URL to clipboard)

### Diagnostics and LSP
- `<leader>cd` - Show line diagnostics
- `]d` / `[d` - Next/previous diagnostic
- `]e` / `[e` - Next/previous error
- `]w` / `[w` - Next/previous warning

### File Operations
- `<leader>fn` - Create new file
- `<C-s>` - Save file (works in insert, normal, visual, select modes)

## Key Configuration Patterns

### Plugin Configuration Structure
```lua
return {
  "plugin/repo",
  opts = { ... },          -- Plugin options
  keys = { ... },          -- Lazy-loaded keymaps
  ft = "filetype",         -- Load on filetype
  event = "Event",         -- Load on event
  dependencies = { ... },   -- Plugin dependencies
  config = function() ... end  -- Custom setup function
}
```

### Keymap Conventions
- **Leader key:** Space (LazyVim default)
- **Window navigation:** `<C-h/j/k/l>` 
- **Buffer management:** `<S-h/l>` for previous/next buffer
- **Window splitting:** `<leader>-` (horizontal), `<leader>|` (vertical)
- **Toggle options:** `<leader>u` prefix (e.g., `<leader>uf` for format toggle)

### LazyVim Override Pattern
- LazyVim provides comprehensive defaults
- Custom configurations in `lua/plugins/` extend or override defaults
- Minimal core configuration files rely on LazyVim defaults
- Plugin-specific customizations use the `opts` table or `config` function

## Important Features

### AI Coding Integration
- **Claude Code:** Integrated terminal with `<C-,>` toggle, auto-refresh on file changes
- **GitHub Copilot:** Available with custom keybindings (some keymaps currently commented out)
- **Gen.nvim:** Additional AI text generation capabilities

### Note-taking and Documentation
- **Obsidian integration:** Configured for personal knowledge management
- **Markdown support:** Multiple markdown plugins for documentation workflow
- **Note-taking optimized:** Features like conceallevel toggles and markdown-specific keymaps

### Development Environment
- **LSP:** Mason for language server management with comprehensive LSP features
- **Git integration:** Lazygit, Gitsigns, and git-aware operations throughout
- **Terminal:** Snacks.terminal integration with floating and split options
- **Performance:** Optimized with selective runtime plugin disabling

## Testing and Linting

No specific test framework or linting setup is configured beyond LazyVim defaults. The configuration relies on:
- LSP diagnostics for code analysis
- LazyVim's built-in formatting via `<leader>cf`
- stylua configuration for Lua code formatting (when available)

When working with this configuration, check for the presence of language-specific tooling through LSP or Mason installations rather than assuming specific test commands.