return {
  {
    'saghen/blink.cmp',
    dependencies = 'rafamadriz/friendly-snippets',

    version = '*',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' for mappings similar to built-in completion
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
      -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
      -- See the full "keymap" documentation for information on defining your own keymap.
      keymap = {
        preset = 'none',
        ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
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
      },

      appearance = {
        -- Will be removed in a future release
        use_nvim_cmp_as_default = false,
        nerd_font_variant = 'mono'
      },

      completion = {
        list = { selection = { preselect = true, auto_insert = false } },
        ghost_text = { 
          enabled = true,
          show_with_selection = true,
          show_without_selection = true
        },
        menu = {
          draw = { columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind", gap = 2 } } }
        },
        accept = {
          create_undo_point = true,
          auto_brackets = {
            -- maybe
            enabled = true
          }
        }
      },

      signature = { enabled = true },

      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
    },
    opts_extend = { "sources.default" }
  }
}
