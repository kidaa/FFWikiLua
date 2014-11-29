--Expands table.
--it includes "pack" and "unpack" which are default methods of table in Lua 5.2
--Lua 5.2 also handles (.../arg) differently, not like a table but instead comma-separated values that have to be packed

function table.pack(...)
  local o = {}
  for k,v in pairs(arg) do o[k] = v end
  return o
end

function table.unpack(t, f, l)
  return unpack(t, f, l)
end

table.clone = mw.clone

function table.contains(a, b)
  for k,v in pairs(a) do if(v==b) then return true end end
  return false
end

function table.keys(t)
  local obj = {}
  local array = require "Module:Array"
  for k,v in pairs(t) do array.push(obj, k) end
  return obj
end

--for printing purposes
function table.tostring(t, h, nl, ind, inc)
  if nl == nil then nl = "" end
  if ind == nil then ind = "" end
  if inc == nil then inc = 0 end
  if type(t) ~= "table" then return tostring(t) end
  if h=="" or h==nil then h = 100 end
  local i = 1
  local l = {}
  local array = require "Module:Array"
  for k, v in pairs(t) do
    local auto = false
    if k == i then
      auto = true
      i = i + 1
    end
    local ttl = h
    table.insert(l, (auto and "" or k .. " = ") .. ((type(v)=="table" and ttl>1) and table.tostring(v, ttl-1, nl, ind, inc+1) or (type(v)=="string" and '"' .. v .. '"' or tostring(v))))
  end
  return "{ " .. nl .. string.rep(ind, inc+1) .. array.join(l, ", " .. nl .. (string.rep(ind, inc+1))) .. " " .. nl .. string.rep(ind, inc) .. "}"
end

return table
