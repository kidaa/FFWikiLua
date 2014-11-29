--VERY EARLY WIP - nothing works nothing is tested
string = require "Module:String"
array = require "Module:Array"

mw.log(string.charat("key", -1))

p = {}

p.create = function()
  return table
end

p.cell = function(key)
  if key:isalphanumeric() and key:charat(1):isnumber() and key:charat(-1):isletter() then
    local ind = 0
    local kca = key:tochartable()
    for i=1, #kca do if kca[i]:isletter() then ind = i break end end
    local num, let = key:sub(1, ind-1), key:sub(ind)
    return { col = let:lettersequencenumber(), row = num }
  end
  if key:charat(1):isnumber() and key:charat(-1):isnumber() then
    local ind, mode = 0
    local kca = key:tochartable()
    for i=1, #kca do
      if     kca[i]=="," then ind = i mode = 0 break
      elseif kca[i]=="." then ind = i mode = 1 break
      end
    end
    local row, col = key:sub(1, ind-1), key:sub(ind+1)
    if mode==0 then row, col = col, row end
    return { col, row }
  end
end

mTable = {}
mTable.__index = function(self, key)
  if mTable.functions[key] then return mTable.functions[key] end
  if self[key] then return self[key] end
  if type(key)=="number" then
    return self:getRow(key)
  end
  if key:isalpha() then
    return self:getRow(key:lettersequencenumber())
  end
  if type(key)=="table" and key.col and key.row then
    return self:getCell(key)
  end
  return self:getCell(p.cell(key))
end

mTable.functions = {}
mTable.functions.getCell = function(self, cell)
  local row, col = cell.row, cell.col
  if self._cells[row][col] then return self.cells[row][col] end
  local prevRow, prevCol
  for i=1, row-1 do
    if self._cells[row-i][col] then
      if self._cells[row-i][col]._rowspan >= row-i then return self._cells[row-i][col] end
      prevRow = row-i
      break
    end
  end
  for i=1, col-1 do
    if self._cells[row][col-i] then
      if self._cells[row][col-i]._colspan >= row-i then return self._cells[row][col-i] end
      prevCol = col-i
      break
    end
  end
  return self._cells[prevRow+1][prevCol+1], p.cell(prevRow+1, prevCol+1)
end

mTable.functions.getRow = function(self, row)
  local carr = {}
  for i=1, #self._cells[row] do
    local r = self._cells[row][i]
    if r ~= carr[#carr] then carr:push(r) end
  end
  return carr
end

mTable.functions.getCol = function(self, col)
  local carr = {}
  for i=1, #self._cells do
    local r = self._cells[i][col]
    if r ~= carr[#carr] then carr:push(r) end
  end
  return carr
end

mTable.functions.rows = function(self, a)
  if not a then self._rows = #self._cells return self._rows end
  if a < self._rows then
    for i=1, self._rows-a do
      self:addRow()
    end
  end
  if a > self._rows then
    for i=1, a-self._rows do
      self:removeRow()
    end
  end
end

mTable.functions.addRow = function(self)
  self._cells[self.rows+1] = {}
  for i=1, #self._cols do
    self._cells[self.rows+1][i] = self:newCell()
  end
  self._rows = self._rows + 1
end

mTable.functions.removeRow = function(self)
  for i=1, #self._cols do
    self:killcell({col = i, row = self._rows})
  end
  self._cells:pop()
  self._rows = self._rows - 1
end

mTable.functions.addRow = function(self)
  self._cells[self.rows+1] = {}
  for i=1, self._cols do
    self._cells[self.rows+1][i] = self:newCell()
  end
  self._rows = self._rows + 1
end

mTable.functions.addCol = function(self)
  for i=1, self._rows do
    self._cells[i][self._cols+1] = self:newCell()
  end
  self._cols = self._cols + 1
end

mTable.functions.removeCol = function(self)
  for i=1, self._cols do
    self:killcell({col = j, row = #self._rows-i})
  end
  self._rows = self._rows - 1
end

mTable.functions.newCell = function(self)
  return { _rowspan = 1, _colspan = 1}
end

mTable.functions.cols = function(self, a)
  if not a then
    local firstRow = #self._cells[1]
    local lastCell = firstRow[#firstRow]
    self._cols = #firstRow + lastCell._colspan
    return self._cols
  end
  if a < self._cols then
    for i=1, self._cols-a do
      self:addCol()
    end
  end
  if a > self._cols then
    for i=1, a-self._cols do
      self:removeCol()
    end
  end
end

mTable.functions.freecell = function(self, coord)
  local cell = self._cells[coord.row][coord.col]
  if cell then return false end
  cell, newcoord = self._table[coord.row .. "." .. coord.col]
  local rowspan, colspan = cell._rowspan, cell._colspan
  local rowdiff, coldiff = coord.row - newcoord.row, coord.col - newcoord.col
  --local rowplus, colplus = rowspan - rowdiff, colspan - coldiff
  cell._rowspan, cell._colspan = rowdiff, celldiff
  return coord
end

mTable.functions.killcell = function(self, coord)
  local fc = self:freecell(coord)
  if fc==false then
    table.remove(self._cells[coord.row][coord.col])
  end
  return coord
end

mCell = {}

mCell.functions = {}

mCell.functions.rowspan = function(self, a)
  if not a then return mCell._rowspan end
  --code
end

mCell.functions.colspan = function(self, a)
  if not a then return mCell._colspan end
  local oldspan = self._colspan
  self._colspan = a
  for i=1, self._rowspan do
    --everything that matters needs to reference the bigger picture
  end
end

return p
