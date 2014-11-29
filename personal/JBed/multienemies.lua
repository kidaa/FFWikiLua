local multiEnemies = {}

function multiEnemies.battle(frame)
  local array = require "Module:Array"
  local ffwiki = require "Module:FFWiki"
  string = require "Module:String"
  local t = ffwiki.reargs(frame.args)--testing parameters
  local f = array.shift(t)--"formula"
  local titlef = array.shift(t)--"formula"
  f = f:gsub("\\", "|"):gsub("~", "="):gsub("{@", "{{"):gsub("@}", "}}")
  titlef = titlef:gsub("\\", "|"):gsub("~", "="):gsub("{@", "{{"):gsub("@}", "}}")
  local o = {}
  for i=1, #t do
    if(i~=1 and t[i] == "") then break end
    local only = (i==1 and (#t==1 or t[2]==""))
    local intro = ""
    if not only then
      intro = '<div class="tabbertab" title="' .. frame:getParent():preprocess(string.gsub(titlef, "<#>", i)) .. '">'
    end

    local content = string.gsub(f, "<#>", i)

    local outro = ""
    if not only then outro = '</div>' end
    array.push(o, intro .. content .. outro)
  end
  local content = array.join(o)
  content = frame:getParent():preprocess(content)
  if #o ~= 1 then return '<div class="tabber" title="battle">' .. content .. '</div>'
  else return content end
end

return multiEnemies
