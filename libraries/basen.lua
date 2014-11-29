require "Module:Sandsea".x(_G)

p = {}

p.parse = function(self, s)
  if self._duplicates then error("Cannot parse because the character map contains duplicate characters") end
  if self._casesensitive then s = s:lower() end
  s = s:tochartable()
  t = 0
  for i=1, #s do
    t = t + (self._rlookup[s[i]] * (self.length^(#s-i)))
  end
  return t
end

p.convert = function(self, n)
  local accum = ""
  for i=1, 100 do
    local chop = (n/(self.length^(i-1))) % self.length
    n = n - (chop * (self.length^(i-1)))
    accum = self._charmap[chop] .. accum
    if n == 0 then break end
  end
  return accum
end

function DuplicateTest(a, sensitive)
  if sensitive==nil then sensitive = true end
  if type(a) == "string" then a = a:tochartable() end
  b = {}
  for i=1, #a do
    if type(a[i])=="string" and not sensitive then a[i] = a[i]:lower() end
    if b[a[i]] then return false end
    b[a[i]] = true
  end
  return true
end

p.new = function(...)
  local o = {}
  local charmap
  repeat
    if arg[2] then
      charmap = arg
      break
    end
    if type(arg[1])=="table" then
      charmap = arg[1]
      break
    end
    if type(arg[1])=="number" then
      charmap = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ?!@~#%&£$"
      if #charmap < arg[1] then error("That number is too high to auto-generate a map. Input a character map manually if you want that many") end
      charmap = charmap:sub(1, arg[1])
    end
    if type(arg[1])=="string" then
      charmap = arg[1]
    end
    if not charmap then error("Not even a valid input") end
    charmap = charmap:tochartable()
  until true
  o._duplicates = not DuplicateTest(charmap)
  o._casesensitive = DuplicateTest(charmap, false)
  o._charmap = {}
  o._rlookup = {}
  for i=0, #charmap-1 do
    o._charmap[i] = charmap[i+1]
    o._rlookup[o._charmap[i]] = i
  end
  setmetatable(o, BaseNObj)
  return o
end

BaseNObj = {}
BaseNObj.__index = function(self, key)
  if key=="length" then return #self._charmap+1 end
  if p[key] then return p[key] end
  if type(key)=="number" then return self:convert(key) end
  if type(key)=="string" then return self:parse(key) end
end

return p
