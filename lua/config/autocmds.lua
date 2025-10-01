-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Enable spell checking for text files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "text", "gitcommit" },
  callback = function()
    vim.opt_local.spell = true
  end,
})

-- VSCode compatibility: Organize imports on save
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("organize_imports", { clear = true }),
  pattern = { "*.ts", "*.tsx", "*.js", "*.jsx", "*.py", "*.go", "*.rs" },
  callback = function()
    -- Try to organize imports using LSP
    local params = {
      command = "_typescript.organizeImports",
      arguments = { vim.api.nvim_buf_get_name(0) },
    }
    
    -- For TypeScript/JavaScript
    if vim.bo.filetype == "typescript" or vim.bo.filetype == "typescriptreact" or 
       vim.bo.filetype == "javascript" or vim.bo.filetype == "javascriptreact" then
      vim.lsp.buf.execute_command(params)
    else
      -- For other languages, try generic organize imports
      local clients = vim.lsp.get_clients({ bufnr = 0 })
      for _, client in ipairs(clients) do
        if client.supports_method("textDocument/codeAction") then
          local context = { only = { "source.organizeImports" } }
          local params = vim.lsp.util.make_range_params()
          params.context = context
          
          client.request("textDocument/codeAction", params, function(err, result)
            if err or not result then return end
            for _, action in ipairs(result) do
              if action.edit then
                vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
              elseif action.command then
                vim.lsp.buf.execute_command(action.command)
              end
            end
          end, 0)
        end
      end
    end
  end,
})
