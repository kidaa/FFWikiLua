function string.lettersequencenumber(str)
  str = str:upper()
  local sct = string.tochartable(str)
  local tot = 0
  for i=1, #sct do
    local q, l = string.byte(sct[i])-64, #sct-i
    tot = tot + q*(26^l)
  end
  return tot
end

function string.lettersequence(number)
  if not number then
    local obj = {_lower = false}
    obj.lower = function(self, bool)
      if bool and bool==false then self._lower = false
      else self._lower = true end
      return self
    end
    obj.__index = function(self, key)
      if rawget(obj, key) then return rawget(obj, key) end
      if type(key)=="number" then
        local x = string.lettersequence(key)
        if self._lower then return x:lower() end
        return x
      else return string.lettersequencenumber(key)
      end
    end
    setmetatable(obj, obj)
    return obj
  end
  if number < 1 then return nil end
  number = number - 1
  local nad = {}
  while number > 25 do
    table.insert(nad, 1, (number % 26))
    number = math.floor(number/26)-1
  end
  table.insert(nad, 1, number)
  local o = ""
  for i=1, #nad do o = o .. string.char(nad[i]+65) end
  return o
end

function string.replace(st, fr, to)
  return require "Module:Array".join(string.split(st, fr), to)
end

string.trim = mw.text.trim

function string.split(s, d, sso, sto)
  if sso==nil then sso = false end
  if sto==nil then sto = false end
  local q = {}
  local last = false
  while true do
    if s:find(d, 1, true) == nil then last = true end
    local n = last and s or string.sub(s, 0, s:find(d, 1, true)-1)
    if sto then n = mw.text.trim(n) end
    if sso==true and n ~= "" or sso==false then table.insert(q, n) end
    if(last==true) then break end
    s = string.sub(s, s:find(d, 1, true)+#d)
  end
  return q
end

function string.tochartable(s)
  local o = {}
  for i=1, #s do table.insert(o, string.sub(s, i, i)) end
  return o
end

function string.charat(s, i)
  return s:sub(i,i)
end

function string.ischar(s)
  if #s==1 then return true end return false
end

function string.isletter(s)
  if #s==1 and s:find("%a") then return true end return false
end

function string.isdigit(s)
  if #s==1 and s:find("%d") then return true end return false
end

function string.isupper(s)
  if not s:find("%l") then return true end return false
end

function string.islower(s)
  if not s:find("%u") then return true end return false
end

function string.isnumeric(s)
  if s:find("%d") and not s:find("%D") then return true end return false
end

function string.isalphanumeric(s)
  if s:find("%w") and not s:find("%W") then return true end return false
end

function string.isalpha(s)
  if s:find("%a") and not s:find("%A") then return true end return false
end

function string.ishexadecimal(s)
  if s:find("%x") and not s:find("%X") then return true end return false
end

function string.isoctal(s)
  local _o = "[01234567]"
  if s:find(_o) and s:gsub(_o, "")=="" then return true end return false
end

function string.contains(s, b)
  if string.find(s, b, 1, true) then return true end
  return false
end

function string.startswith(s, b)
  if string.sub(s, 1, #b) == b then return true end
  return false
end

function string.endswith(s, b)
  if string.sub(s, -#b) == b then return true end
  return false
end

return string
