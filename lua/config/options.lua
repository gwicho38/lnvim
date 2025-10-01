-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- VSCode compatibility settings
vim.opt.clipboard = "unnamedplus" -- Use system clipboard
vim.opt.guicursor = "n-v-c:block-Cursor/lCursor,i-ci-ve:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor,o:hor50-Cursor/lCursor"

-- Spell checking
vim.opt.spelllang = "en_us"
vim.opt.spellfile = vim.fn.stdpath("config") .. "/spell/en.utf-8.add" -- Global dictionary

-- Disable minimap-like features for VSCode consistency
vim.opt.list = false -- Don't show whitespace characters by default
vim.opt.winbar = "" -- Disable winbar (similar to disabling minimap)

-- Set cursor color (VSCode compatibility)
vim.cmd([[
  highlight Cursor guifg=NONE guibg=#e9dbb7
  highlight lCursor guifg=NONE guibg=#e9dbb7
]])
