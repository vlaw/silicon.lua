local opts = require("silicon.config").opts
local utils = require('silicon.utils')
local Job = require("plenary.job")
local fmt = string.format

local M = {}

M.exec = function(range, show_buffer, copy_to_board)
  table.sort(range)
  local starting, ending = unpack(range)
  starting = starting - 1

  local lines = vim.api.nvim_buf_get_lines(0, starting, ending, true)

  if show_buffer then
    lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)
  end

  if opts.gobble == true then
    local whitespace = nil
    local current_whitespace = nil
    -- Get least leading whitespace
    for idx = 1, #lines do
      lines[idx] = lines[idx]:gsub("\t", string.rep(" ", vim.bo.tabstop))
      current_whitespace = string.len(string.match(lines[idx], "^[\r\n\t\f\v ]*") or "")
      whitespace = current_whitespace < (whitespace or current_whitespace + 1) and current_whitespace
          or whitespace
    end
    -- Now remove whitespace
    for idx = 1, #lines do
      lines[idx] = lines[idx]:gsub(string.rep(" ", whitespace), "")
    end
  end

  local contents = table.concat(lines, "\n")

  local real_output = utils._replace_placeholders(opts.output)

  if #contents ~= 0 then
    local args = {
      "--language",
      vim.bo.filetype,
    }
    vim.tbl_deep_extend("force", args, opts.silicon_args or {})

    if show_buffer then
      table.insert(args, "--highlight-lines")
      table.insert(args, fmt("%s-%s", starting + 1, ending))
    end

    if copy_to_board then
      table.insert(args, "--to-clipboard")
    else
      table.insert(args, "--output")
      table.insert(args, real_output)
    end

    -- run silicon job
    ---@diagnostic disable-next-line: missing-fields
    local job = Job:new({
      command = "silicon",
      args = args,
      on_exit = function(j, code)
        -- run successfully
        if code == 0 then
          local msg = ""
          if copy_to_board then
            msg = "Snapped to clipboard"
          else
            msg = string.format("Snap saved to %s", opts.output)
          end
          vim.notify(
            "Silicon:" .. msg,
            vim.log.levels.INFO,
            { plugin = "silicon.lua" }
          )
        else
          vim.defer_fn(function()
            vim.notify(string.format(
                "Some error occurred while executing silicon: \nargs: %s, \nstderr: %s",
                vim.inspect(j.args),
                vim.inspect(j._stderr_results)
              ),
              vim.log.levels.ERROR,
              { plugin = "silicon.lua" })
          end, 0)
        end
      end,
      on_stderr = function(_, data)
        if opts.debug then
          print(vim.inspect(data))
        end
      end,
      writer = contents,
      cwd = vim.fn.getcwd(),
    })
    job:sync()
  else
    vim.notify("Please select code snippet in visual mode first!", vim.log.levels.WARN)
  end
end

return M
