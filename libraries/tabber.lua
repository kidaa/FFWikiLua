htmlelem = getmetatable(mw.html.create("div"))
tabber = mw.clone(getmetatable(mw.html.create("div")))
tabber.__index = function(self, key)
  if tabber[key] ~= nil then return tabber[key]
  elseif htmlelem.__index[key] ~= nil then return htmlelem.__index[key]
  elseif type(key)=="number" then return self.tabs[key]
  else for i = 1, #self.tabs do if self.tabs[i]._title == key then return self.tabs[i] end end
  end
end
tabber.__tostring = function(self)
  local out = mw.html.create("div")
  for k,v in pairs(self) do out[k] = v end
  out:addClass("tabber")
  if self.title then out:attr("title", self.title) end
  for i = 1, #self.tabs do
    out:wikitext(tostring(self[i]))
  end
  return tostring(out)
end
--tabber.__len = function(self) return #self.tabs end

function tabber.create(a, ...)
  local t = mw.html.create("div")
  t.title = a or false
  t.tabs = arg or {}
  setmetatable(t, tabber)
  return t
end

function tabber.isTab(a)
  if getmetatable(a) == TabObj then return true end
  return false
end

function tabber.isTabber(a)
  if getmetatable(a) == tabber then return true end
  return false
end

function tabber.addTab(self, tab)
  table.insert(self.tabs, tab)
  tab._parent = self
  return self
end

function tabber.newTab(self, ...)
  
  local n = tabber.createTab(...)
  table.insert(self.tabs, n)
  n._parent = self
  return n
end

TabObj = {}
TabObj.__index = function(self, key)
  if TabObj[key] ~= nil then return TabObj[key] end
  return htmlelem.__index[key]
end

TabObj.__tostring = function(self)
  local t = mw.html.create("div")
  for k,v in pairs(self) do t[k] = v end
  t:addClass("tabbertab")
  if self._title then t:attr("title", self._title) end
  if self._default then t:addClass("tabbertabdefault") end
  return tostring(t)
end

function TabObj.create(a, ...)
  local tab = mw.html.create("div")
  tab._title = a or false
  tab._parent = nil
  tab._default = false
  for i=1, #arg do
    if type(arg[i]) == "table" then tab:node(arg[i])
    else tab:wikitext(tostring(arg[i])) end
  end
  setmetatable(tab, TabObj)
  return tab
end

tabber.createTab = TabObj.create

function TabObj.default(self, bool)
  self._default = bool or true
  return self
end

function TabObj.done(self)
  return self._parent
end

return tabber
