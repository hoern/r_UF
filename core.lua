local addon, ns = ...
local cfg = ns.cfg
local util = ns.util
local pinfo = {
  class = string.upper(select(2, UnitClass('player'))),
}

local function genStyle(self)
  util.init(self)
  util.gen_hpbar(self)
  util.gen_hpstrings(self)
  util.gen_ppbar(self)
end

--the player style
local function CreatePlayerStyle(self)
  self.width = 250
  self.height = 25
  self.scale = 0.8
  self.mystyle = "player"
  genStyle(self)
  self.Health.frequentUpdates = true
  self.Health.colorHealth = true
  self.Health.bg.multiplier = 0.3
  self.Power.colorPower = true
  self.Power.bg.multiplier = 0.3

  if IsAddOnLoaded("oUF_TotemBar") and pinfo.class == "SHAMAN" then
    mmsize,_ = Minimap:GetSize()
    bsize = mmsize / 4 - 6
    self.TotemBar = {}
    for i = 1, 4 do
      self.TotemBar[i] = CreateFrame("StatusBar", nil, self)
      self.TotemBar[i]:SetHeight(bsize)
      self.TotemBar[i]:SetWidth(bsize)
      if (i == 1) then
        self.TotemBar[i]:SetPoint("LEFT", Minimap, "TOP", -((bsize+3)*2), (bsize/2)+15)
      else
        self.TotemBar[i]:SetPoint("TOPLEFT", self.TotemBar[i-1], "TOPRIGHT", 4, 0)
      end
      self.TotemBar[i]:SetStatusBarTexture(cfg.statusbar_texture)
      self.TotemBar[i]:SetMinMaxValues(0, 1)
      self.TotemBar[i].Destroy = true

      self.TotemBar[i].bg = self.TotemBar[i]:CreateTexture(nil, "BORDER")
      self.TotemBar[i].bg:SetAllPoints(self.TotemBar[i])
      self.TotemBar[i].bg:SetTexture(cfg.statusbar_texture)
      self.TotemBar[i].bg.multiplier = 0.4
    end
  end

  if(pinfo.class == "DRUID") then
    self.DruidMana = CreateFrame('StatusBar', nil, self)
    self.DruidMana:SetWidth(120)
    self.DruidMana:SetHeight(15)
    self.DruidMana:SetBackdrop({
      bgFile = cfg.backdrop_texture,
      edgeFile = cfg.backdrop_edge_texture,
      tile = false,
      tileSize = 0,
      edgeSize = 3,
      insets = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
      }
    })
    self.DruidMana:SetBackdropColor(0,0,0.5,0.6)
    self.DruidMana:SetBackdropBorderColor(0,0,0,0.4)
    self.DruidMana:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT",0,-15)
    self.DruidMana:SetStatusBarTexture(cfg.statusbar_texture)
    self.DruidMana:SetStatusBarColor(0.3, 0.3, 1)
    self.DruidMana:Show()
    self.DruidMana:SetScript("OnUpdate", function() util.DruidManaOnUpdate(self) end)
  end
end

--the target style
local function CreateTargetStyle(self)
  --style specific stuff
  self.width = 250
  self.height = 25
  self.scale = 0.8
  self.mystyle = "target"
  genStyle(self)
  self.Health.frequentUpdates = true
  self.Health.colorTapping = true
  self.Health.colorDisconnected = true
  self.Health.colorHappiness = true
  self.Health.colorClass = true
  self.Health.colorReaction = true
  self.Health.colorHealth = true
  self.Health.bg.multiplier = 0.3
  self.Power.colorPower = true
  self.Power.bg.multiplier = 0.3
  util.createDebuffs(self)
end

--the tot style
local function CreateToTStyle(self)
  --style specific stuff
  self.width = 150
  self.height = 25
  self.scale = 0.8
  self.mystyle = "tot"
  genStyle(self)
  self.Health.frequentUpdates = true
  self.Health.colorTapping = true
  self.Health.colorDisconnected = true
  self.Health.colorHappiness = true
  self.Health.colorClass = true
  self.Health.colorReaction = true
  self.Health.colorHealth = true
  self.Health.bg.multiplier = 0.3
  self.Power.colorPower = true
  self.Power.bg.multiplier = 0.3
  util.createDebuffs(self)
end

--the focus style
local function CreateFocusStyle(self)
  --style specific stuff
  self.width = 180
  self.height = 25
  self.scale = 0.8
  self.mystyle = "focus"
  genStyle(self)
  self.Health.frequentUpdates = true
  self.Health.colorDisconnected = true
  self.Health.colorHappiness = true
  self.Health.colorClass = true
  self.Health.colorReaction = true
  self.Health.colorHealth = true
  self.Health.bg.multiplier = 0.3
  self.Power.colorPower = true
  self.Power.bg.multiplier = 0.3
  util.createDebuffs(self)
end

--the pet style
local function CreatePetStyle(self)
  --style specific stuff
  self.width = 125
  self.height = 15
  self.scale = 0.8
  self.mystyle = "pet"
  genStyle(self)
  self.Health.frequentUpdates = true
  self.Health.colorDisconnected = true
  self.Health.colorHappiness = true
  self.Health.colorClass = true
  self.Health.colorReaction = true
  self.Health.colorHealth = true
  self.Health.bg.multiplier = 0.3
  self.Power.colorPower = true
  self.Power.bg.multiplier = 0.3
  util.createDebuffs(self)
end

--the party style
local function CreatePartyStyle(self)
  --style specific stuff
  self.width = 180
  self.height = 25
  self.scale = 0.8
  self.mystyle = "party"
  genStyle(self)
  self.Health.frequentUpdates = true
  self.Health.colorDisconnected = true
  self.Health.colorHappiness = true
  self.Health.colorClass = true
  self.Health.colorReaction = true
  self.Health.colorHealth = true
  self.Health.bg.multiplier = 0.3
  self.Power.colorPower = true
  self.Power.bg.multiplier = 0.3
  util.createDebuffs(self)
end

--the raid style
local function CreateRaidStyle(self)
  --style specific stuff
  self.width = 130
  self.height = 25
  self.scale = 0.8
  self.mystyle = "raid"
  genStyle(self)
  self.Health.frequentUpdates = true
  self.Health.colorDisconnected = true
  self.Health.colorHappiness = true
  self.Health.colorClass = true
  self.Health.colorReaction = true
  self.Health.colorHealth = true
  self.Health.bg.multiplier = 0.3
  self.Power.colorPower = true
  self.Power.bg.multiplier = 0.3
end

-- Register

oUF:RegisterStyle("oUF_RistrettoPlayer", CreatePlayerStyle)
oUF:SetActiveStyle("oUF_RistrettoPlayer")
oUF:Spawn("player", "RistrettoPlayerFrame"):SetPoint("CENTER", UIParent, "CENTER", cfg.player_loc.x, cfg.player_loc.y)

oUF:RegisterStyle("oUF_RistrettoTarget", CreateTargetStyle)
oUF:SetActiveStyle("oUF_RistrettoTarget")
oUF:Spawn("target", "RistrettoTargetFrame"):SetPoint("CENTER", UIParent, "CENTER", cfg.target_loc.x, cfg.target_loc.y)

oUF:RegisterStyle("oUF_RistrettoToT",    CreateToTStyle)
oUF:SetActiveStyle("oUF_RistrettoToT")
oUF:Spawn("targettarget", "RistrettoToTFrame"):SetPoint("CENTER", UIParent, "CENTER", cfg.tot_loc.x, cfg.tot_loc.y)

oUF:RegisterStyle("oUF_RistrettoFocus",  CreateFocusStyle)
oUF:SetActiveStyle("oUF_RistrettoFocus")
oUF:Spawn("focus", "RistrettoFocusFrame"):SetPoint("BOTTOMLEFT", RistrettoTargetFrame, "TOPRIGHT", 15,15)

oUF:RegisterStyle("oUF_RistrettoPet",  CreatePetStyle)
oUF:SetActiveStyle("oUF_RistrettoPet")
oUF:Spawn("pet", "RistrettoPetFrame"):SetPoint("TOPLEFT", RistrettoPlayerFrame, "BOTTOMLEFT", 0, -21)

oUF:RegisterStyle("oUF_RistrettoParty",  CreatePartyStyle)
oUF:SetActiveStyle("oUF_RistrettoParty")
local party = oUF:SpawnHeader("oUF_Party", nil, "party", "showParty", true, "showPlayer", true, "yOffset", -50)
party:SetPoint("TOPLEFT", 70, -20)

oUF:RegisterStyle("oUF_RistrettoRaid", CreateRaidStyle)
oUF:SetActiveStyle("oUF_RistrettoRaid")
local raid = {}
for i = 1, NUM_RAID_GROUPS do
  raid[i] = oUF:SpawnHeader("oUF_Raid"..i, nil, "raid",  "groupFilter", i, "showRaid", true, "yOffSet", -20)
  if i == 1 then
    raid[i]:SetPoint("TOPLEFT", 10, -20)
  else
    raid[i]:SetPoint("TOPLEFT", raid[i-1], "TOPRIGHT", -15, 0)
  end
end