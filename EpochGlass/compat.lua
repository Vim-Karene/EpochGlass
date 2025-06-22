if not Mixin then
  function Mixin(object, ...)
    for i = 1, select('#', ...) do
      local mixin = select(i, ...)
      if type(mixin) == "table" then
        for k, v in pairs(mixin) do
          object[k] = v
        end
      end
    end
    return object
  end
end

if not string.trim then
  if _G.strtrim then
    string.trim = _G.strtrim
  else
    function string.trim(s)
      return s:match('^%s*(.-)%s*$')
    end
  end
end

if not string.split then
  if _G.strsplit then
    string.split = _G.strsplit
  else
    function string.split(delim, str, num)
      local results = {}
      local pattern = string.format("([^%s]+)", delim)
      for match in string.gmatch(str, pattern) do
        table.insert(results, match)
        if num and #results >= num then break end
      end
      return unpack(results)
    end
  end
end

if not C_Timer then
  C_Timer = {}
end

if not C_Timer.NewTimer then
  local waitFrame = CreateFrame("Frame")
  local waitTable = {}

  waitFrame:SetScript("OnUpdate", function(self, elapsed)
    for i = #waitTable, 1, -1 do
      local timer = waitTable[i]
      timer.delay = timer.delay - elapsed
      if timer.delay <= 0 then
        table.remove(waitTable, i)
        if not timer.cancelled then
          timer.func()
        end
      end
    end
  end)

  function C_Timer.NewTimer(delay, func)
    local timer = {delay = delay, func = func}
    table.insert(waitTable, timer)
    return {
      Cancel = function()
        timer.cancelled = true
      end
    }
  end
end

-- Polyfill for CreateObjectPool (not present in 3.3.5a)
if not CreateObjectPool then
  local ObjectPoolMixin = {}
  ObjectPoolMixin.__index = ObjectPoolMixin

  local function getIndex(tbl, object)
    for i, v in ipairs(tbl) do
      if v == object then
        return i
      end
    end
    return nil
  end

  function ObjectPoolMixin:Acquire()
    local object = table.remove(self.inactiveObjects)
    if not object then
      object = self.creationFunc()
    end
    table.insert(self.activeObjects, object)
    return object
  end

  function ObjectPoolMixin:Release(object)
    local index = getIndex(self.activeObjects, object)
    if index then
      table.remove(self.activeObjects, index)
      if self.resetterFunc then
        self.resetterFunc(self, object)
      end
      table.insert(self.inactiveObjects, object)
    end
  end

  function ObjectPoolMixin:ReleaseAll()
    for i = #self.activeObjects, 1, -1 do
      self:Release(self.activeObjects[i])
    end
  end

  function CreateObjectPool(creationFunc, resetterFunc)
    local pool = {
      creationFunc = creationFunc,
      resetterFunc = resetterFunc,
      activeObjects = {},
      inactiveObjects = {},
    }
    return setmetatable(pool, ObjectPoolMixin)
  end
end
