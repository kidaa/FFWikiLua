p = {}
string = require "Module:String"
ffwiki = require "Module:FFWiki"

function math.round(a, b)
  b = b or 0
  a = a * (10^b)
  a = math.ceil(a-0.5)
  a = a / (10^b)
  return a
end

function p.hexchart()
  local hex = "0123456789ABCDEF"
  local tbl = mw.html.create("table")
  tbl:addClass("full-width")
  for i = 1,16 do
    for j = 1,16 do
      local tr = tbl:tag("tr")
      for k = 1,16 do
        local color = "#" .. hex:sub(i,i) .. hex:sub(j,j) .. hex:sub(k,k)
        tr:tag("td"):css("background", color):css("text-align", "center"):wikitext(color):css("color", tostring(p.new(color):textcolor()))
      end
    end
  end
  return tbl
end

p.bgdisplay = function(self, elem)
  if ffwiki.type(self) ~= "color" then
    if self.args then elem = self.args[2] self = self.args[1] end
    self = p.new(self)
  end
  if not elem then elem = "span" end
  local textcolor = tostring(self:textcolor())
  return mw.html.create(elem):wikitext(tostring(self)):css({ background = tostring(self), color = textcolor }):addClass(textcolor == "#FFFFFF" and "lightlinks" or "darklinks")
end

p.colors = {} p.colors.x = {
  aliceblue = { r = 240, g = 248, b = 255 },
  antiquewhite = { r = 250, g = 235, b = 215 },
  aqua = { r = 0, g = 255, b = 255 },
  aquamarine = { r = 127, g = 255, b = 212 },
  azure = { r = 240, g = 255, b = 255 },
  beige = { r = 245, g = 245, b = 220 },
  bisque = { r = 255, g = 228, b = 196 },
  black = { r = 0, g = 0, b = 0 },
  blanchedalmond = { r = 255, g = 235, b = 205 },
  blue = { r = 0, g = 0, b = 255 },
  blueviolet = { r = 138, g = 43, b = 226 },
  brown = { r = 165, g = 42, b = 42 },
  burlywood = { r = 222, g = 184, b = 135 },
  cadetblue = { r = 95, g = 158, b = 160 },
  chartreuse = { r = 127, g = 255, b = 0 },
  chocolate = { r = 210, g = 105, b = 30 },
  coral = { r = 255, g = 127, b = 80 },
  cornflowerblue = { r = 100, g = 149, b = 237 },
  cornsilk = { r = 255, g = 248, b = 220 },
  crimson = { r = 220, g = 20, b = 60 },
  cyan = { r = 0, g = 255, b = 255 },
  darkblue = { r = 0, g = 0, b = 139 },
  darkcyan = { r = 0, g = 139, b = 139 },
  darkgoldenrod = { r = 184, g = 134, b = 11 },
  darkgray = { r = 169, g = 169, b = 169 },
  darkgreen = { r = 0, g = 100, b = 0 },
  darkkhaki = { r = 189, g = 183, b = 107 },
  darkmagenta = { r = 139, g = 0, b = 139 },
  darkolivegreen = { r = 85, g = 107, b = 47 },
  darkorange = { r = 255, g = 140, b = 0 },
  darkorchid = { r = 153, g = 50, b = 204 },
  darkred = { r = 139, g = 0, b = 0 },
  darksalmon = { r = 233, g = 150, b = 122 },
  darkseagreen = { r = 143, g = 188, b = 143 },
  darkslateblue = { r = 72, g = 61, b = 139 },
  darkslategray = { r = 47, g = 79, b = 79 },
  darkturquoise = { r = 0, g = 206, b = 209 },
  darkviolet = { r = 148, g = 0, b = 211 },
  deeppink = { r = 255, g = 20, b = 147 },
  deepskyblue = { r = 0, g = 191, b = 255 },
  dimgray = { r = 105, g = 105, b = 105 },
  dodgerblue = { r = 30, g = 144, b = 255 },
  firebrick = { r = 178, g = 34, b = 34 },
  floralwhite = { r = 255, g = 250, b = 240 },
  forestgreen = { r = 34, g = 139, b = 34 },
  fuchsia = { r = 255, g = 0, b = 255 },
  gainsboro = { r = 220, g = 220, b = 220 },
  ghostwhite = { r = 248, g = 248, b = 255 },
  gold = { r = 255, g = 215, b = 0 },
  goldenrod = { r = 218, g = 165, b = 32 },
  gray = { r = 128, g = 128, b = 128 },
  green = { r = 0, g = 128, b = 0 },
  greenyellow = { r = 173, g = 255, b = 47 },
  honeydew = { r = 240, g = 255, b = 240 },
  hotpink = { r = 255, g = 105, b = 180 },
  indianred = { r = 205, g = 92, b = 92 },
  indigo = { r = 75, g = 0, b = 130 },
  ivory = { r = 255, g = 255, b = 240 },
  khaki = { r = 240, g = 230, b = 140 },
  lavender = { r = 230, g = 230, b = 250 },
  lavenderblush = { r = 255, g = 240, b = 245 },
  lawngreen = { r = 124, g = 252, b = 0 },
  lemonchiffon = { r = 255, g = 250, b = 205 },
  lightblue = { r = 173, g = 216, b = 230 },
  lightcoral = { r = 240, g = 128, b = 128 },
  lightcyan = { r = 224, g = 255, b = 255 },
  lightgoldenrodyellow = { r = 250, g = 250, b = 210 },
  lightgray = { r = 211, g = 211, b = 211 },
  lightgreen = { r = 144, g = 238, b = 144 },
  lightpink = { r = 255, g = 182, b = 193 },
  lightsalmon = { r = 255, g = 160, b = 122 },
  lightseagreen = { r = 32, g = 178, b = 170 },
  lightskyblue = { r = 135, g = 206, b = 250 },
  lightslategray = { r = 119, g = 136, b = 153 },
  lightsteelblue = { r = 176, g = 196, b = 222 },
  lightyellow = { r = 255, g = 255, b = 224 },
  lime = { r = 0, g = 255, b = 0 },
  limegreen = { r = 50, g = 205, b = 50 },
  linen = { r = 250, g = 240, b = 230 },
  magenta = { r = 255, g = 0, b = 255 },
  maroon = { r = 128, g = 0, b = 0 },
  mediumaquamarine = { r = 102, g = 205, b = 170 },
  mediumblue = { r = 0, g = 0, b = 205 },
  mediumorchid = { r = 186, g = 85, b = 211 },
  mediumpurple = { r = 147, g = 112, b = 219 },
  mediumseagreen = { r = 60, g = 179, b = 113 },
  mediumslateblue = { r = 123, g = 104, b = 238 },
  mediumspringgreen = { r = 0, g = 250, b = 154 },
  mediumturquoise = { r = 72, g = 209, b = 204 },
  mediumvioletred = { r = 199, g = 21, b = 133 },
  midnightblue = { r = 25, g = 25, b = 112 },
  mintcream = { r = 245, g = 255, b = 250 },
  mistyrose = { r = 255, g = 228, b = 225 },
  moccasin = { r = 255, g = 228, b = 181 },
  navajowhite = { r = 255, g = 222, b = 173 },
  navy = { r = 0, g = 0, b = 128 },
  oldlace = { r = 253, g = 245, b = 230 },
  olive = { r = 128, g = 128, b = 0 },
  olivedrab = { r = 107, g = 142, b = 35 },
  orange = { r = 255, g = 165, b = 0 },
  orangered = { r = 255, g = 69, b = 0 },
  orchid = { r = 218, g = 112, b = 214 },
  palegoldenrod = { r = 238, g = 232, b = 170 },
  palegreen = { r = 152, g = 251, b = 152 },
  paleturquoise = { r = 175, g = 238, b = 238 },
  palevioletred = { r = 219, g = 112, b = 147 },
  papayawhip = { r = 255, g = 239, b = 213 },
  peachpuff = { r = 255, g = 218, b = 185 },
  peru = { r = 205, g = 133, b = 63 },
  pink = { r = 255, g = 192, b = 203 },
  plum = { r = 221, g = 160, b = 221 },
  powderblue = { r = 176, g = 224, b = 230 },
  purple = { r = 128, g = 0, b = 128 },
  red = { r = 255, g = 0, b = 0 },
  rosybrown = { r = 188, g = 143, b = 143 },
  royalblue = { r = 65, g = 105, b = 225 },
  saddlebrown = { r = 139, g = 69, b = 19 },
  salmon = { r = 250, g = 128, b = 114 },
  sandybrown = { r = 244, g = 164, b = 96 },
  seagreen = { r = 46, g = 139, b = 87 },
  seashell = { r = 255, g = 245, b = 238 },
  sienna = { r = 160, g = 82, b = 45 },
  silver = { r = 192, g = 192, b = 192 },
  skyblue = { r = 135, g = 206, b = 235 },
  slateblue = { r = 106, g = 90, b = 205 },
  slategray = { r = 112, g = 128, b = 144 },
  snow = { r = 255, g = 250, b = 250 },
  springgreen = { r = 0, g = 255, b = 127 },
  steelblue = { r = 70, g = 130, b = 180 },
  tan = { r = 210, g = 180, b = 140 },
  teal = { r = 0, g = 128, b = 128 },
  thistle = { r = 216, g = 191, b = 216 },
  tomato = { r = 255, g = 99, b = 71 },
  turquoise = { r = 64, g = 224, b = 208 },
  violet = { r = 238, g = 130, b = 238 },
  wheat = { r = 245, g = 222, b = 179 },
  white = { r = 255, g = 255, b = 255 },
  whitesmoke = { r = 245, g = 245, b = 245 },
  yellow = { r = 255, g = 255, b = 0 },
  yellowgreen = { r = 154, g = 205, b = 50 }
}
setmetatable(p.colors, { __index = function(self, key)
  key = key:lower()
  if self.x[key] then return p.new(self.x[key]) else return nil end
end})

function p.new(...)
  --[[
valid inputs:
  (greyhex, [opacity])F, FF OR #F, #FF
  (hexcolor, [opacity])FFF, FFFFFF OR #FFF, #FFFFFF 
  (hexcolorandopac)FFFF, FFFFFFFF OR #FFFF, #FFFFFFFF
  (intR, intG, intB) - red, green, blue
  (intR, intG, intB, intA) - red, green, blue, alpha
  (intR, intG, intB, fltA) - red, green, blue, 0<alpha>1
  ({r=, g=, b=, a=})
  --]]
  local col = arg[1]
  local ct = {_r = 0, _g = 0, _b = 0, _a = 1}
  if type(col)=="string" then
    local x = p.colors[col]
    if x then return x end
    if col:startswith("#") then col = arg[1]:sub(2) end
    repeat
      if           #col==4 then
        ct._r = tonumber("0x" .. col:charat(1):rep(2))
        ct._g = tonumber("0x" .. col:charat(2):rep(2))
        ct._b = tonumber("0x" .. col:charat(3):rep(2))
        ct._a = 1 / 0xF * tonumber("0x" .. col:charat(4))
      break elseif #col==8 then
        ct._r = tonumber("0x" .. col:sub(1, 2))
        ct._g = tonumber("0x" .. col:sub(3, 4))
        ct._b = tonumber("0x" .. col:sub(5, 6))
        ct._a = 1 / 0xFF * tonumber("0x" .. col:sub(7, 8))
      break end

      if     #col==1 then
        col = tonumber("0x" .. col:rep(2))
        ct._r, ct._g, ct._b = col, col, col
      elseif #col==2 then
        col = tonumber("0x" .. col)
        ct._r, ct._g, ct._b = col, col, col
      elseif #col==3 then
        ct._r = tonumber("0x" .. col:charat(1):rep(2))
        ct._g = tonumber("0x" .. col:charat(2):rep(2))
        ct._b = tonumber("0x" .. col:charat(3):rep(2))
      elseif #col==6 then
        ct._r = tonumber("0x" .. col:sub(1, 2))
        ct._g = tonumber("0x" .. col:sub(3, 4))
        ct._b = tonumber("0x" .. col:sub(5, 6))
      else
        error("Invalid format (" .. col .. ")")
      end

      local alpha = arg[2]
      if alpha and type(alpha)=="number" then
        if alpha < 1 then
          ct._a = alpha
        else
          ct._a = 1 / 0xFF * alpha
        end
      end
    until true

  elseif type(col)=="number" then
    if     arg[2] and arg[3] and type(arg[2])=="number" and type(arg[3])=="number" then
      ct._r = col
      ct._g = arg[2]
      ct._b = arg[3]
    else
      ct._r, ct._g, ct._b = col, col, col
      local alpha = arg[2]
      if arg[2] and type(arg[2])=="number" then
        if alpha < 1 then
          ct._a = alpha
        else
          ct._a = 1 / 0xFF * alpha
        end
      end
    end

  elseif type(col)=="table" then
    for k,v in pairs(col) do
      local key = k:charat(1):lower()
      if ct["_" .. key] then ct["_" .. key] = v end
    end
  end
  ct._h, ct._s, ct._v = 0, 0, 0
  setmetatable(ct, ColorObj)
  ct:updatehsv()
  if type(col)=="table" and col.h and col.s and col.v then
    ct._h = col.h
    ct._s = col.s
    ct.v = col.v
  end

  return ct
end

ColorObj = {}
ColorObj.__index = function(self, key)
  if key == "min" then return math.min(self._r, self._g, self._b) end
  if key == "max" then return math.max(self._r, self._g, self._b) end
  local primary, secondary, tertiary
  if key == "a" then return self._a end
  if key == "r" or key == "g" or key == "b" then return self["_" .. key] end
  if key == "h" then
    if self.max==self.min then return 0 end
    local order
    local sum = 0
    if     self._r == self.max then primary = "r"
    elseif self._g == self.max then primary = "g"
    else                           primary = "b"
    end
    if     self._r == self.min then tertiary = "r"
    elseif self._g == self.min then tertiary = "g"
    else                           tertiary = "b"
    end
    if     (primary..tertiary):gsub("[rg]", "") == "" then secondary = "b"
    elseif (primary..tertiary):gsub("[rb]", "") == "" then secondary = "g"
    else                                                   secondary = "r"
    end
    local range = self.max - self.min
    local diff = self[secondary] - self.min
    local pc = (1 / range) * diff
    total = 0
    if primary == "r" then
      total = 0
      if tertiary == "g" then total = total - (60*pc)
      else                    total = total + (60*pc)
      end
    elseif primary == "g" then
      total = 120
      if tertiary == "b" then total = total - (60*pc)
      else                    total = total + (60*pc)
      end
    elseif primary == "b" then
      total = 240
      if tertiary == "r" then total = total - (60*pc)
      else                    total = total + (60*pc)
      end
    end
    return math.abs(math.round(total % 360))
  end
  if key == "s" then
    local sat = 0xFF / (self.max==0 and 1 or self.max) * (self.max - self.min)
    return math.abs(math.ceil(sat-0.5))
  end
  if key == "v" then return self.max end
  return p[key]
end
ColorObj.__newindex = function(self, key, val)
  if key == "min" or key == "max" then error(key .. " property is read only") end
  if key == "a" then self._a = val end
  if key == "r" or key == "g" or key == "b" then
    self["_" .. key] = val
    self:updatehsv()
    return
  end
  if key == "h" then x = self:update(self:hue(val)) return end
  if key == "s" then x = self:update(self:saturation(val)) return end
  if key == "v" then x = self:update(self:brightness(val)) return end
end
ColorObj.__tostring = function(self)
  if self.a ~= 1 then return self:torgba() else return self:tohex8() end
end
ColorObj.__type = "color"

p.torgb = function(self)
  return "rgb(" .. self.r .. ", " .. self.g .. ", " .. self.b .. ")"
end
p.torgba = function(self)
  return "rgba(" .. self.r .. ", " .. self.g .. ", " .. self.b .. ", " .. math.round(self.a, 3) .. ")"
end

p.updatehsv = function(self)
  self._h, self._s, self._v = self.h, self.s, self.v
end

p.tohex4 = function(self)
  local c = { "r", "g", "b" }
  local n = {}
  for i=1, #c do
    local a, b = math.floor(self[c[i]]/17), self[c[i]]%17
mw.log(a)
    n[c[i]] = a + (b>8 and 1 or 0)
  end
  return ("#%X%X%X"):format(n.r, n.g, n.b)
end

p.tohex8 = function(self)
  return ("#%02X%02X%02X"):format(self.r, self.g, self.b)
end
p.tohex = p.tohex8

p.clone = function(self)
  local x = p.new{ r=self.r, g=self.g, b=self.b, a=self.a }
  x._h = self._h
  x._s = self._s
  x._v = self._v
  return x
end

p.textcolor = function(self)
  return (self.r^2 * 0.299 + self.g^2 * 0.587 + self.b^2 * 0.114)^(1/2) < 130 and p.colors.white or p.colors.black
end

p.brightness = function(self, v)
  self = self:clone()
  local prev = self._v
  if self._v == 0 then
    test = self:clone()
    test.r, test.g, test.b = 0xFF, 0, 0
    test.s = self._s
    test.h = self._h
    self = test
  end
  self._v = v
  v = math.min(math.abs(v), 0xFF)
  local m = v / self.max
  self._r = self._r * m
  self._g = self._g * m
  self._b = self._b * m
  return self
end

p.update = function(self, colo)
  self._r, self._g, self._b, self._h, self._s, self._v, self._a = 
  colo._r, colo._g, colo._b, colo._h, colo._s, colo._v, colo._a
end

p.saturation = function(self, s)
  self = self:clone()
  if self._s == 0 and s ~=0 then
    self._r, self._g, self._b = self.max, 0, 0
    self.h = self._h
  end
  self._s = s
  if self.max == 0 then return self end
  if s==0 then self._r, self._g, self._b = self.max, self.max, self.max return self
  elseif self.max==self.min then return self
  end
  s = math.min(math.abs(s), 0xFF)
  s = 0xFF - s
  --ratios
  local rR = 1 - ((self._r-self.min) / (self.max-self.min))
  local gR = 1 - ((self._g-self.min) / (self.max-self.min))
  local bR = 1 - ((self._b-self.min) / (self.max-self.min))
  --increment
  local inc = ((self.max/0xFF)*s)-self.min
  self._r = self._r + (rR * inc)
  self._g = self._g + (gR * inc)
  self.b = self._b + (bR * inc)
  return self
end

p.hue = function(self, h)
  if self.max == 0 then return self end
  self = self:clone()
  self._h = h
  h = math.abs(h) % 360
  local primary = self.max
  local tertiary = self.min
  local intens = h%120
  if intens ~= 0 then
    intens = 60 - math.abs(math.fmod(intens-60, 60))
  end
  local secondary = tertiary + (((primary-tertiary)/60)*intens)
  local max, min, els
  if (h+60) % 360 < 120 then max = "r"
  elseif h < 180 then max = "g" else max = "b"
  end
  if     max == "r" then
    if h > 200 then els = "b" min = "g" else els="g" min = "b" end
  elseif max == "g" then
    if h > 120 then els = "b" min = "r" else els="r" min = "b" end
  else
    if h > 240 then els = "r" min = "g" else els="g" min = "r" end
  end
  self[max] = primary
  self[min] = tertiary
  self[els] = secondary
  return self
end

p.unbrighten = function(self, v)
  v = math.min(1, math.max(0, v))
  return self:brightness(self.v * (1-v))
end

p.brighten = function(self, v)
  v = math.min(1, math.max(0, v))
  return self:brightness(self.v + ((0xFF-self.v) * v))
end

p.desaturate = function(self, s)
  s = math.min(1, math.max(0, s))
  return self:saturation(self.s * (1-s))
end

p.saturate = function(self, s)
  s = math.min(1, math.max(0, s))
  return self:saturation(self.s + ((0xFF-self.s) * (s)))
end

p.shifthue = function(self, h)
  return self:hue(self.h + h)
end

p.overlay = function(self, c)
  self = self:clone()
  self.r = math.round(self.r - ((self.r - c.r) * ((1-(self.a))*c.a)))
  self.g = math.round(self.g - ((self.g - c.g) * ((1-(self.a))*c.a)))
  self.b = math.round(self.b - ((self.b - c.b) * ((1-(self.a))*c.a)))
  self.a = self.a + ((1-self.a)*c.a)
  return self
end

p.merge = function(self, ...)--merge disrespects alpha
  self = self:clone()
  local tot = { r = self.r, g = self.g, b = self.b, a = self.a }
  for i=1, #arg do
    tot.r = tot.r + arg[i].r
    tot.g = tot.g + arg[i].g
    tot.b = tot.b + arg[i].b
    tot.a = math.max(tot.a, arg[i].a)
  end
  self.r = math.round(tot.r / (#arg+1))
  self.g = math.round(tot.g / (#arg+1))
  self.b = math.round(tot.b / (#arg+1))
  self.a = tot.a
  return self
end

p.invert = function(self)
  self = self:clone()
  self.r = 0xFF - self.r
  self.g = 0xFF - self.g
  self.b = 0xFF - self.b
  return self
end

return p
