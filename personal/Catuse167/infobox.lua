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
  else row = allrow(inc("image"), "seriesb") end
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

--Helper function that returns {{{name}}} in an error message.
function inc(name) return '<strong class="error">{{{' .. name .. '}}}</strong>' end

--Helper function that iterates over a table, creating a tabber table for render()
--using the appropriate function.
function tabtable(f, versions, func)
  local ret = {}
  for k, v in pairs(versions) do
    ret[k] = func(f, v)
    ret[k].title = k
  end
  return ret
end

--Helper function that creates a stat cell.
function statcell(stat, version, dver)
  return cell(f[version .. " " .. stat] or statcell(stat, dver) or "{{{" .. version .. " " .. stat .. "}}}")
end

--Takes a frame and converts it into a table representative of HTML.
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

--These functions are different for each game and are used by enemy() to calculate stats
--for that game and organize them into a Lua table to be render()ed.
enemies = {}

function enemies.FFI(f, version)
  if version then
    if not f[version] then return nil end --If enemy doesn't exist in this version
	
    --Japanese
    local jp = "[[Final Fantasy/Translations|" .. f[version .. " japan"] or f.japan .. "(''" .. f[version .. " romaji"] or f.romaji "'')"
    
    local no = tonumber(f.bestiary) --Bestiary
    local mod = {
      PS = 128,
      GBA = 195,
      PSP = 203
    }
    local pre = no - 1
    if pre == 0 then pre = mod[version] end
    local nex = (no + 1) % mod[version]
    local best = {
      classes = "ebest",
      rows = {
        {
          cell("[[" .. f.prev .. "|#" .. pre .. "]] ←", bestleft),
          cell("[[Bestiary (Final Fantasy)|#" .. f.bestexec or no .. "]]", bestcenter),
          cell("→ [[" .. f.next .. "|#" .. nex .. "]]", bestright) 
        }
      }
    }

    local stats = { --Statistics
      classes = "estats",
      rows = {
        allrow("Statistics"),
        {
          cell("HP", "", "", 2, 1, true),
          cell("Attack", "width:33%", "", 2, 1, true),
          cell("Intelligence", "width:33%", "", 2, 1, true)
        },
        {
          statcell("HP", version),
          statcell("Attack", version),
          statcell("Intelligence", version)
        },
        {
          cell("Defense", "width:50%", "", 3, 1, true),
          cell("Magic Defense", "width:50%", "", 3, 1, true)
        },
        {
          statcell("Defense", version),
          statcell("Magic Defense", version)
        },
        {
          cell("Agility", "", "", 2, 1, true),
          cell("Accuracy", "", "", 2, 1, true),
          cell("Evasion", "", "", 2, 1, true)
        },
        {
          statcell("Agility", version),
          statcell("Accuracy", version),
          statcell("Evasion", version)
        }
      }
    }
    stats = {render(stats)}

    local affinites = { --Elemental affinities
      classes = "eclasses",
      rows = {
        allrow("Elemental Affinities"),
        {
          cell("[[Fire (Element)|Fire]]", "", "", 1, 1, true),
          cell("[[Lightning (Element)|Lightning]]", "", "", 1, 1, true),
          cell("[[Ice (Element)|Ice]]", "", "", 1, 1, true),
          cell("[[Element (Term)|Dia]]", "", "", 1, 1, true),
        },
        {
          statcell("Fire", version),
          statcell("Lightning", version),
          statcell("Ice", version), 
          statcell("Dia", version)
        }
      }
    }
    affinities = {render(affinities)}

    local location = { --Misc. stats
      cell("Location", "b", "width:35%", "", 1, 1, true),
      statcell("Location", version)
    }
    local items = {
      cell("Item Dropped", "b", "width:35%", "", 1, 1, true),
      statcell("Item Dropped", version)
    }
    local abilities = {
      cell("[[List of Final Fantasy Enemy Abilities|Abilities]]", "b", "width:35%", "", 1, 1, true),
      statcell("Abilities", version)
    }
    local resistant = {
      cell("Resistant to", "b", "width:35%", "", 1, 1, true),
      statcell("Resistance", version)
    }
    
    if version == "NES" or version == "PS" then --Per version exceptions
      stats.rows[2][2].style = "width:50%"
      table.remove(stats.rows[2], 3)
      table.remove(stats.rows[3], 3)
      table.remove(stats.rows[6], 1)
      table.remove(stats.rows[7], 1)
      affinities.rows[2][2].txt = "[[Lightning (Element)|Bolt]]"
      affinities.rows[3][2].txt = "Bolt"
      items = nil
    end
    if version == "PS" then
      table.remove(stats.rows, 6)
      table.remove(stats.rows, 7)
    end
    
    local parsef = {
      allrow(f[version],ename), --Name
      allrow(jp,ejp),
      image(f[version .. " image"]),
      best,
      stats,
      affinities,
      location,
      items,
      abilities,
      resistant
    }
    
    if version == "NES" then --More exceptions
      table.remove(parsef, 4) --Bestiary
      table.remove(parsef, 7) --Items dropped
    elseif version == "PS" then
      table.remove(parsef, 8) -- Items dropped
    end
    
    return parsef
  else
    return tabtable(f, {"NES", "SNES", "PS", "GBA", "PSP"}, enemies.FFI)
  end
end

function enemies.FFII(f, version)
  if version then
    
    return parsef
  else
    return tabtable(f, {"NES", "DSOP", "PS", "GBA", "PSP"}, enemies.FFII)
  end
end

--Helper function that converts a Lua table to an HTML table containing the infobox.
--The second argument is to help with recursion when you already have an incomplete table,
--and outside of render() should never be passed directly to this function.
function render(info, deftbl)
  local tbl = deftbl or html.create("table")
  tbl.addClass(info.classes)

  if info.tabs then --Tabber loop	
    if info.tabs.header then tbl:tag("tr"):tag("th"):class("header"):tag("div"):class("a"):wikitext(info.header) end
	info.tabs.header = nil --don't iterate over this
	
    if not info.tabs[2] then return render(info.tabs[1],tbl) end --if there's only 1 tab
	
    local tbr = tabber.create("ibox")
    for k, v in info.tabs do tbr.newTab(v.title,render(v)) end --iterate over each tab
    tbl:tag("tr"):tag("td"):node(tbr)
 
  else --Single tab
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
  
  local rel = codename(f.ccode) or f.game or inc("game")
  
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
  if frame:getParent().args.name then frame = frame:getParent() end
  local f = ffwiki.emptystring(frame.args)
  
  local parsef = {
    classes = "infobox enemy " .. (f.ccode or "series"),
	tabs = {
      header = allrow("[[List of " .. codename(f.ccode) .. " Characters|<span class=\"a\">'''''" .. codename(f.ccode) .. "'' Character'''</span>]]", "a header"),
	}
  }
  
  local enemyfunc = enemies[ccode](f)
  for k, v in pairs(enemyfunc) do
    parsef.tabs[k] = enemyfunc[v]
  end
  
  return render(parsef)
end
 
--Creates a standard two-column infobox containing information about releases.
function Infobox.release(frame)
  if frame:getParent().args.title then frame = frame:getParent() end
  local f = ffwiki.emptystring(frame.args)
  
  local jp = "'''" .. (f.japan or inc("japan")) .. "'''<br/>''" .. (f.romaji or inc("romaji")) .. "''"
  
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
        cell(f["label" .. lseq[i]], "width:110px", f["label" .. lseq[i] .. " class"] or "a"),
        cell(f["content" .. lseq[i]], "", f["content" .. lseq[i] .. " class"] or "b")
      }
	  table.insert(parsef.rows, row)
    end
    i = i + 1
  end
  
  parsef.rows[3][1].th = false
  
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
