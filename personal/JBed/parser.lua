--this is a side project JBed is working on
--it is sort of writing Lua within Lua
--i wonder how that could be useful?

parser = {}

string = require "Module:String"
table = require "Module:Table"

function parser.string(s, ...)
  --limitations: doesn't recognise "\n" et al
  --             doesn't recognise use of functions or unpassed variables
  local args = table.pack and table.pack(...) or arg
  local t = string.tochartable(s)
  local a = ""
  local p = ""
  local quot = {"'", '"'}
  local cquo = false
  local litc = {"\\"}
  local lit = false
  local clv = 2
  --clv: 0 = unreadable, 1 = expecting concat, 2= readable, 3= quoting, 4= literaling, 5=variabling
  for i=1, #t do
    if clv == 0 then
      if t[i] == " " then
      elseif t[i] =="." then clv = 1
      else return nil
    end
    elseif clv == 1 then
      if t[i] == "." then clv = 2
      else return nil
      end
    elseif clv == 2 then
      if t[i] == " " then
      elseif t[i] == "{" then clv = 5
      elseif t[i] == quot[1] then cquo = quot[1] clv = 3
      elseif t[i] == quot[2] then cquo = quot[2] clv = 3
      else return
      end
    elseif clv == 3 then
      if t[i] == "\\" then clv = 4
      elseif t[i] == cquo then clv = 0
      else a = a .. t[i]
      end
    elseif clv == 4 then
      a = a .. t[i]
    elseif clv == 5 then
      if t[i] == "}" then a = a .. args[tonumber(p)] p = "" clv = 0
      elseif tostring(tonumber(t[i])) == t[i] then p = p .. t[i] 
      else return nil
      end
    else return nil
    end
  end
  return a
end

function parser.tablevalue(a, b)
  local array = require "Module:Array"
  local spl = array.new(a:split("="))
  local var = spl:shift()
  local tab = parser.value(spl:join("="))
  var = array.new(var:trim():split(" ")):pop()
  local sta = b:trim()
  local par
  if sta:startswith(var .. ".") then
    par = sta:split(".")[2]:split(" ")[1]
  elseif sta:startswith(var .. "[") then
    par = sta:split("[")[2]:split("]")[1]
    par = parser.value(par)
  end
  if par == nil then return require "Module:FFWiki".err("No property selection stated") end
  return tab[par]
end

function parser.value(s, type)
  type = type and type:upper():sub(1, 3) or nil

  local expr = require "Module:Expr"

  local ALTTYPE = function(s, key)
    if s == "true" then return true
    elseif s == "false" then return false
    elseif s == "nil" then return nil
    elseif string.startswith(s, "function") then return function() end
    elseif string.gsub(s, "[_%a][_%w]*", "_") == "_" and key then return parser.string("'" .. s .. "'")
    elseif string.startswith(s, "'") or string.startswith(s, '"') then return parser.string(s)
    else return pcall(function() expr.calc(s) end) and expr.calc(s) or parser.retrieve(s) end
  end

  function BRACKETS(s, type)
    s = mw.text.trim(s)
    local tab = {"{", "}"}
    if type == "PAR" then tab = {"(", ")"}
    elseif type == "SQU" then tab = {"[", "]"} end
    if not string.contains(s, tab[1]) and not string.contains(s, tab[2]) then return ALTTYPE(s) end
    local f, l = 0, 0
    local litch = "\\"
    local litfl = false
    local nest = 0
    local c = string.tochartable(s)
    for i=1, #c do
      if litfl == true then litfl = false
      elseif c[i] == litch then litfl = true
      elseif c[i]==tab[1] then
        nest = nest + 1
        if f == 0 then f = i end
      elseif c[i]==tab[2] then
        nest = nest - 1
        if nest == 0 then
          l = i
          break
        end
      end
    end
    if l == 0 or f == 0 then print("what's up") end
    return SPLIT(string.sub(s, f+1, l-1)), s:sub(l+1)
  end
  
  function SPLIT(s)
    s = mw.text.trim(s)
    local tab = {"{", "}"}
    local c = string.tochartable(s)
    local t = {}
    local key = false
    local val = ""
    local pro = {"[", "]"}
    local str = {'"', "'"}
    local strAct = ""
    local lit = "\\"
    local litFlag = false
    local ass = "="
    local sep = ","
    local m = 0--0 = Normal. 1 = Propertying, 2 = Tabling, 3 = Stringing
    local mStack = {m}
    function mE(v) if v then table.insert(mStack, m) m = v else m = mStack[#mStack] table.remove(mStack, #mStack) end end
    local word = ""
    local c = string.tochartable(s)
    for i =1, #c do
      local n = c[i]
      if     m == 0 then
        if     n == pro[1] then
          mE(1)
        elseif n == tab[1] then
          mE(2)
        elseif n == str[1] or n == str[2] then
          mE(3) strAct = n val = val .. n
        elseif n == ass then
          key = val val = ""
        elseif n == " " then
        elseif n == sep then
          t[ALTTYPE(key or #t+1, true)] = BRACKETS(val) key = false val = ""
        else val = val .. n end
        if i == #c then t[ALTTYPE(key or #t+1, true)] = BRACKETS(val) end
      elseif m == 1 then
        if key then return "ERROR" end
        if     n == pro[2] then
          mE(0)
        elseif n == tab[1] then
          mE(2)
        elseif n == str[1] or str[2] then
          mE(3) strAct = n val = val .. n
        else val = val .. n end
      elseif m == 2 then
        if n == tab[2] then
          mE() t[ALTTYPE(key or #t+1, true)] = BRACKETS("{" .. val .. "}")
        else val = val .. n end
      elseif m == 3 then
        if     litFlag then litFlag = false
        elseif n == lit then litFlag = true
        elseif n == strAct then mE() val = val .. strAct
        else
          val = val .. n
        end
        if i == #c then t[ALTTYPE(key or #t+1, true)] = BRACKETS(val) end
      end
    end
    return t
  end
  
  return BRACKETS(s, type)
end

function parser.retrieve(a)
  if type(a)=="table" and a.args then a = a.args[1] end

  local op = { prop = ".", meth = ":", inde = "[", para = "(" }

  --function lessthanall(a, ...)
  --  if type(a) ~= type(arg[1]) and type(arg[1]) == "table" then arg = arg[1] end
  --  for i=1, #arg do
  --    if arg[i] and not (a < arg[i]) then return false end
  --  end
  --  return true
  --end

  function minind(...)
    local ind = 1
    --local arg = table.pack(...)
    if #arg == 0 then return nil, nil end
    local m = arg[1]
    for i=2, #arg do
      if arg[i] < m then m = arg[i] ind=i end
    end
    return m, ind
  end

  local mode = 1
  local next, prev
  local self

  local val = _G

  if     a:sub(1, 4) == "ffwiki" then _G.ffwiki = require "Module:FFWiki"
  elseif a:sub(1, 4) == "expr" then _G.expr = require "Module:Expr"
  elseif a:sub(1, 5) == "array" then _G.array = require "Module:Array"
  elseif a:sub(1, 5) == "color" then _G.color = require "Module:Color"
  elseif a:sub(1, 6) == "parser" then _G.parser = require "Module:Parser"
  elseif a:sub(1, 6) == "tabber" then _G.tabber = require "Module:Tabber"
  end

  function retself(a) return a end

  while a ~= "" do
    local opon

    if val == _G and a:sub(1, 1) == "(" then val = retself mode = 4 a = a:sub(2) end

    if mode == 3 then
      opon, a = parser.value("[" .. a, "SQU")
    elseif mode == 4 then
      opon, a = parser.value("(" .. a, "PAR")
      if prev == 2 then table.insert(opon, 1, self) end
    end

    local ix = {}
    for k,v in pairs(op) do
      ix[k] = a:find(v, nil, true) or 0xFF
    end

    local m, next = minind(ix.prop, ix.meth, ix.inde, ix.para)

    if not opon then opon = a:sub(1, m-1) end
    a = a:sub(m+1)

    if val == _G and a == "" then val = parser.value(opon) break end

    local params = false
    local pstr
    if     mode == 1 then
      val = val[opon]
    elseif mode == 2 then
      self = val
      val = val[opon]
    elseif mode == 3 then
      val = val[table.unpack(opon)]
    elseif mode == 4 then
      val = val(table.unpack(opon))
    end

    prev = mode
    mode = next
  end
  return tostring(val) == "table" and table.tostring(val) or tostring(val)
end

return parser
