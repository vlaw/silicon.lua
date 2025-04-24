local fmt = string.format
local M = {}

M._os_capture = function(cmd, raw)
  local f = assert(io.popen(cmd, "r"))
  local s = assert(f:read("*a"))
  f:close()
  if raw then
    return s
  end
  s = string.gsub(s, "^%s+", "")
  s = string.gsub(s, "%s+$", "")
  s = string.gsub(s, "[\n\r]+", " ")
  return s
end

--- Check if a file or directory exists in this path
---@param file string path of file or directory
M._exists = function(file)
  local ok, err, code = os.rename(file, file)
  if not ok then
    if code == 13 then
      -- Permission denied, but it exists
      return true
    end
  end
  return ok, err
end

M._replace_placeholders = function(str)
  return str:gsub("${time}", fmt("%s:%s", os.date("%H"), os.date("%M")))
      :gsub("${year}", os.date("%Y"))
      :gsub("${month}", os.date("%m"))
      :gsub("${date}", os.date("%d"))
end

return M
