
---Welcome to the Sandsea! Here new coders can try their hand at Lua and more experienced coders can test methods they've written.
Sandsea = {};

--The FFWiki module contains the standard methods used by the Final Fantasy Wiki.
ffwiki = require "Module:FFWiki";

---A simple method to showcase Lua syntax and LuaDoc. Methods should be written as part of the module's main object.
--@param name The name of the user being welcomed; defaults to "world".
--@return String: The string "Hello [name]!"
function Sandsea.hello()
  return "Hello world!";
end

--TESTING AREA BEGINS HERE

array = require "Module:Array"

function Sandsea.doit(frame)
  return mw.html.create("a"):wikitext("0\n1\n\n2\n\n\n3")
end

function Sandsea.x(a, ...)
  a.string = require "Module:String"
  a.table = require "Module:Table"
  a.mw.html = require "Module:Html"
  a.math.round = function(a, b)
    b = b or 0
    a = a * (10^b)
    a = math.ceil(a-0.5)
    a = a / (10^b)
    return a
  end
  a.print = mw.log
  for i=1, #arg do a[arg[i]:lower()] = require("Module:" .. arg[i]) end
end

table = require "Module:Table"
function Sandsea.frame(frame)
  local f = array.new(ffwiki.reargs(frame.args))
  local t = f:shift()
  if t == ":" then
    return table.tostring(frame[f:shift()](frame, table.unpack(f)))
  elseif t == "." then
    local cal = f:shift()
    if type(cal) == "function" then
      return table.tostring(frame[cal](table.unpack(f)))
    else return table.tostring(frame[cal])
    end
  else
    return table.tostring(frame)
  end
end

function Sandsea.tilde()
  return "~~" .. "~~"
end

function Sandsea.expandTemplate(frame)
  local f = ffwiki.reargs(frame.args)
  return frame:expandTemplate({title = require "Module:Array".shift(f), args = f})
end

function Sandsea.preprocess(frame)
  return frame:preprocess("{{{1}}}")
end

function Sandsea.parameterize(frame)
  return frame:preprocess(frame.args[0])
end

function Sandsea.parpreprocess(frame)
  return frame:getParent():preprocess("{{{1}}}")
end

function Sandsea.testing(frame)
  local f = ffwiki.reargs(frame.args)
  f = ffwiki.luaparam(f)
  return type(f[1])
end

--TESTING AREA ENDS HERE

--Must return module's main object at end of module.
return Sandsea;
