-- vim.cmd.colorscheme "catppuccin"
-- require'yorumi'.load 'abyss'
-- vim.cmd.colorscheme 'yorumi-abyss'

-- require('night-owl').setup{
--   transparent_background = true
-- }
-- vim.cmd.colorscheme 'night-owl'
vim.cmd.colorscheme 'srcery'
vim.opt.termguicolors = true

-- vim.cmd([[
-- highlight Normal guibg=none
-- ]])

local function extend_hl(name, def)
  local current_def = vim.api.nvim_get_hl(0, { name = name })
  local new_def = vim.tbl_extend('force', {}, current_def, def)
  vim.api.nvim_set_hl(0, name, new_def)
end

extend_hl('Comment', { italic = true })
extend_hl('Normal', { bg = 'none' })
-- extend_hl('netrwDir', { fg = '#4d6ed1' })
-- extend_hl('netrwDir', { fg = '#ff0000' })
vim.cmd('highlight netrwDir guifg=#f38ba8')

local blink_cmp_kind_name_highlight = {
  Commit = { default = true, fg = '#a6e3a1' },
  Mention = { default = true, fg = '#a6e3a1' },
  openPR = { default = true, fg = '#a6e3a1' },
  openedPR = { default = true, fg = '#a6e3a1' },
  closedPR = { default = true, fg = '#f38ba8' },
  mergedPR = { default = true, fg = '#cba6f7' },
  draftPR = { default = true, fg = '#9399b2' },
  lockedPR = { default = true, fg = '#f5c2e7' },
  openIssue = { default = true, fg = '#a6e3a1' },
  openedIssue = { default = true, fg = '#a6e3a1' },
  reopenedIssue = { default = true, fg = '#a6e3a1' },
  completedIssue = { default = true, fg = '#cba6f7' },
  closedIssue = { default = true, fg = '#cba6f7'},
  not_plannedIssue = { default = true, fg = '#9399b2' },
  duplicateIssue = { default = true, fg = '#9399b2' },
  lockedIssue = { default = true, fg = '#f5c2e7' },
}

for kind_name, hl in pairs(blink_cmp_kind_name_highlight) do
  vim.api.nvim_set_hl(0, 'BlinkCmpGitKind' .. kind_name, hl)
  vim.api.nvim_set_hl(0, 'BlinkCmpGitKindIcon' .. kind_name, hl)
  vim.api.nvim_set_hl(0, 'BlinkCmpGitLabel' .. kind_name .. 'Id', hl)
end
