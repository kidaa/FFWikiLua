string = require "Module:String"

--- FFWiki Functions. Functions useful to the Final Fantasy Wiki which will be used by most FFWiki modules.
FFWiki = {}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- Numerical functions  -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
---Round a number to a given number of decimal places.
--@param num The number to be rounded.
--@param idp The number of decimal places.
--@return Number: The number after being rounded.
function FFWiki.round(num, idp)
  local mult = 10^(idp or 0);
  return math.floor(num * mult + 0.5) / mult;
end

---Turns a fraction or decimal into a percentage.
--@param numerator The numerator of the fraction; can also be a decimal, or a whole fraction.
--@param denominator The denominator of the fraction, optional, cannot be 0.
--@param rounding The number of decimal places on the percentage, optional.
--@return String: the number expressed as a percentage.
function FFWiki.topercent(numerator,denominator,rounding)
  local num = numerator;
  if denominator ~= nil and denominator ~= 0 then num = num / denominator;
  elseif denominator == 0 then return "<strong class=\"error\">Error: Division by 0!</strong>" end
  num = 100*FFWiki.round(num,2 + (rounding or 0));
  return tostring(num) .. "%";
end

---Caps a number between two values.
--@param num The number to be capped.
--@param minNum The minimum value. If equal to "inf" then there is no min.
--@param maxNum The maximum value. If equal to "inf" then there is no max.
--@return Number: The number after being capped.
function FFWiki.cap(num,minNum,maxNum)
  local cappedNum = num;
  if minNum == "inf" or not FFWiki.ifnotblank(minNum) then minNum = -math.huge end
  if maxNum == "inf" or not FFWiki.ifnotblank(maxNum) then maxNum = math.huge end
  return math.max(minNum, math.min(num, maxNum));
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- Wikitext parsers  -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
---Substitutes blank spaces for underscores, for example used in linking.
--@param val The string to have substitutions made on.
--@return String: val, but with the substitutions made.
function FFWiki.tounderscore(val)
  return string.gsub(val, " ", "_") .. "";
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- Conditionals   -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
---Returns true if the value is not an empty string.
--@param val The string to be tested.
--@return Boolean: whether val is not an empty string.
function FFWiki.ifnotblank(val)
  return val ~= nil and val ~= "";
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- Debugging   -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
---Generates an error message.
--@param str The string to be turned into an error message.
--@return String: The wikitext for an error message.
function FFWiki.err(str)
  return '<strong class="error">ERROR: ' .. str .. '</strong>';
end

---Prints all values frame.args or a derivative thereof
--@param f - frame.args or a derivative of it
--@return string: Wikitext containing a list of all elements in the table
function FFWiki.printtable(f)
  local n = ""
  for k, v in pairs(f) do
    n = n .. k .. ":" .. v .. "<br/>"
  end
  return n
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- frame -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
---Convert frame.args to #lengthable table
--@param f - frame.args
--@return table: Standard table form of frame.args.
function FFWiki.reargs(f)
  local n = {}
  for k, v in pairs(f) do n[k] = v end
  return n
end

---Turn blank values into nil
--@param f - frame.args
--@return table: frame.args with all empty strings turned into nil
function FFWiki.emptystring(f)
  local n = {}
  for k, v in pairs(f) do
    if mw.text.trim(v) ~= "" then n[k] = v end
  end
  return n
end

-- Converts string inputs into Lua data type inputs-- to allow data type clarity from wikitext
function FFWiki.luaparam(f)
  local parser = require "Module:Parser"
  for k, v in pairs(f) do
    f[k] = parser.value(v)
  end
  return f
end

function FFWiki.unescapewikitext(wikitext, pipe, tempin, tempout, equals)
  if pipe == nil then pipe = "\\" end
  if tempin == nil then tempin = "{@" end
  if tempout == nil then tempout = "@}" end
  if equals == nil then equals = "~" end
  if pipe ~= false then wikitext = string.replace(wikitext, pipe, "|") end
  if tempout ~= false then wikitext = string.replace(wikitext, tempin, "{{") end
  if tempin ~= false then wikitext = string.replace(wikitext, equals, "=") end
  if equals ~= false then wikitext = string.replace(wikitext, tempout, "}}") end
  return wikitext
end

function FFWiki.switch(...)
  local array = require "Module:Array"
  arg = array.new(arg)
  local test = arg:shift()
  for i = 1, #arg, 2 do
    if i == #arg then return arg[i]()
    elseif type(arg[i])=="table" and (arg[i][1] == nil or array.contains(arg[i], test)) or test == arg[i] then return arg[i+1]()
    end
  end
  return nil
end

function FFWiki.type(t) --allows classes to be considered their own types via __type
  local ty = type(t)
  if type(t) ~= "table" then return ty end
  local mt = getmetatable(t)
  local mtty = type(mt)
  if mtty ~= "table" then return ty end
  local mtpr = mt.__type
  if not mtpr then return ty end
  local mtprty = type(mtpr)
  if mtprty == "function" then return mtpr(t) end
  return mtpr
end

function FFWiki.expandTemplate(...)
  --this function doesn't work in console
  local array = require "Module:Array"
  local t
  if type(arg[1])~="table" then
    if type(arg[2])~="table" then
      t = { title = array.shift(arg), args = arg }
    else
      t = { title = arg[1], args = arg[2] }
    end
  else
    t = arg[1]
  end
  return mw.getCurrentFrame():expandTemplate(t)      
end

function FFWiki.frame(...)--creates a fake frame for faking console use
  local frame = {}
  if #arg==1 and #arg[1]==0 and (arg[1].parent or arg[1].args) then
    frame._parent = (arg[1].parent and arg[1].parent.getParent) and arg[1].parent or FFWiki.frame(arg[1].parent)
    arg = arg[1].args
  end
  frame.args = arg or {}
  frame.getParent = function() return frame._parent or FFWiki.frame() end
  frame.expandTemplate = function(t, ...)
    local frargs = FFWiki.reargs(frame.args)
    for k, v in pairs(arg) do
      for kk, vv in pairs(frargs) do
        arg[k]:replace("{{{" .. kk .. "}}}", vv)
      end
    end
    return FFWiki.expandTemplate({title = t, args = arg})
  end
  frame.preprocess = function(t)
    local frargs = FFWiki.reargs(frame.args)
    for k, v in pairs(frargs) do
      t:replace("{{{" .. k .. "}}}", v)
    end
    return t
  end
  return frame
end

return FFWiki
