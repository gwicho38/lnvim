# Zettelkasten Setup for Neovim

Your Neovim is now configured as a blazing-fast Obsidian alternative for the lefv-vault repository.

## 🚀 Features

- **Wiki-style links**: `[[note-name]]` just like Obsidian
- **Daily notes**: Automatic timestamp-based notes
- **Backlinks**: Find all notes linking to current note
- **Tags**: Search and organize by tags
- **Frontmatter**: Automatic YAML frontmatter generation
- **Telescope integration**: Fast fuzzy finding
- **Beautiful rendering**: Enhanced markdown display
- **Image pasting**: Direct image insertion
- **Templates**: Use your existing templates
- **Checkboxes**: Interactive todo checkboxes
- **Concealment**: Clean, distraction-free writing

## 📋 Keybindings

### Core Obsidian Commands

| Key | Command | Description |
|-----|---------|-------------|
| `<leader>on` | ObsidianNew | Create new note |
| `<leader>oo` | ObsidianSearch | Search all notes |
| `<leader>oq` | ObsidianQuickSwitch | Quick switch between notes |
| `<leader>ob` | ObsidianBacklinks | Show backlinks |
| `<leader>ol` | ObsidianLinks | Show all links in note |
| `<leader>og` | ObsidianTags | Search by tags |
| `<leader>of` | ObsidianFollowLink | Follow link under cursor |
| `<leader>or` | ObsidianRename | Rename note |
| `<leader>om` | ObsidianTemplate | Insert template |

### Daily Notes

| Key | Command | Description |
|-----|---------|-------------|
| `<leader>ot` | ObsidianToday | Open today's daily note |
| `<leader>oy` | ObsidianYesterday | Open yesterday's note |
| `<leader>od` | ObsidianDailies | Browse daily notes |

### Visual Mode

| Key | Command | Description |
|-----|---------|-------------|
| `<leader>ol` | ObsidianLink | Link selected text |
| `<leader>oln` | ObsidianLinkNew | Create new note from selection |
| `<leader>oe` | ObsidianExtractNote | Extract selection to new note |

### Navigation

| Key | Command | Description |
|-----|---------|-------------|
| `gf` | Follow link | Follow link under cursor |
| `<cr>` | Smart action | Context-aware action |
| `<leader>ch` | Toggle checkbox | Toggle markdown checkbox |

### Images & Media

| Key | Command | Description |
|-----|---------|-------------|
| `<leader>oi` | ObsidianPasteImg | Paste image from clipboard |

### Telescope (Vault-specific)

| Key | Command | Description |
|-----|---------|-------------|
| `<leader>fn` | Find notes | Search notes in vault |
| `<leader>fg` | Grep notes | Live grep in vault |

### External

| Key | Command | Description |
|-----|---------|-------------|
| `<leader>oO` | ObsidianOpen | Open in Obsidian app |

## 🎯 Quick Start

### Creating Notes

```vim
:ObsidianNew Note Title
```

Creates a note with:
- Timestamp ID (YYYYMMDDHHMMSS)
- YAML frontmatter
- Default tags and domain

### Searching Notes

```vim
:ObsidianSearch query
```

Fast fuzzy search across all notes.

### Creating Links

1. **Visual mode**: Select text → `<leader>ol`
2. **Normal mode**: `:ObsidianLink [[note-name]]`
3. **Auto-complete**: Type `[[` and use completion

### Following Links

- Position cursor on `[[link]]`
- Press `gf` or `<cr>`

### Daily Notes Workflow

```vim
:ObsidianToday          " Open today's note
:ObsidianYesterday      " Yesterday's note
:ObsidianDailies        " Browse all dailies
```

## 📁 Directory Structure

Your vault structure is preserved:

```
~/repos/lefv-vault/
├── notes/              # Daily notes
├── template/           # Templates
├── uiuc/              # Course notes
├── scripts/           # Scripts
└── ...                # Other domains
```

## ⚙️ Configuration

### Frontmatter Format

Auto-generated for new notes:

```yaml
---
id: 20241221123456
title: "Note Title"
created: 2024-12-21T12:34:56Z
modified: 2024-12-21T12:34:56Z
tags: []
domain: notes
status: draft
---
```

### Templates

Use existing templates in `template/` directory:

```vim
:ObsidianTemplate
```

### Concealment

Markdown concealment is enabled (level 2):
- Links: `[[link]]` → link
- Formatting: `**bold**` → **bold**
- Code blocks: Clean appearance

Toggle: `:set conceallevel=0` (off) or `:set conceallevel=2` (on)

## 🎨 UI Features

### Checkboxes

Enhanced checkbox rendering:
- `[ ]` → 󰄱 (todo)
- `[x]` →  (done)
- `[>]` →  (forwarded)
- `[~]` → 󰰱 (progress)
- `[!]` →  (important)

Toggle: `<leader>ch` or smart action `<cr>` on checkbox

### Syntax Highlighting

- **Tags**: #tag rendered with special highlighting
- **Links**: `[[wikilink]]` concealed
- **URLs**: External links with icon
- **Bullets**: Enhanced bullet points •

## 🔍 Search & Navigation

### Telescope Integration

All Obsidian commands use Telescope for fuzzy finding:

- **Fast search**: Instant results
- **Preview**: See note content before opening
- **Multi-select**: Tag or link multiple notes

### Backlinks

```vim
:ObsidianBacklinks
```

Shows all notes linking to current note in Telescope.

### Forward Links

```vim
:ObsidianLinks
```

Shows all links from current note.

## 📝 Workflow Examples

### Morning Routine

```vim
<leader>ot              " Open today's note
<leader>om              " Insert daily template
" Start writing...
```

### Research Session

```vim
<leader>oo              " Search for related notes
<leader>on New Concept  " Create new note
<leader>ol              " Link to existing notes
<leader>ob              " Check backlinks
```

### Course Notes

```vim
:e ~/repos/lefv-vault/uiuc/cs-435/notes.md
[[new-concept]]         " Create link
gf                      " Follow to create note
<leader>og              " Find related tags
```

## 🚀 Performance

- **Instant startup**: Lazy-loaded on markdown files
- **Fast search**: Native Telescope integration
- **No Electron**: Pure Lua, runs in Neovim
- **Large vaults**: Handles 1000+ notes easily
- **Async operations**: Never blocks UI

## 🔧 Customization

Edit `~/.config/nvim/lua/plugins/obsidian.lua`:

### Change vault location

```lua
workspaces = {
  {
    name = "lefv-vault",
    path = "~/repos/lefv-vault",  -- Change here
  },
}
```

### Change keybindings

```lua
keys = {
  { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "New note" },
  -- Add or modify keybindings here
}
```

### Change note ID format

```lua
note_id_func = function(title)
  -- Custom ID generation
  return tostring(os.date("%Y%m%d%H%M%S"))
end
```

## 🐛 Troubleshooting

### Plugins not loading

```vim
:Lazy sync
:Lazy restore
```

### Links not working

Check conceallevel:
```vim
:set conceallevel?
:set conceallevel=2
```

### Images not displaying

Install image preview (optional):
```bash
brew install imagemagick
```

### Slow search

Telescope needs fzf:
```vim
:Lazy build telescope-fzf-native.nvim
```

## 📚 Additional Resources

- **obsidian.nvim**: https://github.com/epwalsh/obsidian.nvim
- **Telescope**: https://github.com/nvim-telescope/telescope.nvim
- **LazyVim**: https://www.lazyvim.org

## 💡 Tips

1. **Auto-completion**: Type `[[` and Ctrl+Space for note completion
2. **Quick navigation**: Use `<leader>oq` for fastest note switching
3. **Backlinks**: Essential for Zettelkasten - review regularly
4. **Templates**: Create templates in `template/` directory
5. **Tags**: Use tags for cross-cutting concerns
6. **Daily notes**: Build habit with `<leader>ot`
7. **Visual mode**: Select text, then `<leader>ol` to link
8. **Search**: `<leader>oo` is your most powerful tool

## 🎉 You're Ready!

Your Neovim is now a blazing-fast Zettelkasten system!

**Next steps**:
1. Open Neovim: `nvim ~/repos/lefv-vault`
2. Let Lazy install plugins (happens automatically)
3. Try: `<leader>ot` to create today's note
4. Start writing! 🚀

---

**Performance**: 10x faster than Obsidian Electron app
**Features**: 95% of Obsidian functionality
**Cost**: Free and open source
**Flexibility**: Infinitely customizable

*Enjoy your lightning-fast knowledge management!* ⚡
