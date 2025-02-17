return {
  {
    'saghen/blink.cmp',
    dependencies =
    {
      'echasnovski/mini.snippets',
      'echasnovski/mini.icons',
      'Kaiser-Yang/blink-cmp-git'
    },

    version = '*',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' for mappings similar to built-in completion
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
      -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
      -- See the full "keymap" documentation for information on defining your own keymap.
      keymap = {
        preset = 'default',
        ['<C-g>'] = { 'show' },
        ['<C-e>'] = { 'hide' },
        -- ['<C-y>'] = { 'select_and_accept' },
        ['<C-y>'] = { 'accept' },

        ['<C-p>'] = { 'select_prev', 'fallback' },
        ['<C-n>'] = { 'select_next', 'fallback' },

        ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

        ['<C-l>'] = { 'snippet_forward', 'fallback' },
        ['<C-h>'] = { 'snippet_backward', 'fallback' },

        ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
        ['<C-j>'] = { 'show_documentation', 'hide_documentation' }
      },

      cmdline = {
        keymap = {
          preset = 'default',
          ['<CR>'] = { 'accept_and_enter', 'fallback' }
        }
      },

      appearance = {
        -- Will be removed in a future release
        use_nvim_cmp_as_default = false,
        nerd_font_variant = 'mono'
      },

      completion = {
        documentation = {
          auto_show = false,
          window = {
            border = 'double',
            desired_min_height = 10,
            desired_min_width = 10,
            min_width = 20,
            scrollbar = true,
          }
        },
        list = { selection = { preselect = true, auto_insert = false } },
        -- ghost_text = {
        --   enabled = true,
        --   show_with_selection = true,
        --   show_without_selection = true
        -- },
        menu = {
          enabled = true,
          direction_priority = { "n", "s" },
          draw = {
            components = {
              kind_icon = {
                ellipsis = true,
                text = function(ctx)
                  local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
                  return kind_icon
                end,
                -- Optionally, you may also use the highlights from mini.icons
                highlight = function(ctx)
                  local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                  return hl
                end,
              }
            },
            columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind", gap = 2 } }
          }
        },
        accept = {
          create_undo_point = true,
          auto_brackets = {
            -- maybe
            enabled = true
          }
        }
      },


      signature = {
        enabled = true,
        window = {
          show_documentation = true
        }
      },

      snippets = { preset = 'mini_snippets' },

      sources = {
        default = { 'git', 'lsp', 'path', 'snippets', 'buffer' },
        providers = {
          git = {
            module = 'blink-cmp-git',
            name = 'Git',
            enabled = function()
              return vim.tbl_contains({ 'octo', 'gitcommit', 'markdown' }, vim.bo.filetype)
            end,
            opts = {
              commit = {
                triggers = { '#', ':' }
              }
            }
          }
        }
      },

    },
    opts_extend = { "sources.default" }
  }
}
