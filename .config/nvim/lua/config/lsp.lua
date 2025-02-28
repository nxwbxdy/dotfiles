local M = {}

local tscope_builtin = require "telescope.builtin"
vim.lsp.set_log_level('INFO')

local keymaps = {
  { "textDocument/formatting", {
    ["<leader><leader>f"] = { vim.lsp.buf.format, "formats files" } }
  },
  { "textDocument/publishDiagnostics", {
    ["gl"] = { vim.diagnostic.open_float, "opens diagnostic float" } }
  },
  { "textDocument/reference", {
    -- ["<leader>gd"] = { vim.lsp.buf.definition, "goes to definition" },
    ["<leader>gd"] = { tscope_builtin.lsp_definitions, "goes to definition" },
    ["<leader>gD"] = { vim.lsp.buf.declaration, "goes to declaration" },
    ["grr"] = { tscope_builtin.lsp_references, "goes to references" },
  }
  },
  { "textDocument/implementation", {
    -- ["<leader>gi"] = { vim.lsp.buf.implementation, "goes to implementation" } }
    ["<leader>gi"] = { tscope_builtin.lsp_implementations, "goes to implementation" } }
  },
  { "callHierarchy/incomingCalls", {
    ["<leader>gI"] = { vim.lsp.buf.incoming_calls, "lists incoming calls" } }
  },
  { "callHierarchy/outgoingCalls", {
    ["<leader>gO"] = { vim.lsp.buf.outgoing_calls, "lists outgoing calls" } }
  },
  { "textDocument.inlayHint", {
    ["<leader>H"] = { function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end } }
  },
  { "textDocument/codeAction", {
    ["<leader>ca"] = { vim.lsp.buf.code_action, "code actions" }
  }
  }
}

-- Set up LSP servers and capabilities
M.setup = function()
  local servers = {
    lua_ls = {},
    clangd = {},
    basedpyright = {
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
    },
    rust_analyzer = {
      settings = {
        ['rust-analyzer'] = {
          diagnostics = {
            enable = true,
          },
          inlayHints = {
            enable = true,
            typeHints = true,
            parameterHints = true,
            chainingHints = true,
          }
        }
      }
    },
    superhtml = {
      filetypes = { 'superhtml' }
    },
    bashls = {
      cmd = { "bash-language-server", "start" },
      filetypes = { "bash", "sh" },
      single_file_support = true,
      settings = {
        ['bash-language-server'] = {}
      },
    }
  }

  local lspconfig = require("lspconfig")
  local capabilities = require("blink.cmp").get_lsp_capabilities()

  for server, conf in pairs(servers) do
    local opts = vim.tbl_deep_extend('force', { capabilities = capabilities }, conf)
    lspconfig[server].setup(opts)
  end

  -- Set up LSP-specific keymaps and autocmds
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("Lsp Attach Group", { clear = true }),
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if not client then return end


      local nmap = function(keyc, func, doc)
        if doc ~= "" then
          vim.keymap.set("n", keyc, func, { buffer = args.buf, remap = false, desc = doc })
        else
          vim.keymap.set("n", keyc, func, { buffer = args.buf, remap = false })
        end
      end

      local set_supported = function(supported_method, maps)
        if client:supports_method(supported_method) then
          for key, keyconf in pairs(maps) do
            local doc = keyconf[2]
            local func = keyconf[1]
            nmap(key, func, doc)
          end
        end
      end

      for _, keys in ipairs(keymaps) do
        local supported_method = keys[1]
        local maps = keys[2]
        set_supported(supported_method, maps)
      end

      vim.lsp.inlay_hint.enable(true)

      -- vim.lsp.inlay_hint.enable(true, {bufnr = args.buf})
      -- vim.keymap.set("n", "<leader>ti", function ()
      --   vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
      -- end, {buffer = args.buf, noremap = false, desc = "toggle inlay hints"})

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

      if vim.bo[args.buf].filetype == "rust" then
        vim.keymap.set("n", "<leader>r", function()
          vim.cmd("w")
          vim.cmd("vs | terminal cargo run")
        end, { buffer = args.buf, desc = "Run cargo project" })
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

-- return M
M.setup()

--:vs | terminal source ~/Documents/FHH/SEM3/FTK/ftkv/bin/activate && python %
