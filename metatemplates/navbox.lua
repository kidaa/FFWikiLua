--TEST FOR MAIN NAVBOX MODULE. DO NOT MAKE SIGNIFICANT CHANGES ADDING CONTENT TO THE MAIN MODULE WITHOUT TESTING HERE AND ON [[Project:Sandsea]] FIRST.
--This module creates the Navbox metatemplate. Requires certain CSS classes from Common.css as well as the libraries for FFWiki, Array, String and Html.
--For information on how to use Navboxes, see [[Template:Navbox]].
Navbox = {}

ffwiki = require "Module:FFWiki"
array = require "Module:Array"
string = require "Module:String"
mw.html = require "Module:Html"

--Invoke function. Parses Navbox from frame and outputs in HTML
function Navbox.main(frame)
  if frame:getParent().args.title then frame = frame:getParent() end
  return Navbox.render(Navbox.parse(ffwiki.emptystring(frame.args)))
end

--Parses frame properties into Lua Navbox object
function Navbox.parse(f)
  local n = {}
  n.nested = not not (f[1] and f[1]:contains("nested"))
  n.editlink = f["editlink"]
  n.above = f["above"] and { text = f["above"] } or false
  n.below = f["below"] and { text = f["below"] } or false
  n.position = f["position"] or "bottom"
  n.width = f["width"] or (n.position=="bottom" and "100%" or "200px")
  n.class = f["class"] or "series"
  n.collapsible = true
  n.collapsed = n.position=="bottom"

--Metatables for inheritence
  n.inherit = {}
  n.inherit.__index = n.inherit
  if f["meta class"] then n.inherit.class = f["meta class"] or "" end
  n.inherit.style = f["meta style"] or ""
  n.inherit.block = {}
  n.inherit.block.__index = n.inherit.block
  setmetatable(n.inherit.block, n.inherit)
  if f["blocks class"] then n.inherit.block.class = f["blocks class"] end
  if f["blocks style"] then n.inherit.block.style = n.inherit.block.style .. ";" .. f["blocks style"] end
  n.inherit.block.collapsible = true
  n.inherit.block.collapsed = false
  n.inherit.block.columns = false
  n.inherit.block.wraplinks = false
  n.inherit.block.normallists = false
  n.inherit.content = {}
  n.inherit.content.__index = n.inherit.content
  setmetatable(n.inherit.content, n.inherit)
  if f["contents class"] then n.inherit.content.class = f["contents class"] end
  if f["contents style"] then n.inherit.content.style = n.inherit.content.style .. ";" .. f["contents style"] end
  n.inherit.group = {}
  n.inherit.group.__index = n.inherit.group
  setmetatable(n.inherit.group, n.inherit)
  if f["groups class"] then n.inherit.group.class = f["groups class"] end
  if f["groups style"] then n.inherit.group.style = n.inherit.group.style .. ";" .. f["groups style"] end
  n.inherit.subgroup = {}
  n.inherit.subgroup.__index = n.inherit.subgroup
  setmetatable(n.inherit.subgroup, n.inherit)
  if f["subgroups class"] then n.inherit.subgroup.class = f["subgroups class"] end
  if f["subgroups style"] then n.inherit.subgroup.style = n.inherit.subgroup.style .. ";" .. f["subgroups style"] end
  n.inherit.header = {}
  n.inherit.header.__index = n.inherit.header
  setmetatable(n.inherit.header, n.inherit)
  if f["headers class"] then n.inherit.header.class = f["headers class"] end
  if f["headers style"] then n.inherit.header.style = n.inherit.header.style .. ";" .. f["headers style"] end
  n.title = {}
  setmetatable(n.title, n.inherit)
  mw.log(n.title.style)
  n.title.text = f["title"] or "Title?"
  if f["title class"] then n.title.class = f["title class"] end
  if f["title style"] then n.title.style = n.title.style .. ";" .. f["title style"] end  
  if n.above then
    setmetatable(n.above, n.inherit)
    if f["above class"] then n.above.class = f["above class"] end
    if f["above style"] then n.above.style = n.above.style .. ";" .. f["above style"] end
  end
  if n.below then
    setmetatable(n.below, n.inherit)
    if f["below class"] then n.below.class = f["below class"] end
    if f["below style"] then n.below.style = n.below.block.style .. ";" .. f["below style"] end
  end

  do
    local opt = "," .. string.gsub(f["options"] or "", " ", "") .. ","
    if string.contains(opt, ",nocollapse,") then n.collapsible = false n.collapsed = false
    elseif string.contains(opt, ",collapsed,") then n.collapsed = true
    elseif string.contains(opt, ",uncollapsed,") then n.collapsed = false
    end
    if string.contains(opt, ",uncollapsiblegroups,") then n.inherit.block.collapsible = false n.inherit.block.collapsed = false
    elseif string.contains(opt, ",collapsedgroups,") then n.inherit.block.collapsed = true end
    if string.contains(opt, ",columns,") then n.inherit.block.columns = true end
    if string.contains(opt, ",normallists,") then n.inherit.block.normallists = true end
    if string.contains(opt, ",wraplinks,") then n.inherit.block.wraplinks = true end
  end

--Blocks.
  n.blocks = array.new()
  i = 1
  while true do
    local l = string.lettersequence(i)
    if not
      (f["content" .. l .. "1"]
    or f["content" .. l .. "1a"]
    or f["nested" .. l]
    or f["nestedplain" .. l])
    then break end
    local blk = { }

    blk.header = f["block" .. l] and { text = f["block" .. l] } or false
    blk.title = f["header" .. l] and { text = f["header" .. l] } or false
    setmetatable(blk, n.inherit.block)
    blk.inherit = {}
    blk.inherit.__index = blk.inherit
    setmetatable(blk.inherit, n.inherit.block)
    if f[l.." class"] then blk.inherit.class = f["contents"..l.." class"] end
    if f[l.." style"] then blk.inherit.style = blk.inherit.style .. ";" .. f["contents"..l.." style"] end
    blk.inherit.content = {}
    blk.inherit.content.__index = blk.inherit.content
    setmetatable(blk.inherit.content, n.inherit.content)
    if f["contents"..l.." class"] then blk.inherit.content.class = f["contents"..l.." class"] end
    if f["contents"..l.." style"] then blk.inherit.content.style = blk.inherit.content.style .. ";" .. f["contents"..l.." style"] end
    blk.inherit.group = {}
    blk.inherit.group.__index = blk.inherit.group
    setmetatable(blk.inherit.group, n.inherit.group)
    if f["groups"..l.." class"] then blk.inherit.group.class = f["groups"..l.." class"] end
    if f["groups"..l.." style"] then blk.inherit.group.style = n.inherit.group.style .. ";" .. f["groups"..l.." style"] end
    if blk.title then
      setmetatable(blk.title, n.inherit.header)
      if f["header" .. l .. " class"] then blk.title.class = f["header" .. l .. " class"] end
      if f["header" .. l .. " style"] then blk.title.style = blk.title.style .. ";" .. f["header" .. l .. " style"] end
    end
    if blk.header then
      setmetatable(blk.header, n.inherit.header)
      if f["block" .. l .. " class"] then blk.header.class = f["block" .. l .. " class"] end
      if f["block" .. l .. " style"] then blk.header.style = blk.header.style .. ";" .. f["block" .. l .. " style"] end
    end

    blk.nest = f["nested" .. l] and frame:expandTemplate({ title = f["nested" .. l], args =  {"nested"}}) or (f["nestedplain" .. l] or false)
    do
      local opt = "," .. string.gsub(f["options" .. l] or "", " ", "") .. ","
      if string.contains(opt, ",nocollapse,") then blk.collapsible = false blk.collapsed = false
      elseif string.contains(opt, ",collapsed,") then blk.collapsed = true
      elseif string.contains(opt, ",uncollapsed,") then blk.collapsed = false
      end
      if string.contains(opt, ",columns,") then blk.columns = true end
      if string.contains(opt, ",normallists,") then blk.normallists = true end
      if string.contains(opt, ",wraplinks,") then blk.wraplinks = true end
    end

--Block's groups
    blk.groups = array.new()
    local j = 1
    while true do
      local k = l .. j
      if not (f["content" .. k] or f["content" .. k .."a"] or f["group" .. k]) then break end
      grp = {}
      setmetatable(grp, n.inherit.group)
      grp.inherit = {}
      grp.inherit.__index = grp.inherit
      setmetatable(grp.inherit, n.inherit.group)
      grp.header = f["group" .. k] and { text = f["group" .. k] } or false
      if grp.header then setmetatable(grp.header, blk.inherit.group) end
      if f["group" .. k .. " class"] then grp.header.class = f["group" .. k .. " class"] end
      if f["group" .. k .. " style"] then grp.header.style = grp.header.style .. ";" .. f["group" .. k .. " style"] end
      grp.content = f["content" .. k] and { text = f["content" .. k] } or false
      if grp.content then setmetatable(grp.content, blk.inherit.content) end
      if f["content" .. k .. " class"] then grp.content.class = f["content" .. k .. " class"] end
      if f["content" .. k .. " style"] then grp.content.style = grp.content.style .. ";" .. f["content" .. k .. " style"] end

--Block's group's subgroups
      grp.subgroups = array.new()
      local m = 1
      while true do
        local o = string.lettersequence(m):lower()
        local p = l .. j .. o
        if not (f["content" .. p] or f["subgroup" .. p]) then break end
        subgrp = {}
        setmetatable(subgrp, n.inherit.subgroup)
        subgrp.header = f["subgroup" .. p] and { text = f["subgroup" .. p] } or false
        if subgrp.header then setmetatable(subgrp.header, grp.inherit.subgroup) end
        if f["subgroup" .. p .. " class"] then subgrp.header.class = f["subgroup" .. p .. " class"] end
        if f["subgroup" .. p .. " style"] then subgrp.header.style = subgrp.header.style .. ";" .. f["subgroup" .. p .. " style"] end
        subgrp.content = f["content" .. p] and { text = f["content" .. p] } or false
        if subgrp.content then setmetatable(subgrp.content, grp.inherit.content) end
        if f["content" .. p .. " class"] then subgrp.content.class = f["content" .. p .. " class"] end
        if f["content" .. p .. " class"] then subgrp.content.class = subgrp.content.style .. ";" .. f["content" .. p .. " style"] end
        grp.subgroups:push(subgrp)
        m = m + 1
      end
      blk.groups:push(grp)
      j = j + 1
    end
    n.blocks:push(blk)
    i = i + 1
  end
  return n
end

--Converts Lua Navbox object into HTML
function Navbox.render(nav)

--Outer
  local container = mw.html.create("div")
  local main = mw.html.create("div")
  local title = mw.html.create("div")
  local contents = mw.html.create("table")
  container:addClass("navbox-container"..
  ((nav.position=="left" or nav.position=="right" or nav.position=="bottom") and (" " .. nav.position) or ""))
    :css("width", nav.width)
    :node(main)
  if nav.editlink then container:attr("id", nav.editlink .. "-nav") end
  main:addClass("navbox"):node(title):node(contents)
  if nav.nested then main:addClass("nested") end
  if nav.collapsible then main:addClass("collapsible slide") end
  if nav.collapsed then main:addClass("collapsed") end
  title:addClass("title header " .. (nav.title.class and (nav.title.class .."a") or (nav.class .. ((not nav.nested or (nav.blocks[1] and nav.blocks[1].nest or false)) and "a" or "b"))))
  if not nav.nested then title:addClass("maintitle") end
  title:cssText(nav.title.style)
  if nav.editlink then title:tag("div"):addClass("editlink"):wikitext(ffwiki.expandTemplate({ title = "tnav", args = { nav.editlink }})) end
  title:tag("div"):addClass("titletext"):wikitext(nav.title.text)

  function spaceV(col, tag) if tag then return mw.html.create(tag):addClass("space-v") end return mw.html.create("tr"):addClass("space-v"):tag("td"):attr("colspan", col or 1):done() end

  function spaceH(row) return mw.html.create("td"):addClass("space-h"):attr("rowspan", row or 1) end

  contents:addClass("contents"):attr("cellpadding", "0"):attr("cellspacing", "0")

--Above-blocks
  if(nav.above) then
    contents:node(spaceV())
          :tag("tr"):tag("td"):addClass("abovebelow " .. (nav.above.class and (nav.above.class .. "a") or (nav.class .. "b"))):wikitext(nav.above.text)
  end

--Blocks
  local blocksarray = mw.html.create("td")
  contents:tag("tr"):node(blocksarray)
  blocksarray:addClass("brickcont")
  for i=1,#nav.blocks do
    blocksarray:node(spaceV(1, "div"))
    if nav.blocks[i].nest then
      blocksarray:wikitext(nav.blocks[i].nest)
    else
      local blockcontainer = mw.html.create("div")
      blocksarray:node(blockcontainer)
      local blocktable = mw.html.create("table")
      local title = nav.blocks[i].title and mw.html.create("div") or nil
      if title then
        blockcontainer:node(title):node(spaceV(1, "div"))
        title:addClass("navheader header")
          :addClass(nav.blocks[i].title.class
            and nav.blocks[i].title.class .. "a"
            or nav.class .. "b")
          :cssText(nav.blocks[i].title.style)
          :tag("div")
            :addClass("headertext")
            :wikitext(nav.blocks[i].title.text)
        if nav.blocks[i].collapsible then blockcontainer:addClass("collapsible slide") end
        if nav.blocks[i].collapsed then blockcontainer:addClass("collapsed") end
      end
      if not nav.blocks[i].normallists then blockcontainer:addClass("formatlist") end
      if not nav.blocks[i].wraplinks then blockcontainer:addClass("nowraplinks") end

      blockcontainer:node(blocktable)
      blocktable:addClass("brick"):attr("cellpadding", "0"):attr("cellspacing", "0")
      
      if nav.blocks[i].columns then
        blockcontainer:addClass("columncont")
      else
        blockcontainer:addClass("standardcont")
      end

      local table = { rows = { } }
      if nav.blocks[i].header then
        table.header = mw.html.create("td")
          :addClass("group")
          :cssText(nav.blocks[i].header.style)
          :wikitext(nav.blocks[i].header.text)
        local cls = ""
        if nav.blocks[i].header.class then
          cls = nav.blocks[i].header.class .. "a"
        elseif nav.blocks.header and nav.blocks.header.class then
          cls = nav.blocks.header.class .. "b"
        else
          cls = nav.class  .. "b"
        end
        table.header:addClass(cls)
      end
--Create Groups HTML elements
      for j=1,#nav.blocks[i].groups do
        table.rows[j] = {}
        if nav.blocks[i].groups[j].header then
          table.rows[j].header = mw.html.create("td")
            :addClass((nav.blocks[i].columns and "col" or (nav.blocks[i].groups[j].header and "sub" or "")) .. "group")
            :cssText(nav.blocks[i].groups[j].header.style)
          local cls = ""
          if nav.blocks[i].groups[j].header.class then
            cls = nav.blocks[i].groups[j].header.class .. "a"
          elseif nav.blocks[i].header and nav.blocks[i].header.class then
            cls = nav.blocks[i].header.class .. "b"
          elseif nav.blocks[i].title and nav.blocks[i].title.class then
            cls = nav.blocks[i].title.class .. "b"
          else
            cls = nav.class .. "b"
          end
          table.rows[j].header:addClass(cls):wikitext(nav.blocks[i].groups[j].header.text)
        end
        if nav.blocks[i].groups[j].content then
          table.rows[j].content = mw.html.create("td")
            :addClass(nav.blocks[i].columns and "navcolumn" or "cell")
            :wikitext("\n" .. nav.blocks[i].groups[j].content.text)
            :cssText(nav.blocks[i].groups[j].content.style)
          local cls = ""
          if nav.blocks[i].groups[j].content.class then
            cls = nav.blocks[i].groups[j].content.class .. "a" end
          table.rows[j].content:addClass(cls)
        end
--Orders groups and creates HTML for standard content and subgroups
        if not nav.blocks[i].columns and not nav.blocks[i].groups[j].content then for m=i,#nav.blocks[i].groups[j].subgroups do
		  if not table.rows[j].subrows then table.rows[j].subrows = {} end
          table.rows[j].subrows[m] = {}
          if nav.blocks[i].groups[j].subgroups[m].header then
            table.rows[j].subrows[m].header = mw.html.create("td")
              :addClass("subgroup")
              :cssText(nav.blocks[i].groups[j].subgroups[m].header.style)
            local cls = ""
            if nav.blocks[i].groups[j].subgroups[m].header.class then
              cls = nav.blocks[i].groups[j].subgroups[m].header.class .. "a"
            elseif nav.blocks[i].header and nav.blocks[i].header.class then
              cls = nav.blocks[i].header.class .. "b"
            elseif nav.blocks[i].title and nav.blocks[i].title.class then
              cls = nav.blocks[i].title.class .. "b"
            else
              cls = nav.class .. "b"
            end
            table.rows[j].subrows[m].header:addClass(cls):wikitext(nav.blocks[i].groups[j].subgroups[m].header.text)
            table.rows[j].subrows[m].content = mw.html.create("td")
              :addClass("cell")
              :wikitext("\n" .. nav.blocks[i].groups[j].subgroups[m].content.text)
              :cssText(nav.blocks[i].groups[j].subgroups[m].content.style)
            local cls = ""
            if nav.blocks[i].groups[j].subgroups[m].content.class then
              cls = nav.blocks[i].groups[j].subgroups[m].content.class .. "a" end
            table.rows[j].subrows[m].content:addClass(cls)
          end
        end end
      end

--Orders groups and creates HTML for column content
      local gHeadEx = false
      for k=1, #table.rows do
        if table.rows[k].header then gHeadEx = true break end
      end
      if nav.blocks[i].columns then
        local hTr = gHeadEx and mw.html.create("tr") or nil
        local cTr = mw.html.create("tr")
        local rows = hTr and 3 or 1
        local cols = #table.rows + (table.header and 1 or 0)
        local wid = math.floor(100 / cols)
        if hTr then blocktable:node(hTr):node(spaceV((cols*2)-1)) end
        blocktable:node(cTr)
        if table.header then
          (hTr or cTr):node(table.header):node(spaceH(rows))
          table.header:attr("rowspan", rows)
          table.header:css("width", wid .. "%")
        end
        for k=1, #table.rows do
          if k ~= 1 then (hTr or cTr):node(spaceH(rows)) end
          if hTr then if table.rows[k].header then
            hTr:node(table.rows[k].header)
          else
            hTr:tag("td")
          end end
          table.rows[k].content:css("width", wid .. "%")
          cTr:node(table.rows[k].content)
        end
      else
        local cols = 1 + (table.header and 1 or 0) + (gHeadEx and 1 or 0)
        for k=1, #table.rows do
          contentcols = 1
          local tr = mw.html.create("tr")
          if k ~= 1 then blocktable:node(spaceV()) end
          blocktable:node(tr)
          if k==1 and table.header then
            tr:node(table.header):node(spaceH((#table.rows*2)-1))
            table.header:attr("rowspan", (#table.rows*2)-1)
          end
          if table.rows[k].header then
            tr:node(table.rows[k].header):node(spaceH())
          else contentcols = contentcols + 1
          end
          if table.rows[k].content then
            tr:node(table.rows[k].content)
            table.rows[k].content
            :attr("colspan", (contentcols*2) - 1)
            :addClass(((table.header or table.rows[k].header) and "with" or "no") .. "groups")
          end
        end
      end
      
    end
  end

--Below-contents
  if(nav.below) then
    contents:node(spaceV())
    :tag("tr"):tag("td"):addClass("abovebelow " .. (nav.below.class and (nav.below.class .. "a") or (nav.class .. "b"))):wikitext(nav.below.text)
  end

--Output
  return nav.nested and tostring(main) or tostring(container)
end

return Navbox
