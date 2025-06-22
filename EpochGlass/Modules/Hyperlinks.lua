local Core, Constants = unpack(select(2, ...))
local Hyperlinks = Core:GetModule("Hyperlinks")

local OpenNews = Constants.ACTIONS.OpenNews

local HYPERLINK_CLICK = Constants.EVENTS.HYPERLINK_CLICK
local HYPERLINK_ENTER = Constants.EVENTS.HYPERLINK_ENTER
local HYPERLINK_LEAVE = Constants.EVENTS.HYPERLINK_LEAVE

local GameTooltip = GameTooltip
local ShowUIPanel = ShowUIPanel
local UIParent = UIParent
local strsplit = strsplit

local linkTypes = {
  item = true,
  enchant = true,
  spell = true,
  quest = true,
  achievement = true,
  currency = true,
}

function Hyperlinks:OnInitialize()
  self.state = {
    showingTooltip = nil
  }
end

function Hyperlinks:OnEnable()
  -- Custom hyperlink for [See what's new]
  _G.hooksecurefunc("SetItemRef", function(link)
    local linkType, addon, param1 = strsplit(":", link)
    if linkType == "garrmission" and addon == "EpochGlass" then
      if param1 == "opennews" then
        Core:Dispatch(OpenNews())
      end
    end
  end)

  Core:Subscribe(HYPERLINK_CLICK, function (payload)
    local link, text, button = unpack(payload)
    -- Use global reference in case some addon has hooked into it for custom
    -- hyperlinks (e.g. Mythic Dungeon Tools, Prat)
    _G.SetItemRef(link, text, button)
  end)

  Core:Subscribe(HYPERLINK_ENTER, function (payload)
    local link = payload[1]
    local t = string.match(link, "^(.-):")

    if linkTypes[t] then
      self.state.showingTooltip = GameTooltip
      ShowUIPanel(GameTooltip)
      GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR")
      GameTooltip:SetHyperlink(link)
      GameTooltip:Show()
    end
  end)

  Core:Subscribe(HYPERLINK_LEAVE, function (link)
    if self.state.showingTooltip then
      self.state.showingTooltip:Hide()
      self.state.showingTooltip = false
    end
  end)
end
