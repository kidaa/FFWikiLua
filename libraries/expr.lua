expr = {}

local string = require "Module:String"
local array = require "Module:Array"

function expr.calc(s)
  if s == nil or s == "" then s = 0 end
  return tonumber(brackets(s))
end

function split(s)
  local logic = {"<", "<=", ">=", "~=", "=="}
  local wdlgc = {"and", "or"}
  local nawt = {"not"}
  local arith = {"^", "/", "*", "%", "+", "-", "x"}

  local split = {}
  local tlen = 0
  local tmem = ""
  
  s = string.gsub(string.gsub(s, "true", "1"), "false", "0")
  
  for i=1, #s do
    local curr = string.sub(s, i, i)
    if curr == " " then
      if tlen ~=0 then table.insert(split, string.sub(s, i-tlen, i-1))
      elseif tmem ~= "" then table.insert(split, tmem)
      end
      tlen = 0
      tmem = ""
    elseif curr:find("[01234567890ABCDEF.]") then
      tlen = tlen + 1
      if tmem ~= "" then
        table.insert(split, tmem)
        tmem = ""
        tlen = 1
      end
    else
      if i==1 then table.insert(split, "0") end
      if tlen ~= 0 then table.insert(split, string.sub(s, i-tlen, i-1)) end
      tlen = 0
      if tmem ~= "" then
        local testring = tmem .. curr
        local match = false
        local srchtab = { logic, wdlgc, nawt, arith }
        for j=1, #srchtab do
          for k=1, #srchtab[j] do
            if string.startswith(srchtab[j][k], testring) then match = true break end
          end
          if match then tmem = testring break end
        end
        if not match then table.insert(split, tmem) table.insert(split, "0") tmem = curr end
      else if i>2 and split[#split] ~= tostring(tonumber(split[#split])) then table.insert(split, "0") end tmem = curr
      end
    end
    if i == #s and tlen ~= 0 then table.insert(split, string.sub(s, i-tlen+1, i)) end
  end
  return split
end

function brackets(s)
  if not string.contains(s, "(") and not string.contains(s, ")") then return tonumber(odmas(split(s))) end
  c = string.tochartable(s)
  local f, l = 0, 0
  for i=1, #c do
    if c[i]=="(" then  f = i
    elseif c[i]==")" then l = i break
    end
  end
  if l == 0 or f == 0 then print("what's up") end
  return brackets(string.sub(s, 0, f-1) .. odmas(split(string.sub(s, f+1, l-1))) .. string.sub(s, l+1))
end

function odmas(a)
  if #a == 1 then return a[1] end
  if array.contains(a, "x") then
    local rem = array.indexof(a, "x")
    a[rem-1] = tostring(tonumber("0x" .. a[rem+1]))
    table.remove(a, rem)
    table.remove(a, rem)
    return odmas(a)
  elseif array.contains(a, "^") then
    local rem = array.indexof(a, "^")
    a[rem-1] = tostring(a[rem-1] ^ a[rem+1])
    table.remove(a, rem)
    table.remove(a, rem)
    return odmas(a)
  elseif array.contains(a, "not") then
    local rem = array.indexof(a, "not")
    a[rem+1] = a[rem+1]==0 and "1" or "0"
    table.remove(a, rem-1)
    table.remove(a, rem-1)
    return odmas(a)
  elseif array.contains(a, "/") then
    local rem = array.indexof(a, "/")
    a[rem-1] = tostring(a[rem-1] / a[rem+1])
    table.remove(a, rem)
    table.remove(a, rem)
    return odmas(a)
  elseif array.contains(a, "*") then
    local rem = array.indexof(a, "*")
    a[rem-1] = tostring(a[rem-1] * a[rem+1])
    table.remove(a, rem)
    table.remove(a, rem)
    return odmas(a)
  elseif array.contains(a, "%") then
    local rem = array.indexof(a, "%")
    a[rem-1] = tostring(a[rem-1] % a[rem+1])
    table.remove(a, rem)
    table.remove(a, rem)
    return odmas(a)
  elseif array.contains(a, "+") then
    local rem = array.indexof(a, "+")
    a[rem-1] = tostring(a[rem-1] + a[rem+1])
    table.remove(a, rem)
    table.remove(a, rem)
    return odmas(a)
  elseif array.contains(a, "-") then
    local rem = array.indexof(a, "-")
    a[rem-1] = tostring(a[rem-1] - a[rem+1])
    table.remove(a, rem)
    table.remove(a, rem)
    return odmas(a)
  elseif array.contains(a, "<") then
    local rem = array.indexof(a, "<")
    a[rem-1] = a[rem-1] < a[rem+1] and "1" or "0"
    table.remove(a, rem)
    table.remove(a, rem)
    return odmas(a)
  elseif array.contains(a, ">") then
    local rem = array.indexof(a, ">")
    a[rem-1] = a[rem-1] > a[rem+1] and "1" or "0"
    table.remove(a, rem)
    table.remove(a, rem)
    return odmas(a)
  elseif array.contains(a, "<=") then
    local rem = array.indexof(a, "<=")
    a[rem-1] = a[rem-1] <= a[rem+1] and "1" or "0"
    table.remove(a, rem)
    table.remove(a, rem)
    return odmas(a)
  elseif array.contains(a, ">=") then
    local rem = array.indexof(a, ">=")
    a[rem-1] = a[rem-1] >= a[rem+1] and "1" or "0"
    table.remove(a, rem)
    table.remove(a, rem)
    return odmas(a)
  elseif array.contains(a, "~=") then
    local rem = array.indexof(a, "~=")
    a[rem-1] = a[rem-1] ~= a[rem+1] and "1" or "0"
    table.remove(a, rem)
    table.remove(a, rem)
    return odmas(a)
  elseif array.contains(a, "==") then
    local rem = array.indexof(a, "==")
    a[rem-1] = a[rem-1] == a[rem+1] and "1" or "0"
    table.remove(a, rem)
    table.remove(a, rem)
    return odmas(a)
  elseif array.contains(a, "and") then
    local rem = array.indexof(a, "and")
    a[rem-1] = tostring(a[rem-1] + a[rem+1])
    table.remove(a, rem)
    table.remove(a, rem)
    return odmas(a)
  elseif array.contains(a, "or") then
    local rem = array.indexof(a, "or")
    a[rem-1] = tostring(a[rem-1] * a[rem+1])
    table.remove(a, rem)
    table.remove(a, rem)
    return odmas(a)
  end
end

return expr
