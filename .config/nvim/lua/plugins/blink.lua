local function mention_configure_score_offset(items)
  local users = { '@s2310239018', '@s2310239021', '@P42249' }
  local bonus = 999999
  local bonus_scores = {}

  for offset, user in ipairs(users) do
    bonus_scores[user] = bonus - offset
  end

  for i = 1, #items do
    local bonus_key = items[i].insert_text
    if bonus_scores[bonus_key] then
      items[i].score_offset = bonus_scores[bonus_key]
    end
  end

end
local function pr_or_issue_configure_score_offset(items)
  -- Bonus to make sure items sorted as below:
  local keys = {
    -- place `kind_name` here
    { 'openIssue',     'openedIssue', 'reopenedIssue' },
    { 'openPR',        'openedPR' },
    { 'lockedIssue',   'lockedPR' },
    { 'completedIssue' },
    { 'draftPR' },
    { 'mergedPR' },
    { 'closedPR',      'closedIssue', 'not_plannedIssue', 'duplicateIssue' },
  }
  local bonus = 999999
  local bonus_score = {}
  for i = 1, #keys do
    for _, key in ipairs(keys[i]) do
      bonus_score[key] = bonus * (#keys - i)
    end
  end
  for i = 1, #items do
    local bonus_key = items[i].kind_name
    if bonus_score[bonus_key] then
      items[i].score_offset = bonus_score[bonus_key]
    end
    -- sort by number when having the same bonus score
    local number = items[i].label:match('[#!](%d+)')
    if number then
      if items[i].score_offset == nil then
        items[i].score_offset = 0
      end
      items[i].score_offset = items[i].score_offset + tonumber(number)
    end
  end
end

return {
  'saghen/blink.cmp',
  -- optional: provides snippets for the snippet source
  dependencies = {
    'echasnovski/mini.snippets',
    'echasnovski/mini.icons',
    {
      'Kaiser-Yang/blink-cmp-git',
      -- dir = "~/code/lua/blink-cmp-git_new_master/blink-cmp-git/",
      -- dir = "~/code/lua/blink-cmp-git/",
      -- dir = "~/code/lua/blink-cmp-git_new_master/blink-cmp-git/",
      dependencies = {
        'nvim-lua/plenary.nvim',
      }
    }
  },

  -- use a release tag to download pre-built binaries
  version = '*',
  -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
  -- build = 'cargo build --release',
  -- If you use nix, you can build from source using latest nightly rust with:
  -- build = 'nix run .#build-plugin',

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

      ['<C-i>'] = { 'show_signature', 'hide_signature', 'fallback' },
      ['<C-j>'] = { 'show_documentation', 'hide_documentation' },

      ['<Tab>'] = { 'fallback'},
      ['<S-Tab>'] = { 'fallback'},
    },

    appearance = {
      -- Sets the fallback highlight groups to nvim-cmp's highlight groups
      -- Useful for when your theme doesn't support blink.cmp
      -- Will be removed in a future release
      use_nvim_cmp_as_default = false,
      -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono',
      -- kind_icons = {
      --   Snippet = '󱄽',
      -- }
    },

    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = { 'git', 'lsp', 'path', 'snippets', 'buffer' },
      providers = {
        git = {
          module = 'blink-cmp-git',
          name = 'Git',
          -- only enable this source when filetype is gitcommit, markdown, or 'octo'
          enabled = function()
            return vim.tbl_contains({ 'octo', 'gitcommit', 'markdown' }, vim.bo.filetype)
          end,
          --- @module 'blink-cmp-git'
          --- @type blink-cmp-git.Options
          opts = {
            kind_icons = {
              openPR = ' ',
              openedPR = ' ',
              closedPR = ' ',
              mergedPR = ' ',
              draftPR = ' ',
              lockedPR = ' ',
              openIssue = ' ',
              openedIssue = ' ',
              reopenedIssue = ' ',
              completedIssue = ' ',
              closedIssue = ' ',
              not_plannedIssue = ' ',
              duplicateIssue = ' ',
              lockedIssue = ' ',
            },
            commit = {
              triggers = { ':' }
            },
            git_centers = {
              gitlab = {
                issue = {
                  enable = function()
                    -- Get the default enable result
                    local enable = require('blink-cmp-git.default.gitlab')
                        .issue
                        .enable()
                    local utils = require('blink-cmp-git.utils')
                    -- Place your enterprise's domain here
                    return enable or utils.get_repo_remote_url():find('gitlab%.fh%-ooe%.at')
                  end,
                  get_kind_name = function(item)
                    -- openedIssue, closedIssue
                    return item.discussion_locked and 'lockedIssue' or
                        item.state .. 'Issue'
                  end,

                  configure_score_offset = pr_or_issue_configure_score_offset,
                },
                mention = {
                  enable = function()
                    -- Get the default enable result
                    local enable = require('blink-cmp-git.default.gitlab')
                        .issue
                        .enable()
                    local utils = require('blink-cmp-git.utils')
                    -- Place your enterprise's domain here
                    return enable or utils.get_repo_remote_url():find('gitlab%.fh%-ooe%.at')
                  end,
                  get_label = function(item)
                    return require('blink-cmp-git.utils').concat_when_all_true(item.name, ':', item.username, '')
                  end,
                  configure_score_offset = mention_configure_score_offset,

                },
                pull_request = {
                  enable = function()
                    -- Get the default enable result
                    local enable = require('blink-cmp-git.default.gitlab')
                        .issue
                        .enable()
                    local utils = require('blink-cmp-git.utils')
                    -- Place your enterprise's domain here
                    return enable or utils.get_repo_remote_url():find('gitlab%.fh%-ooe%.at')
                  end,

                  configure_score_offset = pr_or_issue_configure_score_offset,
                }
              }
            }
          }
        },
      }
    },

    completion = {
      documentation = {
        auto_show = false,
        window = {
          border = 'none',
          desired_min_height = 10,
          desired_min_width = 10,
          min_width = 20,
          scrollbar = true,
        }
      },
      list = { selection = { preselect = true, auto_insert = false } },
      ghost_text = {
        enabled = true,
        show_with_selection = true,
        show_without_selection = true
      },
      menu = {
        enabled = true,
        direction_priority = { "n", "s" },
        draw = {
          components = {
            kind_icon = {
              ellipsis = true,
              -- text = function(ctx)
              --   local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
              --   if ctx.kind == 'Snippet' then
              --     return '󱄽'
              --   end
              --   return kind_icon
              -- end,
              -- -- Optionally, you may also use the highlights from mini.icons
              -- highlight = function(ctx)
              --   local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
              --   return hl
              -- end,
            }
          },
          columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind", gap = 1 } },
          -- columns = { { "kind_icon", "label", "label_description", gap = 1 } },
          treesitter = { 'lsp' }
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
  },

  opts_extend = { "sources.default" }
}
