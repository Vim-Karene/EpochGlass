local _, Constants = unpack(select(2, ...))

-- luacheck: push ignore 113
local WOW_PROJECT_CLASSIC = WOW_PROJECT_CLASSIC
local WOW_PROJECT_ID = WOW_PROJECT_ID
local WOW_PROJECT_WRATH_CLASSIC = WOW_PROJECT_WRATH_CLASSIC
local GetBuildInfo = GetBuildInfo
-- luacheck: pop

-- Constants
Constants.DOCK_HEIGHT = 20
Constants.TEXT_XPADDING = 15

-- Determine environment for compatibility
Constants.ENV = "retail"

if WOW_PROJECT_ID == nil then
  local _, _, _, tocVersion = GetBuildInfo()
  if tocVersion >= 30000 and tocVersion < 40000 then
    Constants.ENV = "wrath"
  end
elseif WOW_PROJECT_WRATH_CLASSIC and WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC then
  Constants.ENV = "wrathclassic"
elseif WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
  Constants.ENV = "classic"
end

-- Colors
local function createColor(r, g, b)
  return {r = r / 255, g = g / 255, b = b / 255}
end

Constants.COLORS = {
  black = createColor(0, 0, 0),
  codGray = createColor(17, 17, 17),
  apache = createColor(223, 186, 105)
}

-- Events
Constants.EVENTS = {
  HYPERLINK_CLICK = "EpochGlass/HYPERLINK_CLICK",
  HYPERLINK_ENTER = "EpochGlass/HYPERLINK_ENTER",
  HYPERLINK_LEAVE = "EpochGlass/HYPERLINK_LEAVE",
  LOCK_MOVER = "EpochGlass/LOCK_MOVER",
  MOUSE_ENTER = "EpochGlass/MOUSE_ENTER",
  MOUSE_LEAVE = "EpochGlass/MOUSE_LEAVE",
  OPEN_NEWS = "EpochGlass/OPEN_NEWS",
  REFRESH_CONFIG = "EpochGlass/REFRESH_CONFIG",
  SAVE_FRAME_POSITION = "EpochGlass/SAVE_FRAME_POSITION",
  UNLOCK_MOVER = "EpochGlass/UNLOCK_MOVER",
  UPDATE_CONFIG = "EpochGlass/UPDATE_CONFIG",
}

Constants.ACTIONS = {
  HyperlinkClick = function (payload)
    return Constants.EVENTS.HYPERLINK_CLICK, payload
  end,
  HyperlinkEnter = function (payload)
    return Constants.EVENTS.HYPERLINK_ENTER, payload
  end,
  HyperlinkLeave = function (link)
    return Constants.EVENTS.HYPERLINK_LEAVE, link
  end,
  LockMover = function ()
    return Constants.EVENTS.LOCK_MOVER
  end,
  MouseEnter = function ()
    return Constants.EVENTS.MOUSE_ENTER
  end,
  MouseLeave = function ()
    return Constants.EVENTS.MOUSE_LEAVE
  end,
  OpenNews = function ()
    return Constants.EVENTS.OPEN_NEWS
  end,
  RefreshConfig = function ()
    return Constants.EVENTS.REFRESH_CONFIG
  end,
  SaveFramePosition = function (payload)
    return Constants.EVENTS.SAVE_FRAME_POSITION, payload
  end,
  UnlockMover = function ()
    return Constants.EVENTS.UNLOCK_MOVER
  end,
  UpdateConfig = function (payload)
    return Constants.EVENTS.UPDATE_CONFIG, payload
  end,
}
