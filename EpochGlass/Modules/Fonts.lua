local Core, Constants = unpack(select(2, ...))
local Fonts = Core:GetModule("Fonts")

local LSM = Core.Libs.LSM

local UPDATE_CONFIG = Constants.EVENTS.UPDATE_CONFIG

-- luacheck: push ignore 113
local CreateFont = CreateFont
-- luacheck: pop

function Fonts:OnInitialize()
  self.fonts = {}
end

function Fonts:OnEnable()
  -- EpochGlassMessageFont
  self.fonts.EpochGlassMessageFont = CreateFont("EpochGlassMessageFont")
  self.fonts.EpochGlassMessageFont:SetFont(
    LSM:Fetch(LSM.MediaType.FONT, Core.db.profile.font),
    Core.db.profile.messageFontSize,
    Core.db.profile.fontFlags
  )
  self.fonts.EpochGlassMessageFont:SetShadowColor(0, 0, 0, 1)
  self.fonts.EpochGlassMessageFont:SetShadowOffset(1, -1)
  self.fonts.EpochGlassMessageFont:SetJustifyH("LEFT")
  self.fonts.EpochGlassMessageFont:SetJustifyV("MIDDLE")
  self.fonts.EpochGlassMessageFont:SetSpacing(Core.db.profile.messageLeading)

  -- EpochGlassChatDockFont
  self.fonts.EpochGlassChatDockFont = CreateFont("EpochGlassChatDockFont")
  self.fonts.EpochGlassChatDockFont:SetFont(
    LSM:Fetch(LSM.MediaType.FONT, Core.db.profile.font),
    12,
    Core.db.profile.fontFlags
  )
  self.fonts.EpochGlassChatDockFont:SetShadowColor(0, 0, 0, 0)
  self.fonts.EpochGlassChatDockFont:SetShadowOffset(1, -1)
  self.fonts.EpochGlassChatDockFont:SetJustifyH("LEFT")
  self.fonts.EpochGlassChatDockFont:SetJustifyV("MIDDLE")
  self.fonts.EpochGlassChatDockFont:SetSpacing(3)

  -- EpochGlassEditBoxFont
  self.fonts.EpochGlassEditBoxFont = CreateFont("EpochGlassEditBoxFont")
  self.fonts.EpochGlassEditBoxFont:SetFont(
    LSM:Fetch(LSM.MediaType.FONT, Core.db.profile.font),
    Core.db.profile.editBoxFontSize,
    Core.db.profile.fontFlags
  )
  self.fonts.EpochGlassEditBoxFont:SetShadowColor(0, 0, 0, 0)
  self.fonts.EpochGlassEditBoxFont:SetShadowOffset(1, -1)
  self.fonts.EpochGlassEditBoxFont:SetJustifyH("LEFT")
  self.fonts.EpochGlassEditBoxFont:SetJustifyV("MIDDLE")
  self.fonts.EpochGlassEditBoxFont:SetSpacing(3)

  Core:Subscribe(UPDATE_CONFIG, function (key)
    if key == "font" or key == "messageFontSize" then
      self.fonts.EpochGlassMessageFont:SetFont(
        LSM:Fetch(LSM.MediaType.FONT, Core.db.profile.font),
        Core.db.profile.messageFontSize,
        Core.db.profile.fontFlags
      )
    end

    if key == "messageLeading" then
      self.fonts.EpochGlassMessageFont:SetSpacing(Core.db.profile.messageLeading)
    end

    if key == "font" then
      self.fonts.EpochGlassChatDockFont:SetFont(
        LSM:Fetch(LSM.MediaType.FONT, Core.db.profile.font),
        12,
        Core.db.profile.fontFlags
      )
    end

    if key == "font" or key == "editBoxFontSize" then
      self.fonts.EpochGlassEditBoxFont:SetFont(
        LSM:Fetch(LSM.MediaType.FONT, Core.db.profile.font),
        Core.db.profile.editBoxFontSize,
        Core.db.profile.fontFlags
      )
    end
  end)
end
