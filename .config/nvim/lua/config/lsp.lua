local M = {}

-- Set up LSP servers and capabilities
M.setup = function()
  local lspconfig = require("lspconfig")
  local capabilities = require("blink.cmp").get_lsp_capabilities()
  --
  -- Configure Lua LSP
  lspconfig.lua_ls.setup {
    capabilities = capabilities,
  }

  -- Configure Clangd
  lspconfig.clangd.setup {
    capabilities = capabilities,
  }

  lspconfig.basedpyright.setup {
    capabilities = capabilities
  }

  lspconfig.rust_analyzer.setup{
    capabilities = capabilities
  }

  lspconfig.superhtml.setup {
    capabilities = capabilities,
    filetypes = { 'superhtml' }
  }

  -- Set up LSP-specific keymaps and autocmds
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if not client then return end

      vim.lsp.inlay_hint.enable(true)

      -- Add keymap for formatting if the client supports it
      if client:supports_method("textDocument/formatting") then
        vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { buffer = args.buf, remap = false })
      end

      -- Add keymap for diagnostics if the client supports it
      if client:supports_method("textDocument/publishDiagnostics") then
        vim.keymap.set("n", "gl", vim.diagnostic.open_float, { buffer = args.buf, remap = false })
      end

      -- Add keymap for code actions if the client supports it
      if client:supports_method("textDocument/codeAction") then
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = args.buf, remap = false })
      end

      -- Language specific
      -- -- Add this at the top of the file:
      -- local inlay_hint_highlight = vim.api.nvim_create_augroup("InlayHintHighlight", {})
      --
      -- -- Inside the LspAttach autocmd callback:
      -- if client.name == "basedpyright" then
      --   -- Enable inlay hints for Python buffers
      -- vim.lsp.inlay_hint.enable(true)
      -- end

      -- Python-specific keybinds
      if vim.bo[args.buf].filetype == "python" then
        -- Run current file
        vim.keymap.set("n", "<leader>py", function()
          vim.cmd("w")
          vim.cmd("vs | terminal source ~/Documents/FHH/SEM3/FTK/ftkv/bin/activate && python3 %")
        end, { buffer = args.buf, desc = "Run Python file" })

        -- -- Send visual selection to Python
        -- vim.keymap.set("v", "<leader>sv", ":<C-u>'<,'>w !python3<CR>",
        --   { buffer = args.buf, desc = "Send visual selection to Python" })
        --
        -- -- Jupyter cell execution (if using jupyter-repl)
        -- vim.keymap.set("n", "<leader>jc", "o# %%<Esc>",
        --   { buffer = args.buf, desc = "Insert Jupyter cell" })
      end

      if vim.bo[args.buf].filetype == "sh" then
        -- Run current file
        vim.keymap.set("n", "<leader>r", function()
          vim.cmd("w")
          vim.cmd("vs | terminal ./%")
        end, { buffer = args.buf, desc = "Run Bash file" })
      end
    end,
  })
end

return M

--:vs | terminal source ~/Documents/FHH/SEM3/FTK/ftkv/bin/activate && python %
