array = require "Module:Array"
string = require "Module:String"
table = require "Module:Table"

function tabberF()
  if not tabber then tabber = require "Module:Tabber" end
  return tabber
end

p = {}

m = {}
m.__tostring = function(self)
  local out = "<" .. self._tag
  local attr = array.new()
  local styl = array.new()
  for k,v in pairs(self._attributes) do
   attr:push(" " .. k .. '="' .. v .. '"')
  end
  for k,v in pairs(self._styles) do
    if type(k)=="number" then
      styl:push(v)
    else
      styl:push(k .. ": " .. v)
    end
  end
  if #styl > 0 then attr:push(' style="' .. styl:join("; ") .. '"') end
  if #attr > 0 then out = out .. attr:join() end
  if self._selfClosing then out = out .. " />"
  else
    out = out .. ">"
    local cont = array.new()
    for i=1, #self._nodes do
      cont:push(tostring(self._nodes[i]))
    end
    out = out .. cont:join() .. "</" .. self._tag .. ">"
  end
  return out
end

m.__index = function(self, key)
  return h[key]
end

h = {}

function p.create(tag, prop)
  local n = { _tag = tag, _styles = {}, _attributes = {}, _selfClosing = false, _nodes = {} }
  setmetatable(n, m)
  local sc = { br = "", hr = "" }
  if prop and prop.selfClosing then n._selfClosing = prop.selfClosing
  elseif sc[tag] then n._selfClosing = true
  end
  return n
end

function h.attr(self, a, b)
  if b then
    self._attributes[a] = b
  else
    for k,v in pairs(a) do self._attributes[k] = v end
  end
  return self
end

function h.addClass(self, ...)
  local x = self._attributes.class and (self._attributes.class .. " ") or ""
  local y = array.new()
  for i=1, #arg do
    local z = arg[i]
    if type(z)=="table" then array.join(z, " ") end
    y:push(z:trim())
  end
  x = x .. y:join(" ")
  self._attributes.class = x
  return self
end

function h.css(self, a, b)
  if b then
    self._styles[a:trim():trim(" ;")] = b:trim():trim(" ;")
  else
    for k,v in pairs(a) do self._styles[k:trim():trim(" ;")] = v:trim():trim(" ;") end
  end
  return self
end

function h.cssText(self, a)
  table.insert(self._styles, a:trim():trim(" ;"))
  return self
end

function h.wikitext(self, a)
  table.insert(self._nodes, tostring(a))
  return self
end

function h.node(self, a)
  table.insert(self._nodes, a)
  return self
end

function h.newline(self)
  table.insert(self._nodes, "\n")
  return self
end

function h.tag(self, ...)
  local elem = p.create(table.unpack(arg))
  table.insert(self._nodes, elem)
  if not stack then stack = array.new() end
  stack:push(self)
  return elem
end

function h.done(self)
  if #stack > 0 then return stack:pop() end
  return self
end

function h.allDone(self)
  local elem = stack and stack[1] or self
  stack = nil
  return elem
end

function h.clear(self, a)
  local elem = p.create("br"):css("clear", a or "both")
  table.insert(self._nodes, elem)
  return self
end

function h.tabber(self, ...)
  local elem = tabberF().create(table.unpack(arg))
  table.insert(self._nodes, elem)
  return elem
end

return p
