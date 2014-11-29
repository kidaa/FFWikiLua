--This module creates Infobox metatemplates. Requires certain CSS classes from common.css as well as FFWiki libraries.
--Written by Catuse167 of FFWiki.
Infobox = {}
 
ffwiki = require "Module:FFWiki"
string = require "Module:String"
tabber = require "Module:Tabber"
html = require "Module:Html"
lseq = string.lettersequence()

--Returns a cell table containing attributes for common parameters.
--Default colspan and rowspan is 1; default th is false.
function cell(txt, style, class, colspan, rowspan, th)
  return {
    ["txt"] = txt,
    ["th"] = th or false,
    ["attr"] = {
      ["class"] = class,
      ["style"] = style,
      ["colspan"] = colspan,
      ["rowspan"] = rowspan,
    }
  }
end

--Returns a row with a single text-aligned cell.
function allrow(txt, class)
  return {
    cell(txt, "text-align:center;", class or "a", 100, 1, true)
  }
end

--Returns a row with a single cell with an image inside.
function image(img, size, defsize, label)
  local row
  if string.contains(img,"File:") then row = allrow(img, "seriesb")
  elseif img then row = allrow("[[File:" .. img .. "|" .. (size or defsize or "upright") .. "|" .. label .. "]]", "seriesb")
  else row = allrow("{{{image}}}", "seriesb") end
  return row
end

--Helper function that gets a release name from the classcode.
function codename(ccode)
  local data = mw.loadData("Module:Codename/data")
  local name
  if data.rel[ccode] then name = data.rel[ccode].full
  elseif data.ser[ccode] then name = data.ser[ccode].full
  else name = false
  end  
  return name
end

--Helper function that takes a frame and converts it into a table representative of HTML.
function parse(frame)
  local f = ffwiki.emptystring(frame)
  local info = {}
 
  info.classes = "infobox " .. (f.ccode or "series")
 
  if f.tabs then
    for k, v in pairs(tabs) do
      info.tabs[i] = parse(v)
      info.tabs.header = f.header
    end
 
  else
    local i = 1
    info.rows = {}
	
    if f["above"] then --above table
      local css = "text-align:center;"
      local cells = {}
	  cells[1] = cell(f["above"], css, "a name", "2", "1", true)
	  info.rows[i] = cells
	  i = i + 1
    end
	
    while true do --Iterate over the rows (letters)
      local cells = {}
      local j = 1
      if not (f["label" .. lseq[i] .. "1"] or f["cell" .. lseq[i] .. "1"]) then break end
      while true do --Iterate over the cells in each row (numbers)
        local o = lseq[i] .. j
        if not (f["label" .. o] or f["cell" .. o]) then break end
        cells[j] = cell((f["label" .. o] or f["cell" .. o]), f["style" .. o], f["class" .. o], f["colspan" .. o], f["rowspan" .. o], f["label" .. o])
        j = j + 1
      end
      info.rows[i] = cells
      i = i + 1
    end
	
    if f["below"] then --below table
      local css = "text-align:center;"
      local cells = {}
	  cells[1] = cell(f["below"], css, "a footer", "2", "1", true)
	  info.rows[i] = cells
	  i = i + 1
    end
  end
 
  return info
end

--Helper function that converts a Lua table to an HTML table containing the infobox.
function render(info)
  local tbl = html.create("table")
 
  if info.tabs then --Tabber loop
    if info.tabs.header then tbl:tag("tr"):tag("th"):class("header"):tag("div"):class("a"):wikitext(info.header) end
    local tbr = tabber.create("ibox")
    for k, v in info.tabs do tbr.newTab(v.title,render(v)) end
    tbl:tag("tr"):tag("td"):node(tbr)
 
  else
    tbl:addClass(info.classes)
 
    for k, v in pairs(info.rows) do --Iterate over the rows
      local tr = tbl:tag("tr")
      for l, w in pairs(v) do --Iterate over the cells in each row
        if w.th then tr:tag("th"):attr(w.attr):wikitext(w.txt)
        else tr:tag("td"):attr(w.attr):wikitext(w.txt)
        end
      end
    end
  end
 
  return tbl
end

--Creates a standard two-column character infobox with game name at the bottom.
function Infobox.character(frame)
  if frame:getParent().args.name then frame = frame:getParent() end
  local f = ffwiki.emptystring(frame.args)
  
  local rel = codename(f.ccode) or f.game or "{{{game}}}"
  
  local parsef = {
    classes = "infobox character " .. (f.ccode or "series"),
      rows = { --Character, image, and game rows
        allrow(f.name, "a name"),
        image(f.image, f.size, f.defsize, f.imglabel or f.name),
      }
  }
  
  --Fields
  local i = 1
  while true do --Iterate over letters for each field
    if not f["label" .. lseq[i]] then break end
    if f["content" .. lseq[i]] then
    local row = {
      cell(f["label" .. lseq[i]], "width:110px", f["label" .. lseq[i] .. " class"] or "a"),
      cell(f["content" .. lseq[i]], "", f["content" .. lseq[i] .. " class"] or "b")
    }
    table.insert(parsef.rows, row)
    end
    i = i + 1
  end
  table.insert(parsef.rows, allrow("[[List of " .. rel .. " Characters|<span class=\"a\">'''''" .. rel .. "'' Character'''</span>]]", "a footer"))

  return render(parsef)
end

--Creates an infobox containing enemy information. Probably useless to code thieves.
--Preprocessing includes calculating enemy stats that can be derived from other stats.
--Has tabber support, and unlike wikitext, can make a calculation once and then use it in multiple tabs.
--Multiple enemy boxes on one page can greatly increase load time.
function Infobox.enemy(frame)

end
 
--Creates a standard two-column infobox containing information about releases.
function Infobox.release(frame)
  if frame:getParent().args.title then frame = frame:getParent() end
  local f = ffwiki.emptystring(frame.args)
  
  local jp = "'''" .. (f.japan or "{{{japan}}}") .. "'''<br/>''" .. (f.romaji or "{{{romaji}}}") .. "''"
  
  local parsef = {
    classes = "infobox release series",
    rows = {  --Title, image, and japanese rows
      allrow(f.title, "a name"),
      image(f.image, f.size, f.defsize, f.imglabel or f.title),
      allrow(jp)
    }
  }
  
  --Fields
  local i = 1
  while true do --Iterate over letters for each field
    if not f["label" .. lseq[i]] then break end
    if f["content" .. lseq[i]] then
    local row = {
      cell(f["label" .. lseq[i]], "width:110px", f["label" .. lseq[i] .. " class"] or "a", f["label" .. lseq[i] .. " style"]),
      cell(f["content" .. lseq[i]], "", f["content" .. lseq[i] .. " class"] or "b", f["content" .. lseq[i] .. " style"])
    }
    table.insert(parsef.rows, row)
    end
    i = i + 1
  end
  
  return render(parsef)
end

--Creates a generic infobox. Not as customizable as prerender().
function Infobox.misc(frame)
 
end

--Creates an infobox whose cells have been preprocessed in the wikitext invoking it.
--Should only be used for debugging or in extreme cases where misc() does not work, because
--preprocessing defeats the purpose of Lua, i.e. to do all calculations outside of wikitext.
function Infobox.prerender(frame)
  if frame:getParent().args.cell1A or frame:getParent().args.label1A then frame = frame:getParent() end
  return render(parse(frame.args))
end
 
return Infobox
