local M = {}

---@param opts SiliconOpts
M.setup = function(opts)
  require("silicon.config").setup(opts)
end

---@class SiliconArgs
---@field show_buf boolean? whether to show buffer
---@field to_clip boolean? whether to show clipboard
---@field visible boolean? whether to render visible buffer
---@field cmdline boolean? whether to work around cmdline issues

--- Generates image of selected region
---@param opts SiliconArgs
M.visualise_api = function(opts)
  local range
  if opts.visible then
    range = {
      vim.fn.getpos('w0')[2],
      vim.fn.getpos('w$')[2],
    }
  elseif opts.cmdline then -- deal with `lua` leaving visual before executing
    range = {
      vim.api.nvim_buf_get_mark(0, "<")[1],
      vim.api.nvim_buf_get_mark(0, ">")[1],
    }
  else
    range = {
      vim.fn.getpos('v')[2],
      vim.fn.getpos('.')[2],
    }
  end
  require("silicon.request").exec(range, opts.show_buf or false, opts.to_clip or false)
end

---@param opts table containing the options
M.visualise_cmdline = function(opts)
  opts = vim.tbl_extend('keep', { cmdline = true }, opts)
  M.visualise_api(opts)
end

return M
