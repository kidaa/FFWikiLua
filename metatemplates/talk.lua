Talk = {};
ffwiki = require "Module:FFWiki";
string = require "Module:String";

function border(side, width, color)
  if not color then
    ccolor = "transparent"
  elseif tonumber(color) then
    if color == 1 then ccolor = f["border"]
    elseif color == 2 then ccolor = f["border2"]
    elseif color == 3 then ccolor = f["border3"]
    elseif color == 4 then ccolor = f["color"]
    elseif color == 5 then ccolor = f["color2"]
    elseif color == 6 then ccolor = f["color3"]
    else ccolor = "transparent"
    end  
  else ccolor = color
  end
  return string.format(";border-%s:%spx solid %s;", side, tostring(width), ccolor)
end

function dblborder(side1, width1, color1, side2, width2, color2)
  return border(side1, width1, color1) .. border(side2, width2 or width1, color2 or 0)
end

function diagonal(angle, bdid)
  bdid = bdid or ""
  return ";background:linear-gradient(" .. angle .. "deg, transparent 4px, " .. f["border" .. bdid] .. " 5px, " .. f["color" .. bdid] .. " 0);background-origin:border-box;"
end

--laziness
top = "top"
bot = "bottom"
left = "left"
right = "right"

function Talk.main(frame)
  local fr = frame:getParent().args["name"] and frame:getParent() or frame
  f = ffwiki.emptystring(fr.args)
  local container = mw.html.create("div")
  container:cssText("padding:3px")
  local tmp
 
  --debugging
  --[[for k, v in pairs(f) do
    container:wikitext(k .. ":" .. v .. "<br/>")
  end]]--
 
  --default values
  f["corners"] = f["corners"] or "round"
  f["top-left"] = f["top-left"] or f["corners"]
  f["top-right"] = f["top-right"] or f["corners"]
  f["bottom-left"] = f["bottom-left"] or f["corners"]
  f["bottom-right"] = f["bottom-right"] or f["corners"]
  f["border"] = f["border"] or "gray"
  f["border2"] = f["border2"] or f["border"]
  f["border3"] = f["border3"] or f["border2"]
  f["line"] = f["line"] or f["color2"] or f["color"] or "#CCC" --not white
  f["line2"] = f["line2"] or f["line"]
  f["color"] = f["color"] or "white"
  f["color2"] = f["color2"] or f["color"]
  f["textcolor"] = f["textcolor"] or "black"
  f["textcolor2"] = f["textcolor2"] or f["textcolor"]
  f["namecolor"] = f["namecolor"] or f["textcolor"]
  f["fonttype"] = f["fonttype"] or "sans-serif"
  f["fonttype2"] = f["fonttype2"] or f["fonttype"]
  f["namefonttype"] = f["namefonttype"] or f["fonttype"]
  f["linewidth"] = f["linewidth"] or "default"
  f["time"] = f["time"] or "No time given!"

  local colorFields = {
    "color",
    "color2",
    "color3",
    "border",
    "border2",
    "border3",
    "line",
    "line2",
    "textcolor",
    "textcolor2",
    "namecolor"
  }
  for i = 1, #colorFields do
    if type(f[colorFields[i]]) == "string" and string.startswith(f[colorFields[i]], '"') and string.endswith(f[colorFields[i]], '"') then
      f[colorFields[i]] = string.sub(f[colorFields[i]], 2, -2)
    end
  end
 
  --gradients
  local grad, grad2, grad3
  if f["gradient"] then grad = "background-color:" .. f["color"] .. ";background:linear-gradient(" .. f["color"] .. "," .. (f["gradient"] or "white") .. ");"
  else grad = ";background:" .. f["color"] .. ";" end
  if f["color2"] ~= f["color"] then
    if f["gradient2"] then tmp = true
    else tmp = false end
  elseif f["gradient"] then tmp = true
  else tmp = false
  end
  if tmp == true then
    grad2 = ";background-color:" .. f["color2"] .. ";background:linear-gradient(" .. f["color2"] .. "," .. (f["gradient2"] or f["color2"]) .. ");"
    grad3 = ";background-color:" .. (f["color3"] or f["gradient2"] or f["color2"]) .. ";background:linear-gradient(" .. (f["color3"] or f["gradient2"] or f["color2"]) .. "," .. (f["color3"] or f["gradient2"] or f["color2"]) .. ");"
  else
    grad2 = ";background:" .. f["color2"] .. ";"
    grad3 = ";background:" .. (f["color3"] or f["gradient2"] or f["color2"]) .. ";"
  end
  local gradorcol = f["gradient"] or f["color"]
 
  --text font
  local font = "color:" .. f["textcolor"] .. ";font-family:" .. f["fonttype"] .. ";"
 
  --image section
  local imgsectionbool = f["image-section"] or f["image"]
  local imgsection = container:tag("div")
  imgsection:addClass("image-section")
  if imgsectionbool then
    if f["image-section"] then imgsection:wikitext(f["image-section"])
    elseif string.find(f["image"], "http://") then imgsection:wikitext(f["image"])
    else --Local image, must calc image size
      local imgsize, height
      if f["imagesize"] then
        tmp = string.split(f["imagesize"], "px")
        imgsize = tmp[1]
        if string.find(imgsize, "x") then
           height = string.sub(imgsize, 4, 7)
           if tonumber(height) then
              if tonumber(height) > 150 then height = 150 end
           end
           imgsize = "x" .. height
        elseif tonumber(imgsize) > 60 then imgsize = "60"
        end
        imgsection:wikitext("[[File:" .. f["image"] .. "|" .. imgsize .. "px]]")
      else
        imgsection:wikitext("[[File:" .. f["image"] .. "|60px]]")
      end
    end
  end
  if f["notriangle"] then imgsectionbool = false end
 
  --outer table
  local outertable = container:tag("table")
  if f["name"] then outertable:addClass("user-" .. ffwiki.tounderscore(f["name"])) end
  outertable:addClass("talk")
    :attr("cellpadding", "0")
    :attr("cellspacing", "0")
 
  --top border row
  local toprow = outertable:tag("tr")
  toprow:tag("td")

  --top left corner
  local topleft = toprow:tag("td")
  topleft:addClass("filler")
  if f["top-left"] == "diagonal" then
    topleft:cssText(diagonal(135))
  else
    local lfcorner = topleft:tag("div")
    lfcorner:addClass("filler")
      :cssText(dblborder(top, 1, 1, left, 1, 1) .. ";background: " .. f["color"])
    if f["top-left"] == "round" then lfcorner:cssText(";border-top-left-radius:6px") end
  end

  --top middle
  local topmid = toprow:tag("td")
  topmid:cssText("background:" .. f["color"] .. ";" .. border(top, 1, 1))

  --top right corner
  local topright = toprow:tag("td")
  topright:addClass("filler")
  if f["top-right"] == "diagonal" then
    topright:cssText(diagonal(225))
  else
    local rtcorner = topright:tag("div")
    rtcorner:addClass("filler")
      :cssText(dblborder(top, 1, 1, right, 1, 1) .. "background: " .. f["color"])
    if f["top-right"] == "round" then rtcorner:cssText(";border-top-right-radius:6px") end
  end
 
  --top section row
  local topsection = outertable:tag("tr")
  topsection:tag("td")
 
  --top left gradient
  local topleftgradient = topsection:tag("td")
  topleftgradient:cssText(grad .. border(left, 1, 1))
 
  --top section
  local topsectionbox = topsection:tag("td")
  topsectionbox:cssText(grad)
  local topsectiondiv = topsectionbox:tag("div")
  topsectiondiv:addClass("padded")
  if f["name"] then
    if f["top-section"] then topsectiondiv:wikitext(f["top-section"])
    else
      topsectiondiv:wikitext("[[User:" .. f["name"] .. "|<span style=\"font-weight:bold;color:" .. f["namecolor"] .. ";font-family:" .. f["namefonttype"] .. "\">")
        :wikitext(f["name"] .. "</span>]]")
      if f["sig"] then
        local sig = topsectiondiv:tag("span")
        sig:cssText(font .. "font-weight:bold;")
          :wikitext("&nbsp;- " .. f["sig"])
      end
      topsectiondiv:wikitext("<br/>")
        :wikitext("[[User talk:" .. f["name"] .. "|<span style=\"" .. font .. "font-weight:bold;font-size:11px\">")
        :wikitext("TALK</span>]]")
      local time = topsectiondiv:tag("span")
      time:cssText(font .. "font-size:10px;")
        :wikitext(" - " .. tostring(f["time"]))
      if f["time"] == "No time given!" then
        time:addClass("error")
      end
    end
  else
    local noname = topsectiondiv:tag("strong")
    noname:addClass("error")
      :wikitext("Error: {{{name}}} field not specified.")
  end
 
  --top right gradient
  local toprightgradient = topsection:tag("td")
  toprightgradient:cssText(grad .. border(right, 1, 1))
  
  --triangle
  local triangle = outertable:tag("tr")
  local imgsectiongrad = triangle:tag("td")
  imgsectiongrad:addClass("filler2")
  if imgsectionbool then
    local grad1 = imgsectiongrad:tag("div")
    grad1:addClass("corner")
      :cssText(dblborder(bot, 5, 1, left))
    local grad2 = imgsectiongrad:tag("div")
    grad2:addClass("corner")
      :cssText(dblborder(bot, 5, gradorcol, left) .. "margin:-5px -1px 0 1px")
  end
  local imgsectiongrad2 = triangle:tag("td")
  imgsectiongrad2:attr("colspan","3")
    :cssText("background:" .. gradorcol .. border(right, 1, 1))
  if not imgsectionbool then imgsectiongrad2:cssText(border(left, 1, 1)) end
  
  --line width style
  local linewidthtr = outertable:tag("tr")
  local linewidth40 = "0px"
  local linewidth100 = "100%"
  local maxwidth = "inherit"
  local linewidthleft = f["color2"]
  if f["linewidth"] == "default" then
    linewidth40 = "4px"
    linewidth100 = "auto"
  end
  if imgsectionbool then
    tmp = "4"
  else
    tmp = "3"
    linewidthtr:tag("td")
  end
  if f["linewidth"]:find("%%") or f["linewidth"]:find("px") then
    maxwidth = f["linewidth"]
  elseif f["linewidth"] == "full" then
    maxwidth = "100%"
    linewidthleft = f["line"]
  end
  local linewidthtd = linewidthtr:tag("td")
  linewidthtd:attr("colspan", tmp)
    :cssText("background:" .. f["color2"] .. ";text-align:center;" .. dblborder(left, 1, 1, right, 1, 2))
  local linewidthdiv = linewidthtd:tag("div")
  linewidthdiv:cssText("background:" .. f["line"] .. ";height:1px;margin-left:" .. linewidth40 .. ";margin-right:" .. linewidth40 .. ";width:" .. linewidth100 .. ";max-width:" .. maxwidth .. ";")
  if imgsectionbool then
    linewidthdiv:cssText(border(left, 4, linewidthleft))
  end
  
  --bottom half of triangle
  local beforetext = outertable:tag("tr")
  local beforetexttd = beforetext:tag("td")
  beforetexttd:addClass("filler2")
  local beforetexttd2 = beforetext:tag("td")
  beforetexttd2:attr("colspan","3")
    :cssText("background:" .. f["color2"] .. border(right, 1, 2))
  if imgsectionbool then
    local div1 = beforetexttd:tag("div")
    div1:addClass("corner")
      :cssText(dblborder(top, 5, 2, left, 5))
    local div2 = beforetexttd:tag("div")
    div2:addClass("corner")
      :cssText(dblborder(top, 5, 5, left, 5) .. "margin:-5px -1px 0 1px")
  else
    beforetexttd2:cssText(border(left, 1, 2))
  end
  
  --{{{text}}} row
  local textrow = outertable:tag("tr")
  textrow:tag("td")
  local textleft = textrow:tag("td")
  textleft:cssText(border(left, 1, 2) .. grad2)
  local textcell = textrow:tag("td")
  textcell:addClass("text")
    :cssText(grad2)
  local textdiv = textcell:tag("div")
  textdiv:addClass("padded")
    :cssText("color:" .. f["textcolor2"] .. ";font-family:" .. f["fonttype2"])
    :wikitext("\n" .. (f["text"] or "{{{text}}}"))
  local textright = textrow:tag("td")
  textright:cssText(border(right, 1, 2) .. grad2)
  
  --line2 row
  if f["color3"] then
    local line2 = outertable:tag("tr")
    line2:tag("td")
    local line2td = line2:tag("td")
    line2td:attr("colspan", "3")
    local line2div = line2td:tag("div")
    line2div:cssText("background:" .. f["line2"] .. ";height:1px;margin-left:" .. linewidth40 .. ";margin-top:-1px;margin-right:" .. linewidth40 .. ";width:" .. linewidth100 .. ";max-width:" .. maxwidth)
  end
  
  --bottom border row
  f["color3"] = f["color3"] or f["gradient2"] or f["color2"]
  local botrow = outertable:tag("tr")
  botrow:tag("td")
  local botleft = botrow:tag("td")
  botleft:addClass("filler")
  if f["bottom-left"] == "diagonal" then
    botleft:cssText(diagonal(45,3))
  elseif f["bottom-left"] == "round" then
    local corner5 = botleft:tag("div")
    corner5:addClass("filler")
      :cssText(dblborder(bot, 1, 3, left, 1, 3) .. grad3 .. ";border-bottom-left-radius:6px")
  else
    local corner5 = botleft:tag("div")
    corner5:addClass("filler")
      :cssText(dblborder(bot, 1, 3, left, 1, 3) .. grad3)
  end
  local botmid = botrow:tag("td")
  botmid:cssText(grad3 .. border(bot, 1, 3))
  local botright = botrow:tag("td")
  botright:addClass("filler")
  if f["bottom-right"] == "diagonal" then
    botright:cssText(diagonal(315,3))
  elseif f["bottom-right"] == "round" then
    local corner7 = botright:tag("div")
    corner7:addClass("filler")
      :cssText(dblborder(bot, 1, 3, right, 1, 3) .. grad3 .. ";border-bottom-right-radius:6px")
  else
    local corner7 = botright:tag("div")
    corner7:addClass("filler")
      :cssText(dblborder(bot, 1, 3, right, 1, 3) .. grad3)
  end
  
  --clear
  container:cssText("clear:both")
  
  return tostring(container) .. tostring(mw.html.create("div"):css("clear", "both"))
end
 
return Talk
