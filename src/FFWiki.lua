string = require "string";

--- FFWiki Functions. Functions useful to the Final Fantasy Wiki which will be used by most FFWiki modules.
FFWiki = {};

---Returns true if the value is not an empty string.
--@param val The string to be tested.
--@return boolean Whether val is not an empty string.
function FFWiki.ifNotBlank(val)
  if val ~= "" and val ~= nil then return true end
end

---Substitutes blank spaces for underscores, for example used in linking.
--@param val The string to have substitutions made on.
--@return newval val, but with the substitutions made.
function FFWiki.toUnderscore(val)
  return string.gsub(val, " ", "_")
end