-- Enhanced markdown rendering for better visual experience
return {
  "MeanderingProgrammer/render-markdown.nvim",
  opts = {
    file_types = { "markdown", "Avante" },
  },
  ft = { "markdown", "Avante" },
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" },
}
