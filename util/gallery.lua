Gallery = {}

local ffwiki = require "Module:FFWiki"
local array = require "Module:Array"
string = require "Module:String"

function Gallery.generate(frame)
  local o = "";
  local f = frame:getParent().args[1] and frame:getParent() or frame
  local namespace = f:preprocess("{{NAMESPACE}}") == ""
  local addcat = namespace and '<span id="mntAddImages"></span>[[Category:' .. 'Articles Needing Images]]' or ""
  f = ffwiki.reargs(f.args)
  local s = 150
  for i=1, #f/2 do
    i = (i*2)-1
    if f[i] ~= "" then
      x = GalleryObj.new(f[i], f[i+1])
      local size = s .. "x" .. s .. "px"
      local inner = mw.html.create("div")
      local image = mw.html.create("div")
      local caption = mw.html.create("div")
      inner:addClass("thumb thumbinner b"):node(image):node(caption)
      if x.param.style then inner:cssText(x.param.style) end
      if x.param.class then inner:addClass(x.param.class) end
      if x.param.id then inner:attr("id", x.param.id) end
      image:addClass("gimage"):wikitext(not x.image and ('[[File:Image Placeholder.png|' .. size .. '|link=Special:Upload]]' .. addcat) or (x.param.image and x.param.image or ('[[' .. x.image .. '|' .. size .. ']]')))
      caption:addClass("gallery-caption"):wikitext(x.image and ('<div class="internal sprite details magnify">[[:' .. x.image .. '|<span class="icon-link"></span>]]</div>') or ""):wikitext(x.caption)
      o = o .. tostring(inner)
      i = i + 2
    end
  end
  return o
end

GalleryObj = {}

function GalleryObj.new(image, caption, param)
  obj = {}
  if type(image) == "string" then
    local p
    image, p = GalleryObj.parseImageString(image)
    if not param and p then param = p end
  elseif image == nil then image = false
  elseif image ~= false then return nil
  end
  if type(caption) ~= "string" then
    if caption == nil or caption == false then caption = ""
    else return nil
    end
  end
  if type(param) == "string" then param = GalleryObj.parseParamString(param)
  elseif type(param) == "table" then param = GalleryObj.convertImageTable(param)
  else param = {}
  end
  obj = { image = image, caption = caption, param = param, getParamString = function(self) return GalleryObj.buildParamString(self.param) end }
  return obj
end

GalleryObj.params = { "style", "class", "id", "image" }

function GalleryObj.convertImageTable(t)
  for k,v in pairs(t) do
    if not array.contains(GalleryObj.params, k) then t[k] = nil end
  end
  return t
end

function GalleryObj.parseImageString(s)
  local p = nil
  if string.contains(s, "#") then
    local spl = string.split(s, "#")
    s = array.shift(spl)
    p = GalleryObj.parseParamString(array.join(spl, "#"))
  end
  if string.lower(s) == "x" then return false end
  if not string.contains(s, ".") then return nil end
  if string.contains(s, ":") then
    local spl = string.split(s, ":")
    array.shift(spl)
    local page = array.join(spl, ":")
    s = "File:" .. page
  else s = "File:" .. s
  end
  return s, p
end

function GalleryObj.buildParamString(t)
  local o = ""
  for k,v in pairs(t) do
    if array.contains(GalleryObj.params, k) and v ~= false then o = o .. k .. '(' .. (v == true and "" or v)  .. ')' end
  end
  return o
end

function GalleryObj.parseParamString(s)
  if string.startswith(s, "#") then s = string.sub(s, 2) end
  local paramObj = {}
  while string.contains(s, "(") do
    local cha = string.tochartable(s)
    local k = array.indexof(cha, "(")
    local v = false
    local bc = 1
    for i=k+1,#cha do
      if cha[i] == "(" then bc = bc + 1
      elseif cha[i] == ")" then bc = bc - 1
      end
      if bc == 0 then v = i break
      elseif i == #cha then return nil
      end
    end
    local key = string.sub(s, 1, k-1)
    local val = string.sub(s, k+1, v-1)
    if val == "" then val = true end
    if array.contains(GalleryObj.params, key) then paramObj[key] = val end
    s = string.sub(s, v+1)
  end
  return paramObj
end


return Gallery
