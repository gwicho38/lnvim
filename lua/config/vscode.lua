-- Minimal VSCode extension support
-- NOTE: This configuration provides basic Neovim functionality when running inside VSCode
-- Most plugins and features are disabled in VSCode mode for optimal performance
-- For full functionality, use regular Neovim (not VSCode extension)

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Minimal plugin setup for VSCode
require("lazy").setup({
  -- Only load essential text manipulation plugins
  { "tpope/vim-surround", event = "VeryLazy" },
  { "tpope/vim-repeat", event = "VeryLazy" },
})

-- Basic settings for VSCode compatibility
vim.opt.clipboard = "unnamedplus"

-- VSCode extension handles most keybindings and UI
-- For advanced customization, consider using regular Neovim instead
