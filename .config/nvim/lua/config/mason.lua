local M = {}

M.setup = function()
  -- Initialize Mason
  require("mason").setup()

  -- Initialize Mason-LSPConfig
  local mason_lspconfig = require("mason-lspconfig")

  -- List of servers to ensure installed
  local servers = {
    "lua_ls",       -- Lua
    "clangd",       -- C/C++
    "basedpyright", -- Python
    --"tsserver",     -- TypeScript/JavaScript
    --"cssls",        -- CSS
  }

  -- Automatically install servers
  mason_lspconfig.setup {
    ensure_installed = servers,
    automatic_installation = true, -- Auto-install missing servers
  }

  -- Set up LSP servers via lspconfig
  mason_lspconfig.setup_handlers({
    function(server_name)
      local lspconfig = require("lspconfig")
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      if server_name == "basedpyright" then
        lspconfig[server_name].setup {
          capabilities = capabilities,
          settings = {
            basedpyright = {
              analysis = {
                inlayHints = {
                  genericTypes = true,
                  variableTypes = true,
                  functionReturnTypes = true
                }
              }
            }
          }
        }
      else
        lspconfig[server_name].setup {
          capabilities = capabilities,
        }
      end
    end,
  })
end

return M
