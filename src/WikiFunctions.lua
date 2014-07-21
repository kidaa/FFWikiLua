ffwiki = require "FFWiki";

--- WikiFunctions are a replacement to ParserFunctions, allows Lua logic and FFWiki[] methods to be applied
-- outside of Lua.
WikiFunctions = {};

--- Check if a string is not blank.
-- @param frame[0] The value to be tested.
-- @param frame[1] The value to be returned if frame[0] isn't blank.
-- @param frame[2] The value to be returned if frame[0] is blank.
function WikiFunctions.ifnotblank(frame)
  if ffwiki.ifNotBlank(frame[0]) then return frame[1];
  elseif frame[2] ~= nil then return frame[2] end
end

--- Check if two values are equal to each other.
-- @param frame[0] The first value to be tested.
-- @param frame[1] The second value to be tested.
-- @param frame[2] The value to return if true.
-- @param frame[3] The value to return if false.
function WikiFunctions.ifeq(frame)
  if frame[0] == frame[1] then return frame[2];
  elseif frame[3] ~= nil then return frame[3] end
end

--- Check if an expression evaluates to true.
-- @param frame[0] The expression to be tested.
-- @param frame[1] The value to return if true.
-- @param frame[2] The value to return if false.
function WikiFunctions.ifexpr(frame)
  if frame[0] and frame[0] ~= "0" then return frame[1];
  elseif frame[2] ~= nil then return frame[2] end
end

--- Check if a string contains another string.
-- @param frame[0] The outer string.
-- @param frame[1] The inner string.
-- @param frame[2] The value to return if true.
-- @param frame[3] The value to return if false.
function WikiFunctions.ifstring(frame)
  if string.find(frame[0], frame[1]) then return frame[2];
  elseif frame[3] then return frame[3] end
end

--- Check if a string can be turned into a number.
-- @param frame[0] The string to be tested.
-- @param frame[1] The value to return if true.
-- @param frame[2] The value to return if false.
function WikiFunctions.ifnum(frame)
  if tonumber(frame[0]) then return frame[1];
  elseif frame[2] then return frame[2] end
end

--- Check if a string is equal to "1".
-- @param frame[0] The string to be tested.
-- @param frame[1] The value to return if true.
-- @param frame[2] The value to return if false.
function WikiFunctions.plural(frame)
   if frame[0] == "1" then return frame[1];
   elseif frame[2] then return frame[2] end
end

--- Outputs a wikitext table of the time in each time zone.
-- @param frame[0] The initial hours in military UTC.
-- @param frame[1] The initital minutes [and seconds].
--[[function WikiFunctions.timezones(frame)
  local table = "{|class=\"collapsible collapsed table\"";
  for i = 12, 1, -1 do table = table + "!UTC - " i + "|" + frame[0] + ":" + frame[1] + "|-" end
  table = table + "!UTC|" + frame[0] + ":" + frame[1] + "|-";
  for i = 1, 12 do table = table + "!UTC + " i + "|" + frame[0] + ":" + frame[1] + "|-" end
  table = table + "|}";
  return table;
end]]--
return WikiFunctions;