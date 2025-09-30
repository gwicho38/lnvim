# Troubleshooting Guide

## Common Issues

### Plugins Won't Install

**Symptom:** `:Lazy` shows errors or plugins fail to install.

**Solutions:**
1. Check internet connection
2. Clear plugin cache:
   ```bash
   rm -rf ~/.local/share/nvim/lazy
   ```
3. Re-run installation:
   ```bash
   nvim --headless "+Lazy! sync" +qa
   ```
4. Check git credentials for private repos

### LSP Not Working

**Symptom:** No code completion, diagnostics, or go-to-definition.

**Solutions:**
1. Check if LSP server is installed:
   ```vim
   :Mason
   ```
2. Check LSP status:
   ```vim
   :LspInfo
   ```
3. Manually install missing servers:
   ```vim
   :MasonInstall lua-language-server typescript-language-server
   ```
4. Restart LSP:
   ```vim
   :LspRestart
   ```

### Claude Code Not Working

**Symptom:** `<C-,>` doesn't open Claude terminal or shows errors.

**Solutions:**
1. Verify Claude CLI is installed:
   ```bash
   ~/.claude/local/claude --version
   ```
2. Check authentication:
   ```bash
   ~/.claude/local/claude auth status
   ```
3. Re-authenticate if needed:
   ```bash
   ~/.claude/local/claude auth login
   ```
4. Check plugin loaded:
   ```vim
   :lua print(vim.inspect(require('lazy').plugins()['claude-code.nvim']))
   ```

### Copilot Not Suggesting

**Symptom:** No Copilot suggestions appear.

**Solutions:**
1. Check Copilot status:
   ```vim
   :Copilot status
   ```
2. Enable if disabled:
   ```vim
   :Copilot enable
   ```
3. Sign in to GitHub:
   ```vim
   :Copilot setup
   ```
4. Check network/firewall settings
5. Accept suggestions with `<C-J>` not `<Tab>`

### Formatters Not Working

**Symptom:** Code doesn't format on save or with `<leader>cf`.

**Solutions:**
1. Check conform.nvim status:
   ```vim
   :ConformInfo
   ```
2. Install missing formatters:
   ```vim
   :MasonInstall stylua prettier black
   ```
3. Check file type is supported:
   ```vim
   :set filetype?
   ```
4. Manually format:
   ```vim
   :lua LazyVim.format({ force = true })
   ```

### Colorscheme Issues

**Symptom:** Colors look wrong or colorscheme won't load.

**Solutions:**
1. Check terminal supports true color:
   ```bash
   echo $COLORTERM
   ```
   Should output `truecolor` or `24bit`

2. Enable true color in terminal settings

3. Test colorscheme manually:
   ```vim
   :colorscheme gruvbox
   ```

4. Check plugin is installed:
   ```vim
   :Lazy
   ```

### Hot Reload Not Working

**Symptom:** F3-F8 keys don't trigger hot reload.

**Solutions:**
1. Check hot.nvim is loaded:
   ```vim
   :lua print(vim.inspect(package.loaded.hot))
   ```
2. Verify pattern matches your file:
   ```vim
   :lua print(vim.inspect(Pattern))
   ```
3. Check terminal sends F-keys correctly
4. Try manual restart:
   ```vim
   :lua require("hot").restart()
   ```

### Import Organization Conflicts

**Symptom:** Imports get messed up or conflicts on save.

**Solutions:**
1. Disable auto-organize temporarily:
   ```vim
   :autocmd! organize_imports
   ```
2. Check LSP supports organize imports:
   ```vim
   :LspInfo
   ```
3. Manually organize:
   ```vim
   :lua vim.lsp.buf.code_action({context = {only = {"source.organizeImports"}}})
   ```

## Performance Issues

### Slow Startup

**Solutions:**
1. Check startup time:
   ```bash
   nvim --startuptime startup.log +qa
   ```
2. Review slow plugins in log
3. Lazy-load more plugins
4. Disable unused plugins

### Slow Editing

**Solutions:**
1. Check treesitter parsing:
   ```vim
   :TSDisable highlight
   ```
2. Disable LSP diagnostics temporarily:
   ```vim
   :lua vim.diagnostic.disable()
   ```
3. Check for large files (> 1MB)
4. Reduce `updatetime`:
   ```vim
   :set updatetime=300
   ```

## Debugging Tips

### Enable Verbose Logging

```bash
nvim --cmd "set verbose=9" --cmd "set verbosefile=nvim.log"
```

### Check Loaded Plugins

```vim
:lua print(vim.inspect(require('lazy').plugins()))
```

### Check Keymaps

```vim
:Telescope keymaps
```

Or use hawtkeys:
```vim
:Hawtkeys
:HawtkeysDupes
```

### Check Autocmds

```vim
:autocmd
```

### Lua Error Inspection

```vim
:messages
:lua vim.cmd('messages clear')
```

### Reset to Defaults

Backup and remove config:
```bash
mv ~/.config/nvim ~/.config/nvim.backup
mv ~/.local/share/nvim ~/.local/share/nvim.backup
```

Fresh install:
```bash
git clone https://github.com/gwicho38/lnvim.git ~/.config/nvim
nvim
```

## Getting Help

1. Check `:checkhealth`
2. Review `:Lazy` plugin status
3. Search existing [GitHub issues](https://github.com/gwicho38/lnvim/issues)
4. Create new issue with:
   - Neovim version: `nvim --version`
   - Config commit: `git rev-parse HEAD`
   - Error messages from `:messages`
   - Relevant sections of `nvim.log`

## Common Error Messages

### `module 'X' not found`
**Solution:** Plugin not installed or not loaded yet. Run `:Lazy sync`.

### `LSP: no client attached`
**Solution:** LSP server not running. Check `:LspInfo` and `:Mason`.

### `E117: Unknown function`
**Solution:** Plugin providing function not loaded. Check lazy-loading config.

### `attempt to index nil value`
**Solution:** Variable or module is nil. Check plugin load order and dependencies.
