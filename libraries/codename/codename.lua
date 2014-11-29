--see Talk for JS to generate objects

codename = {}

codename.tables = mw.loadData("Module:Codename/data")

local ffwiki = require "Module:FFWiki"
local array = require "Module:Array"
table = require "Module:Table"
string = require "Module:String"

function dive(t, f)
  for i=1, #f do
    t = t[f[i]]
  end
  local y = type(t)
  if y == "table" and array.isarray(t) then y = "array" end
  if y == "table" then return table.tostring(t)
  elseif y == "array" then return array.tostring(t)
  elseif y == "nil" then return "null"
  elseif y == "function" then return "function"
  else return t
  end    
end

function codename.icon(frame)
  local text = frame.args[1] or frame.args["text"]
  local textArray = text:split("|")
  text = ""
  for i=1, #textArray do
    local mod = "standard"
    local dsp = ""
    if textArray[i]:startswith("(") then
      mod, dsp = table.unpack(textArray[i]:sub(2):split(")"))
    else dsp = textArray[i] end

    text = text .. tostring(mw.html.create("span"):wikitext(dsp):cssText(frame.args[mod .. " style"] or ""))
    if i ~= #textArray then text = text .. "<br/>" end
  end
  return text
end

function codename.rel(frame)
  return dive(codename.tables.rel, ffwiki.reargs(frame.args))
end

function codename.ser(frame)
  return dive(codename.tables.ser, ffwiki.reargs(frame.args))
end

function codename.dive(frame)
  local f = array.new(ffwiki.reargs(frame.args[1] and frame.args or frame:getParent().args))
  local t = f:shift()
  return dive(codename.tables[t], f)
end

function codename.lookup(frame)
  local f = ffwiki.reargs(frame.args)
  local a = codename.tables[array.shift(f)]
  local l = array.pop(f)
  local an = tostring(tonumber(f[#f])) == f[#f] and tonumber(array.pop(f)) or false
  local o = {}
  for k,v in pairs(a) do
    local e = a[k]
    for i=1, #f do
      e = e[f[i]]
    end
    if tostring(e)==l then array.push(o, k) end
  end
  return #o==1 and o[1] or ((an~=false and an <= #o) and o[an] or table.tostring(o))
end

return codename
