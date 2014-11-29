--In Lua tables are the same thing as objects and arrays, there is no distinction
--Though if you don't use indexes when adding new elements you'll be making an array
--These functions are designed specifically for arrays, rather than tables in general
--Though Array is also a class in its own right, compliant tables work fine
 
array = {}
table = require "Module:Table"

----------------------------
-- Array class definition --
----------------------------
array.__index = function(t, k) if k=="new" or k=="isarray" then return nil end return array[k] end
array.__type = "array"
array.__tostring = function(a) return '{ "' .. array.join(a, '", "') .. '" }' end

--------------------------------------
-- Class instance/object initialize --
--------------------------------------
function array.new(...)
  obj = {}

  function removeExcess(a)
    if array.isarray(a) then return a end
    local b = {} for k,v in ipairs(a) do b[k] = v end return b
  end

  if not arg[1] then
  elseif type(arg[1])=="table" then obj = removeExcess(arg[1])
  else obj = removeExcess(arg) end

  setmetatable(obj, array)

  return obj
end

function array.isarray(obj)
  if type(obj) ~= "table" then return false end
  local i = 0
  for k,v in pairs(obj) do
    if i+1 ~= k then return false else i = i + 1 end
  end
  return true
end

function array.push(array, value)
  table.insert(array, value)
  return #array
end
 
function array.unshift(array)
  table.insert(array, 1, value)
  return #array
end
 
function array.pop(array)
  return table.remove(array)
end
 
function array.shift(array)
  return table.remove(array, 1)
end
  
function array.reverse(array)
  local l = #array
  local rev = {}
  for k, v in ipairs(array) do
    rev[k] = array[l]
    l = l - 1
  end
  for k,v in ipairs(array) do
    array[k] = rev[k]
  end
  return array
end
 
function array.concat(a, ...) --just to be confusing, table.concat is like Join, not this
  for i=1, #arg do for j=1, #arg[i] do a[#a+1] = arg[i][j] end end
  return a
end
 
function array.contains(a, b)
  for i=1, #a do if(a[i]==b) then return true end end
  return false
end
 
function array.indexof(a, b)
  for i=1, #a do if a[i]==b then return i end end
  return -1
end
 
function array.lastindexof(a, b)
  for i=0, #a-1 do if a[#a-i]==b then return #a-i end end
  return -1
end
 
function array.slice(a, b, c)
  local new = {}
  if(c==nil) then c = #a
  elseif(c<0) then c = #a+1+c end
  if(b<0) then b = #a+1+b end
  for i=1, 1+c-b do new[i] = a[i+b-1] end
  return new
end
 
function array.foreach(a, f)
  for i=1, #a do f(a[i], i, a) end
end
 
function array.recursiveforeach(a, f)
  array.foreach(a, function(x, y, z) f(x, y, z) if type(x)=="table" then array.recursiveforeach(x, f) end end)
end
 
function array.join(a, d, l, f)
  local s = ""
  if(d==nil) then d = "" end
  if(f==nil) then f = d end
  if(l==nil) then l = d end
  for i=1, #a do
    s = s .. a[i]
    if (i==#a) then
    elseif(i==1) then s = s .. f
    elseif (i==#a-1) then s = s .. l
    else s = s .. d end
  end
  return s
end

array.tostring = array.__tostring

function array.print(a)
  mw.log(array.tostring(a))
end


return array
