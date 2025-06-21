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
