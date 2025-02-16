local Job = require("plenary.job")

local GlabIssues = {}
GlabIssues.__index = GlabIssues

-- Constructor that returns an instance of the provider
function GlabIssues.new()
  local self = setmetatable({}, GlabIssues)
  -- self.cache = {}
  self.name = "glab_issues"    -- required by blink.cmp
  self.module = "custom_plugins.glab_issues"  -- required by blink.cmp
  return self
end

-- This function is called by blink.cmp to fetch completion items
function GlabIssues:complete(_, callback)
  local bufnr = vim.api.nvim_get_current_buf()

  Job:new({
    command = "glab",
    args = { "issue", "list", "--output", "json" },
    on_exit = function(job)
      local result = job:result()
      local ok, parsed = pcall(vim.json.decode, table.concat(result, ""))
      if not ok then
        vim.notify("Failed to parse glab result")
        return
      end

      local items = {}
      for _, glab_item in ipairs(parsed) do
        local body = (glab_item.body or ""):gsub("\r", "")
        table.insert(items, {
          label = string.format("#%s", glab_item.number),
          documentation = {
            kind = "markdown",
            value = string.format("# %s\n\n%s", glab_item.title, body),
          },
        })
      end

      callback({ items = items, isIncomplete = false })
    end,
  }):start()
end

-- This provider should only be active in gitcommit buffers
function GlabIssues:is_available()
  return vim.bo.filetype == "gitcommit"
end

return GlabIssues.new()
