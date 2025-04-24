local M = {}

---@class SiliconOpts
local default = {
  theme = "Dracula",
  output = "SILICON_${year}-${month}-${date}_${time}.png",
  gobble = false,
  silicon_args = nil,
  debug = false,
}

--- @param opts table
M.setup = function(opts)
  M.opts = vim.tbl_deep_extend(
    "force",
    default,
    opts or {}
  )
end

return M
