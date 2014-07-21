--Maybe make deffonttype and deftxtcolor styles of the outer div rather than add them in individually every time

--TO DO:
-- Talk.Bubble(): write LuaDoc, body, bottom gradients and corners, end wrappers
-- corners(): make workable
-- all: bugtest the hell out of

ffwiki = require "FFWiki";
Talk = {};

exists = ffwiki.ifNotBlank;

function default(param) --Returns the default value if frame[param] is nil, or frame[param] otherwise
  if exists(f[param]) then return f[param];
  elseif param == "color" then return "white";
  elseif param == "border" then return "gray";
  elseif param == "corner" then return "round";
  elseif param == "textcolor" then return "black";
  elseif param == "fonttype" then return "sans-serif";
  elseif param == "nick" then return f["name"];
  elseif param == "namecolor" then
    if f["textcolor"] ~= nil then return f["textcolor"];
    else return "black" end
  elseif param == "namefonttype" then
    if f["fonttype"] ~= nil then return f["fonttype"];
    else return "sans-serif" end
  else return nil;
  end
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

function corners(cornerarg) --Returns HTML for corners of the talk bubble. INCOMPLETE
  local html = "||style=\"width:6px;height:6px\"|";
  local border = default(f, "border");
  local color = default(f, "color");
  local corner = default(f, "corners");
  if exists(f[cornerarg]) then corner = f[cornerarg]; --if user specifies individual corner
  elseif exists(f["corner"]) then corner = f["corners"] end --if user specifies any corner
  if corner == "diagonal" then
   html = html + "<div style=\"font-size: 0px; line-height: 0%; width: 0px;";
    if cornerarg == "top-left" then html = html + "border-bottom:6px solid " + border + ";border-left:6px solid transparent\"></div><div style=\"font-size: 0px; line-height: 0%; width: 0px;border-bottom: 5px solid " + color + ";border-left: 5px solid transparent;margin-left:1px;margin-top:-5px\"></div>" end
  end
  return html
end

--- Generates the wikitext of a talk bubble.
-- @return Wikitext for a talk bubble.
-- @param frame An array containing the following keys:
function Talk.Bubble(frame)--Central method, returns the wikitext for a talk bubble
  f = frame; --Make global
  
  --Defaults are constants, only calculate them once
  local defcolor = default("color");
  local defborder = default("border");
  local deftxtcolor = default("textcolor");
  local deffonttype = default("fonttype");
  
  --Calculate gradients
  local gradient;
  if exists(f["gradient"]) then gradient = "background-color:" + defcolor + ";background:linear-gradient(" + defcolor + "," + default("gradient") + ";";
  else gradient = "background:" + defcolor + ";"; end
  
  --Outer wrapper
  local result = "<div style=\"padding:3px;\">";
  
  --Image
  result = result + "<div style=\"width:64px;max-width:69px;float:left;\">";
  if f["image_section"] then result = result + f["image_section"]; --Custom image selection
  elseif exists(f["image"]) then
    if string.find(f["image"], "http://") then result = result + f["image"]; --URL image selection
    else result = result + "[[File:" + f["image"] + "|" + imageSize(f["imagesize"]) end --Local image selection
  end
  result = result + "</div>";
  
  --Bubble wrapper
  result = result + "{|class=\"talk user-" + ffwiki.toUnderscore(f["name"]) + "cellpadding=\"0\" cellspacing=\"0\"style=\"margin-left:64px;\"";
  result = result + corners(f, "top-left");
  result = result + "|style=\"background:" + defcolor + ";border-top:1px solid " + defborder + ";\"";
  result = result + corners(f, "top-right");
  
  --Top of header
  result = result + "|style=\"" + gradient + "border-left:1px solid " + defborder + "\"";
  result = result + "|style=\"" + gradient + "|<div style=\"padding:0 4px;margin:0 -5px\">";
  
  --Header
  if exists(f["name"]) and exists(f["top-section"]) then result = result + f["top-section"];
  elseif exists(f["name"]) then
    result = result + "<span style=\"font-weight:bold\">[[User:" + f["name"] + "|";
    result = result + "<span style=\"color:" + default("namecolor") + ";font-family:" + default("namefonttype") + "\">" + default("nick") + "</span>]]"
    result = result + "<span style=\"color:" + deftxtcolor + ";font-family:" + default("fonttype") + ">"
    if exists(f["sig"]) then result = result + "&nbsp;- " + f["sig"] end
    result = result + "</span></span><br/>[[User talk:" + f["name"] + "|" + "<span style=\"color:" + deftxtcolor;
    result = result + ";font-size:11px;font-family:" + deffonttype + "\">TALK</span>]] <span style=\"color:" + deftxtcolor;
    result = result + ";font-size:10px;font-family:" + deffonttype + "\">- " + f["time"] + "</span>"
  else result = result + "<strong class=\"error\">Error: {{{name}}} field not specified.</strong><br><span style=\"font-size:8px\">" + f["time"] + "</span>}}</div>" end
  result = result + "|style=\"" + gradient + "border-right:1px solid " + defborder + "\"";
  result = result + "|-";

 --Bottom of header
  result = result + "\|style=\"width:5px;height:4px\"|";
  if exists(f["image"]) or exists(f["image-section"]) then
    result = result + "<div style=\"font-size: 0px; line-height: 0%; width: 0px; border-bottom:5px solid " + defborder;
    result = result + ";border-left:5px solid transparent\"></div><div style=\"font-size: 0px; line-height: 0%; width: 0px;border-bottom: 5px solid " + default("gradient");
    result = result + ";border-left: 5px solid transparent;margin:-5px -1px 0 1px\"></div>";
  end
  result = result + "|colspan=\"3\" style=\"" + gradient + "\";border-right:1px solid " + defborder + ";";
  if not exists(f["image"]) and not exists(f["image-section"]) then result = result + "border-left:1px solid " + defborder + ";\"||-";
  else result = result + "\"||-|" end

--|colspan="{{#if:{{{image|{{{image-section|}}}}}}|4|3}}" style="background:{{{color2|{{{color|white}}}}}};text-align:center;border-left:1px solid {{{border|gray}}};border-right:1px solid {{{border2|{{{border|gray}}}}}}"|<div style="background:{{{line|{{{color2|{{{color|#CCCCCC}}}}}}}}};height:1px;margin-left:{{#ifeq:{{{linewidth|default}}}|default|4|0}}px;margin-right:{{#ifeq:{{{linewidth|default}}}|default|4|0}}px;width:{{#if:{{{linewidth|default}}}|default|auto|100%}};max-width:{{ifnum|{{#sub:{{{linewidth}}}|0|1}}|{{ifstring|{{{linewidth}}}|%|{{{linewidth}}}|{{ifnum|{{#replace:{{{linewidth}}}|px|}}}}px}}|{{#ifeq:{{{linewidth|default}}}|full|100%|inherit}}}};{{#if:{{{image|{{{image-section|}}}}}}|border-left:4px solid {{#ifeq:{{{linewidth|default}}}|full|{{{line|{{{color2|{{{color|#CCCCCC}}}}}}}}}|{{{color2|{{{color|white}}}}}}}}}};"></div>
--|-
--|style="width:5px;height:4px"|{{#if:{{{image|{{{image-section|}}}}}}|<div style="font-size: 0px; line-height: 0%; width: 0px;
--border-top: 5px solid {{{border2|{{{border|gray}}}}}};
--border-left: 5px solid transparent"></div><div style="font-size: 0px; line-height: 0%; width: 0px;border-top: 5px solid {{{color2|{{{color|white}}}}}};border-left: 5px solid transparent;margin:-5px -1px 0 1px"></div>}}
--|colspan="3" style="background:{{{color2|{{{color|white}}}}}};border-right:1px solid {{{border2|{{{border|gray}}}}}};{{#if:{{{image|{{{image-section|}}}}}}||border-left:1px solid {{{border2|{{{border|gray}}}}}}}}"|
--|-
--|
--|style="border-left:1px solid {{{border2|{{{border|gray}}}}}};{{#if:{{#if:{{{color2|}}}|{{{gradient2|}}}|{{{gradient|}}}}}|background-color:{{{color2|{{{color|white}}}}}};background:linear-gradient({{{color2|{{{color|white}}}}}},{{{gradient2|{{{color2|{{{color|white}}}}}}}}})|background:{{{color2|{{{color|white}}}}}}}}"|
--|class="text" style="{{#if:{{#if:{{{color2|}}}|{{{gradient2|}}}|{{{gradient|}}}}}|background-color:{{{color2|{{{color|white}}}}}};background:linear-gradient({{{color2|{{{color|white}}}}}},{{{gradient2|{{{color2|{{{color|white}}}}}}}}})|background:{{{color2|{{{color|white}}}}}}}}"|<div style="color:{{{textcolor2|{{{textcolor|black}}}}}};font-family:{{{fonttype2|{{{fonttype|sans-serif}}}}}};padding:0 4px;margin:0 -5px">
--{{{text}}}</div>
--|style="border-right:1px solid {{{border2|{{{border|gray}}}}}};{{#if:{{#if:{{{color2|}}}|{{{gradient2|}}}|{{{gradient|}}}}}|background-color:{{{color2|{{{color|white}}}}}};background:linear-gradient({{{color2|{{{color|white}}}}}},{{{gradient2|{{{color2|{{{color|white}}}}}}}}})|background:{{{color2|{{{color|white}}}}}}}}"|
--|-
--{{#if:{{{color3|}}}|{{!}}
--{{!}}colspan="3"{{!}}<div style="background:{{{line2|{{{line|{{{color2|{{{color|#CCCCCC}}}}}}}}}}}};height:1px;margin-left:{{#ifeq:{{{linewidth|default}}}|default|4|0}}px;margin-top:-1px;margin-right:{{#ifeq:{{{linewidth|default}}}|default|4|0}}px;width:{{#if:{{{linewidth|default}}}|default|auto|100%}};max-width:{{ifnum|{{#sub:{{{linewidth}}}|0|1}}|{{ifstring|{{{linewidth}}}|%|{{{linewidth}}}|{{ifnum|{{#replace:{{{linewidth}}}|px|}}}}px}}|{{#ifeq:{{{linewidth|default}}}|full|100%|inherit}}}}"></div>}}
--|-

  result = result + corners(f, "bottom-left");
--|style="{{#if:{{#if:{{{color2|}}}|{{{gradient2|}}}|{{{gradient|}}}}}|background-color:{{{color3|{{{gradient2|{{{color2|{{{color|white}}}}}}}}}}}};background:linear-gradient({{{color3|{{{gradient2|{{{color2|{{{color|white}}}}}}}}}}}},{{{color3|{{{gradient2|{{{color2|{{{color|white}}}}}}}}}}}})|background:{{{color3|{{{color2|{{{color|white}}}}}}}}}}};border-bottom:1px solid {{{border3|{{{border2|{{{border|gray}}}}}}}}}"
  result = result + corners(f, "bottom-right");

  result = result + "</div><div style=\"clear:both\"></div>"; --End outer wrapper
  return result;
end

return Talk;