ffwiki = require "Module:FFWiki";
string = require "Module:String"
table = require "Module:Table"

--- WikiFunctions are a replacement to ParserFunctions, allows Lua logic and FFWiki[] methods to be applied
-- outside of Lua.
WikiFunctions = {};

--- Check if a string is not blank.
-- @param frame[0] The value to be tested.
-- @param frame[1] The value to be returned if frame[0] isn't blank.
-- @param frame[2] The value to be returned if frame[0] is blank.
function WikiFunctions.ifnotblank(frame)
  if ffwiki.ifnotblank(frame.args[1]) then return frame.args[2];
  elseif frame.args[3] ~= nil then return frame.args[3] end
end

--- Check if two values are equal to each other.
-- @param frame[0] The first value to be tested.
-- @param frame[1] The second value to be tested.
-- @param frame[2] The value to return if true.
-- @param frame[3] The value to return if false.
function WikiFunctions.ifeq(frame)
  if frame.args[1] == frame.args[2] then return frame.args[3];
  elseif frame.args[4] ~= nil then return frame.args[4] end
end

--- Check if an expression evaluates to true.
-- @param frame[0] The expression to be tested.
-- @param frame[1] The value to return if true.
-- @param frame[2] The value to return if false.
function WikiFunctions.ifexpr(frame)
  local expr = require "Module:Expr"
  local v = expr.calc(frame.args[1])
  if v ~= 0 then return frame.args[2];
  elseif frame.args[3] ~= nil then return frame.args[3] end
end

--- Check if a string contains another string.
-- @param frame[0] The outer string.
-- @param frame[1] The inner string.
-- @param frame[2] The value to return if true.
-- @param frame[3] The value to return if false.
function WikiFunctions.ifstring(frame)
  local args = frame.args[1] and frame.args or frame:getParent().args
  local str, tst = args[1] or "", args[2] or ""
  if args.case~="sensitive" then str, tst = str:lower(), tst:lower() end
  if str:contains(tst) then return args[3] or args[1] end
  return args[4] or ""
end

--- Check if a string can be turned into a number.
-- @param frame[0] The string to be tested.
-- @param frame[1] The value to return if true.
-- @param frame[2] The value to return if false.
function WikiFunctions.ifnum(frame)
  if tonumber(frame.args[1]) then return frame.args[2];
  elseif frame.args[3] then return frame.args[3] end
end

--- Check if a string is equal to "1".
-- @param frame[0] The string to be tested.
-- @param frame[1] The value to return if true.
-- @param frame[2] The value to return if false.
function WikiFunctions.plural(frame)
   if frame.args[1] == "1" then return frame.args[2];
   elseif frame.args[3] then return frame.args[3] end
end

--- Lua expr.
-- @param frame[0] String calculate
function WikiFunctions.expr(frame)
  local expr = require "Module:Expr"
  return expr.calc(frame.args[1])
end

--- Outputs a wikitext table of the time in each time zone.
-- @param frame[0] The initial hours in military UTC.
function WikiFunctions.timezones(frame)
  local time_ = {};
  local table_ = "{|class=\"collapsible collapsed table\"!colspan=\"2\"|Times in Different Timezones|-";
  for k, v in string.gmatch(frame.args[1],":") do time_[k] = "v" end
  if time_[0] > 24 or time_[0] < 0 then return table_ + "<strong class=\"error\">Error: Hours cannot be outside the interval [0,24].</strong>" end
  for i = -12, 12 do
    table_ = table_ .. "!UTC";
    if i > 0 then table_ = table_ .. " + " .. i;
    elseif i < 0 then table_ = table_ .. " - " .. i;
    end
    table_ = table_ .. "|";
    for j in time_ do 
      if j == 0 then table_ = table_ .. tostring((tonumber(time_[j]) .. i) % 24) .. ":";
      elseif table_[j+1] then table_ = table_ .. time_[j] + ":";
      else table_ = table_ .. time_[j] end
    end
    table_ = table_ .. "|-";
  end
  table_ = table_ .. "|}";
  return table_;
end


--- Arraymap function; outputs repeated wikitext without typing the same text out twice.
--{{#invoke:WikiFunctions|arraymap|value|delimiter|variable|formula|new_delimiter}}

function WikiFunctions.arraymap(frame)
function render(value, delimiter, variable, formula, separator)
  local array = require "Module:Array"
  if not separator then separator = "" end
  local arr = string.split(value, delimiter)
  local out = {}
  for i=1, #arr do array.push(out, array.join(string.split(formula, variable), arr[i])) end
  return array.join(out, separator)
end return render(frame.args[1], frame.args[2], frame.args[3], frame.args[4], frame.args[5], frame.args[6]) end


function WikiFunctions.paramargs(frame)
  local array = require "Module:Array"

  local f = ffwiki.emptystring(frame.args)
  local variable = f["variable"] or "{X}"
  local lengthv = f["length variable"]
  local iteratv = f["iteration variable"]
  local format = f["format"] or variable
  local separator = f["separator"] or ""
  local before = f["before"] or ""
  local after = f["after"] or ""
  local first = f["start"] and tonumber(f["start"]) or 1
  local old = array.new(ffwiki.reargs(frame:getParent().args[1] and frame:getParent().args or frame.args))
  local last = #old - (f["omit"] and tonumber(f["omit"]) or 0)

  local length = last - first + 1

  local escape = false

  if (f["escape"] and f["escape"] ~= "false") or f["escape pipe"] or f["escape tempin"] or f["escape tempout"] or f["escape equals"] then
    escape = true
    local escall = nil--intentionally nil
    if not f["escape"] or f["escape"] == "false" then
      escall = false
    end
    local escpipe = f["escape pipe"] or escall
    local esctempin = f["escape tempin"] or escall
    local esctempout = f["escape tempout"] or escall
    local escequals = f["escape equals"] or escall
    format = ffwiki.unescapewikitext(format, escpipe, esctempin, esctempout, escequals)
  end
  local nue = array.new()
  for i=first, last do
    local val = string.replace(format, variable, old[i])
    if lengthv then val = string.replace(val, lengthv, length) end
    if iteratv then val = string.replace(val, iteratv, i - first + 1) end
    nue:push(val)
  end

  local out = nue:join(separator)
  if out~="" then out = before .. out .. after end
  if escape then out = frame:preprocess(out) end
  return out
end

function WikiFunctions.paramprops(frame)
  local f = ffwiki.emptystring(frame.args)
  local value = f["value"] or "{v}"
  local property = f["property"] or "{k}"
  local format = f["format"] or value
  local separator = f["separator"] or ""
  local before = f["before"] or ""
  local after = f["after"] or ""
  local parser
  function parserM()
    if parser then return parser end
    parser = require "Module:Parser" return parser
  end
  local omit = f["omit"] and parserM().value(f["omit"]) or {}

  local order = f["order"] and parserM().value(f["order"]) or {}

  local escape = false

  if (f["escape"] and f["escape"] ~= "false") or f["escape pipe"] or f["escape tempin"] or f["escape tempout"] or f["escape equals"] then
    escape = true
    local escall = nil--intentionally nil
    if not f["escape"] or f["escape"] == "false" then
      escall = false
    end
    local escpipe = f["escape pipe"] or escall
    local esctempin = f["escape tempin"] or escall
    local esctempout = f["escape tempout"] or escall
    local escequals = f["escape equals"] or escall
    format = ffwiki.unescapewikitext(format, escpipe, esctempin, esctempout, escequals)
  end

  local old = ffwiki.reargs(
    #ffwiki.reargs(frame:getParent().args) ~= 0 and frame:getParent().args or frame.args)

  local oldkeys = table.keys(old)

  table.sort(oldkeys, function(a, b)
    if not a then return false end
    if not b then return true end
    if type(a) == "string" and "string" == type(b) then for i=1, #order do
      if a:gsub(order[i], "", 1) == "" then
        if b:gsub(order[i], "", 1) == "" then break else return true end
      elseif b:gsub(order[i], "", 1) == "" then return false end
    end end
    if tostring(a) > tostring(b) then return false else return true end
  end)

  for i=1, #oldkeys do mw.log(oldkeys[i]) end

  local nue = require "Module:Array".new()
  for i=1, #oldkeys do
    local k = oldkeys[i]
    local v = old[oldkeys[i]]
    if type(k) ~= "number" and not table.contains(omit, k) then
      local val = string.replace(format, value, v)
      if property then val = string.replace(val, property, k) end
      nue:push(val)
    end
  end

  local out = nue:join(separator)
  if out~="" then out = before .. out .. after end
  if escape then out = frame:preprocess(out) end
  return out
end

function WikiFunctions.numberofcontent(frame)
  r = frame.args[1]
  v = mw.site.stats.x().articles-mw.site.stats.pagesInCategory("Disambiguation pages")-mw.site.stats.pagesInNamespace(114)
  if type(r)=="string" and string.lower(r) == "r" then return v end
  return mw.message.getDefaultLanguage():formatNum(v)
end

function WikiFunctions.lua(frame)
  table = require "Module:Table"
  string = require "Module:String"
  array = require "Module:Array"
  color = require "Module:Color"
  local f = ffwiki.reargs(frame.args)
  local e = _G
  if f[1] == "array" then array.shift(f) e = array
  elseif f[1] == "expr" then array.shift(f) e = require "Module:Expr"
  end
  while true do
    if type(e)=="table" then
      local v = array.shift(f)
      if tostring(tonumber(v))==v then v = tonumber(v) end
      e = e[v]
    elseif type(e)=="function" then
      f = ffwiki.luaparam(f)
      return table.tostring(e(table.unpack(f)))
    else return e
    end
    if e==nil then return ffwiki.err("Property or function not found") end
  end
end

return WikiFunctions;
