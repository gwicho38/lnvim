return {
  "chipsenkbeil/distant.nvim",
  branch = "v0.3",
  config = function()
    require("distant").setup({
      ["*"] = {
        -- Default server configuration
        server = {
          -- Automatically start server if not already running
          auto_start = true,
          -- Timeout for network operations in seconds
          timeout = 10,
          -- Path to distant executable (default assumes it's in $PATH)
          cmd = "distant",
        },
        -- Default session configuration
        session = {
          -- Enable clipboard synchronization
          clipboard = true,
          -- Map remote paths to local paths
          paths = {
            -- Example: map remote home to local home
            -- ["~/"] = vim.fn.expand("~")
          }
        }
      }
    })
  end,
}
