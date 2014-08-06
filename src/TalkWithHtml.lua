-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- Global variables  -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
Talk = {};

--Includes
ffwiki = require "FFWiki";
mw = require "mw";

--Shorthands
exists = ffwiki.ifNotBlank;
html = mw.html;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- Private functions and methods -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--Returns f[param] if it exists, otherwise given, otherwise from Defaults[]
function getdefspointer(param,given)
  if exists(f[param]) and f[param] ~= "default" then return f[param];
  elseif exists(given) then return given;
  else return Defaults[param] end
end

function imageSize(strSize) --Calculates image size, not allowing >150px height and defaulting to 60px width
  if not exists(strSize) then return "60px" end --if user doesn't specify size default to 60px

  strSize = string.gsub(strSize, "px", "");
  local dimensions, dimension, i;
  for i, dimension in string.gmatch(strSize, "%d+") do dimensions[i] = tonumber(dimension) end

  if dimensions[1] == nil then --if user only specifies width
    if dimensions[0] > 60 then return "60px" end --if user specifies width > 60px
    return tostring(dimensions[0]) + "px";
  elseif dimensions[1] > 150 then --if user specifies height > 150px
    dimensions[0] = dimensions[0] * 150 / dimensions[1];
    dimensions[1] = 150;
    return tostring(dimensions[0]) + "x" + tostring(dimensions[1]) + "px";
  else return tostring(dimensions[0]) + "x" + tostring(dimensions[1]) + "px" end --if user specifies height <= 150px
end

function throwError(err)
  return "<span class=\"error\">" + err + "</span>";
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- Constant tables   -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--Defaults
Defaults = {
  ["get"] = getdefspointer;
  ["color"] = "white";
  ["color2"] = Defaults.get("color");
  ["border"] = "gray";
  ["border2"] = Defaults.get("border");
  ["corners"] = "round";
  ["top"] = Defaults.get("corners");
  ["top-left"] = Defaults.get("top");
  ["top-right"] = Defaults.get("top");
  ["bottom"] = Defaults.get("corners");
  ["bottom-left"] = Defaults.get("bottom");
  ["bottom-right"] = Defaults.get("bottom");
  ["textcolor"] = "black";
  ["namecolor"] = Defaults.get("textcolor");
  ["fonttype"] = "sans-serif";
  ["namefonttype"] = Defaults.get("fonttype");
  ["linewidth"] = "4px";
  ["nick"] = f["name"];
};

--Styles
dcolor = Defaults.get("color"); --only calc these once
dtextcolor = Defaults.get("textcolor");
dborder = Defaults.get("border");
dfont = Defaults.get("fonttype")
dgradient = Defaults.get("gradient");

Styles = {
  ["outer"] = "padding:3px;";
  ["imageSection"] = "width:64px;max-width:69px;float:left;";
  ["bubbleWrapper"] = "margin-left:64px;";
  ["header"] = "padding:0 4px;margin:0 -5px;";
  ["background"] = "background:" + dcolor;
  ["name"] = "font-weight:bold; color:" + Defaults.get("namecolor") or dtextcolor + "; font-type: " + Defaults.get("namefonttype") or dfont;
  ["tdTopCorner"] = "width:6px;height:6px";
  ["tdTopMiddle"] = "background: " + dcolor + ";border-top:1px solid " + dborder;
  ["topGradient"] = "background-color: " + dcolor + ";background:linear-gradient(" + dcolor + "," + dgradient + ")";
  ["topLeftDiagonalCorner"] = "font-size: 0px; line-height: 0%; width: 0px; border-bottom:6px solid " + dborder + "; border-left:6px solid transparent";
  ["topLeftDiagonalCorner2"] = "font-size: 0px; line-height: 0%; width: 0px;border-bottom: 5px solid " + dcolor + ";border-left: 5px solid transparent;margin-left:1px;margin-top:-5px";
  ["topLeftRoundCorner"] = "border-top:1px solid " + dcolor + ";border-left:1px solid " + dborder + ";width:6px;height:6px;background:" + dcolor + ";border-top-left-radius:6px";
  ["topLeftCorner"] = "border-top:1px solid " + dcolor + ";border-left:1px solid " + dborder + ";width:6px;height:6px;background:" + dcolor;
  ["topLeftNoGradient"] = "background:" + dcolor + ";border-left:1px solid " + dborder;
  ["topRightDiagonalCorner"] = "font-size: 0px; line-height: 0%; width: 0px; border-bottom:6px solid " + dborder + "; border-right:6px solid transparent";
  ["topRightDiagonalCorner2"] = "font-size: 0px; line-height: 0%; width: 0px;border-bottom: 5px solid " + dcolor + ";border-right: 5px solid transparent;margin-left:1px;margin-top:-5px";
  ["topRightRoundCorner"] = "border-top:1px solid " + dcolor + ";border-right:1px solid " + dborder + ";width:6px;height:6px;background:" + dcolor + ";border-top-left-radius:6px";
  ["topRightCorner"] = "border-top:1px solid " + dcolor + ";border-left:1px solid " + dborder + ";width:6px;height:6px;background:" + dcolor;
  ["topRightNoGradient"] = "background:" + dcolor + ";border-right:1px solid " + dborder;
};

dcolor, dborder = nil;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- Public methods -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function Talk.Bubble(frame)
  f = frame.args; --Set frame.args to a global pointer. Might not work - if not try for loop?
  local outer = html.create("div",{["style"] = Styles.outer});
  
  --Image section
  local imageSection = outer:tag("div",{["style"] = Styles.imageSection});
  if exists(f["image-section"]) or exists(f["image"]) then
    local hasImageSection = true;
    if exists(f["image-section"]) then imageSection:wikitext(f["image-section"]);
    elseif string.find(f["image"], "http://") then imageSection:wikitext(f["image"]);
    else --Local image, must calc image size
      local imageSize, strSize, dimensions, dimension;
      if exists(f["imagesize"]) then
        strSize = string.gsub(strSize, "px", "");
        for i, dimension in string.gmatch(strSize, "%d+") do dimensions[i] = tonumber(dimension) end
        if dimensions[1] == nil then --if user only specifies width
          if dimensions[0] > 60 then imageSize = "60px"; --if user specifies width > 60px
          else imageSize = tostring(dimensions[0]) + "px" end
        elseif dimensions[1] > 150 then --if user specifies height > 150px
          dimensions[0] = dimensions[0] * 150 / dimensions[1];
          dimensions[1] = 150;
          imageSize = tostring(dimensions[0]) + "x" + tostring(dimensions[1]) + "px";
        else imageSize = tostring(dimensions[0]) + "x" + tostring(dimensions[1]) + "px" end --if user specifies height <= 150px
      else imageSection:wikitext("[[File:" + f["image"] + "|" + imageSize(f["imagesize"])) end
      end
  else
    local hasImageSection = false;
  end
  
  --Top of bubble
  local bubbleWrapper = outer:tag("table",{["class"] = "talk user-" + ffwiki.toUnderscore(f["name"]);["cellpadding"] = "0";["cellspacing"] = "0";["style"] = Styles.bubbleWrapper});
  local trTopCorners = bubbleWrapper:tag("tr");
  trTopCorners:tag("td");
  local tdTopLeftCorner = trTopCorners:tag("td", {["style"] = Styles.tdTopCorner});
  if Defaults.get("top-left") == "diagonal" then
    tdTopLeftCorner:tag("div",{["style"] = Styles.topLeftDiagonalCorner});
    tdTopLeftCorner:tag("div",{["style"] = Styles.topLeftDiagonalCorner2});
  elseif Defaults.get("top-left") == "round" then
    tdTopLeftCorner:tag("div",{["style"] = Styles.topLeftRoundCorner});
  else
    tdTopLeftCorner:tag("div",{["style"] = Styles.topLeftCorner});
  end
  trTopCorners:tag("td",{["style"] = Styles.tdTopMiddle});
  local tdTopRightCorner = trTopCorners:tag("td", {["style"] = Styles.tdTopCorner});
  if Defaults.get("top-right") == "diagonal" then
    tdTopRightCorner:tag("div",{["style"] = Styles.topRightDiagonalCorner});
    tdTopRightCorner:tag("div",{["style"] = Styles.topRightDiagonalCorner2});
  elseif Defaults.get("top-right") == "round" then
    tdTopRightCorner:tag("div",{["style"] = Styles.topRightRoundCorner});
  else
    tdTopRightCorner:tag("div",{["style"] = Styles.topRightCorner});
  end

  --Header
  local header = bubbleWrapper:tag("tr"):tag("div",{["style"] = Styles.header});
  header:tag("td");
  local headertd;
  if exists(f["gradient"]) then
    header:tag("td",{["style"] = Styles.topGradient});
    headertd = header:tag("td",{["style"] = Styles.topGradient});
  else
    header:tag("td",{["style"] = Styles.topLeftNoGradient});
    headertd = header:tag("td",{["style"] = Styles.background});
  end
  local headerdiv = headertd:tag("div",{["style"] = Styles.header});
  if exists(f["name"]) then
    if exists(f["top-section"]) then headerdiv:wikitext(f["top-section"]);
    else
      local headername = headerdiv:tag("a",{["style"] = Styles.name});
      headername:wikitext(Defaults.get("nick"));
      --Sig and time go here
    end
  else
    headerdiv:wikitext(throwError("{{{name}}} field not specified."));
  end
 
  --Below header
  bubbleWrapper = calcBelowHeader(bubbleWrapper);
  
  return tostring(outer);
end

return Talk;
