-- bootstrap lazy.nvim, LazyVim and your plugins

if vim.g.vscode then
  -- VSCode extension
  require("config.vscode")
else
  -- ordinary Neovim
  require("config.lazy")
end
