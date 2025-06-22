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

  function ObjectPoolMixin:Acquire()
    local object
    if #self.inactiveObjects > 0 then
      object = table.remove(self.inactiveObjects)
    else
      object = self.creationFunc()
    end
    table.insert(self.activeObjects, object)
    return object
  end

  function ObjectPoolMixin:Release(object)
    for i, v in ipairs(self.activeObjects) do
      if v == object then
        table.remove(self.activeObjects, i)
        break
      end
    end

    if self.resetterFunc then
      self.resetterFunc(self, object)
    end
    table.insert(self.inactiveObjects, object)
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
