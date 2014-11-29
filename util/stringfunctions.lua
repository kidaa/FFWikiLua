StringFunctions = {}

local ffwiki = require "Module:FFWiki"

function StringFunctions.splitjoin(frame)
  local f if frame.args["first"]=="@nil" then f = nil else f = frame.args["first"] end
  local l if frame.args["last"]=="@nil" then l = nil else l = frame.args["last"] end
  return frame.args[1]~="" and require "Module:Array".join(string.split(frame.args[1], frame.args[2], true), frame.args[3], l, f) or (ffwiki.ifnotblank(frame.args["blank"]) and frame.args["blank"] or "")
end

function StringFunctions.parameterize(frame)
  local f = frame.args[0] and frame or frame:getParent()
  f.args = ffwiki.reargs(f.args)
  for k,v in pairs(f.args) do f.args[0] = f.args[0]:gsub("{" .. k .. "}", "{{{" .. k .. "}}}") end
  return f:preprocess(f.args[0])
end

return StringFunctions
