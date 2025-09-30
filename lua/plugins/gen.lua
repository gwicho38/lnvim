return {
  "David-Kunz/gen.nvim",
  cmd = { "Gen" },
  keys = {
    { "<leader>ag", ":Gen<CR>", mode = { "n", "v" }, desc = "AI Generate" },
  },
  opts = function()
    -- Check if ollama is installed
    local has_ollama = vim.fn.executable("ollama") == 1

    return {
      model = "llama3.2:latest", -- Updated default model
      display_mode = "split", -- horizontal split for output
      show_model = true,
      no_auto_close = true,
      init = function()
        if not has_ollama then
          vim.notify(
            "Ollama not found. Install from https://ollama.ai or disable gen.nvim",
            vim.log.levels.WARN
          )
        end
      end,
    }
  end,
}
