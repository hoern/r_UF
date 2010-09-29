local addon, ns = ...
local cfg = ns.cfg
local util = CreateFrame("Frame")

local backdrop_tab = {
  bgFile = cfg.backdrop_texture,
  edgeFile = cfg.backdrop_edge_texture,
  tile = false,
  tileSize = 0,
  edgeSize = 3,
  insets = {
    left = 3,
    right = 3,
    top = 3,
    bottom = 3,
  },
}

util.gen_backdrop = function(f)
  f:SetBackdrop(backdrop_tab);
  f:SetBackdropColor(0,0,0,1)
  f:SetBackdropBorderColor(0,0,0,0.9)
end

util.menu = function(self)
  local unit = self.unit:sub(1, -2)
  local cunit = self.unit:gsub("(.)", string.upper, 1)
  if(unit == "party" or unit == "partypet") then
    ToggleDropDownMenu(1, nil, _G["PartyMemberFrame"..self.id.."DropDown"], "cursor", 0, 0)
  elseif(_G[cunit.."FrameDropDown"]) then
    ToggleDropDownMenu(1, nil, _G[cunit.."FrameDropDown"], "cursor", 0, 0)
  end
end

--init func
util.init = function(f)
  f:SetAttribute("initial-height", f.height)
  f:SetAttribute("initial-width", f.width)
  f:SetAttribute("initial-scale", f.scale)
  f:SetPoint("CENTER",UIParent,"CENTER",0,0)
  f.menu = util.menu
  f:RegisterForClicks("AnyUp")
  f:SetAttribute("*type2", "menu")
  f:SetScript("OnEnter", UnitFrame_OnEnter)
  f:SetScript("OnLeave", UnitFrame_OnLeave)
end

--fontstring func
util.gen_fontstring = function(f, name, size, outline)
  local fs = f:CreateFontString(nil, "OVERLAY")
  fs:SetFont(name, size, outline)
  fs:SetShadowColor(0,0,0,1)
  return fs
end

--gen healthbar func
util.gen_hpbar = function(f)
  --statusbar
  local s = CreateFrame("StatusBar", nil, f)
  s:SetHeight(f.height)
  s:SetWidth(f.width)
  s:SetPoint("CENTER",0,0)
  s:SetStatusBarTexture(cfg.statusbar_texture)
  s:GetStatusBarTexture():SetHorizTile(true)
  --helper
  local h = CreateFrame("Frame", nil, s)
  h:SetFrameLevel(0)
  h:SetPoint("TOPLEFT",-5,5)
  h:SetPoint("BOTTOMRIGHT",5,-5)
  util.gen_backdrop(h)
  --bg
  local b = s:CreateTexture(nil, "BACKGROUND")
  b:SetTexture(cfg.statusbar_texture)
  b:SetAllPoints(s)
  f.Health = s
  f.Health.bg = b

  if IsAddOnLoaded("oUF_CombatFeedback") and (f.mystyle == "player" or f.mystyle == "target") then
    local cbft = s:CreateFontString(nil, "OVERLAY")
    cbft:SetPoint("CENTER", f, "CENTER")
    cbft:SetFontObject(SystemFont_Shadow_Huge1)
    f.CombatFeedbackText = cbft
  end
end

--gen hp strings func
util.gen_hpstrings = function(f)
  --health/name text strings
  local name = util.gen_fontstring(f.Health, cfg.font, 13, "THINOUTLINE")
  name:SetPoint("LEFT", f.Health, "LEFT", 2, 0)
  name:SetJustifyH("LEFT")

  local hpval = util.gen_fontstring(f.Health, cfg.font, 13, "THINOUTLINE")
  hpval:SetPoint("RIGHT", f.Health, "RIGHT", -2, 0)
  --this will make the name go "..." when its to long
  name:SetPoint("RIGHT", hpval, "LEFT", -5, 0)

  f:Tag(name, "[name]")
  f:Tag(hpval, "[curhp]/[perhp]%")
end

--gen healthbar func
util.gen_ppbar = function(f)
  --statusbar
  local s = CreateFrame("StatusBar", nil, f)
  s:SetHeight(f.height/3)
  s:SetWidth(f.width)
  s:SetPoint("TOP",f,"BOTTOM",0,-3)
  s:SetStatusBarTexture(cfg.statusbar_texture)
  s:GetStatusBarTexture():SetHorizTile(true)
  --helper
  local h = CreateFrame("Frame", nil, s)
  h:SetFrameLevel(0)
  h:SetPoint("TOPLEFT",-5,5)
  h:SetPoint("BOTTOMRIGHT",5,-5)
  util.gen_backdrop(h)
  --bg
  local b = s:CreateTexture(nil, "BACKGROUND")
  b:SetTexture(cfg.statusbar_texture)
  b:SetAllPoints(s)
  f.Power = s
  f.Power.bg = b
end

util.PostCreateIcon = function(self, button)
  button.cd:SetReverse()
  button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
  button.icon:SetDrawLayer("BACKGROUND")
  --count
  button.count:ClearAllPoints()
  button.count:SetJustifyH("RIGHT")
  button.count:SetPoint("TOPRIGHT", 2, 2)
  button.count:SetTextColor(0.7,0.7,0.7)
  --helper
  local h = CreateFrame("Frame", nil, button)
  h:SetFrameLevel(0)
  h:SetPoint("TOPLEFT",-5,5)
  h:SetPoint("BOTTOMRIGHT",5,-5)
  util.gen_backdrop(h)
end

util.createDebuffs = function(f)
  b = CreateFrame("Frame", nil, f)
  b.size = 20
  if f.mystyle == "target" then
    b.num = 40
  elseif f.mystyle == "player" then
    b.num = 10
  else
    b.num = 5
  end
  b.spacing = 5
  b.onlyShowPlayer = false
  b:SetHeight((b.size+b.spacing)*4)
  b:SetWidth(f.width)
  b:SetPoint("TOPLEFT", f.Power, "BOTTOMLEFT", 0, -5)
  b.initialAnchor = "TOPLEFT"
  b["growth-x"] = "RIGHT"
  b["growth-y"] = "DOWN"
  b.PostCreateIcon = util.PostCreateIcon
  f.Debuffs = b
end

util.DruidManaOnUpdate = function(self)
  if self.mystyle ~= 'player' then return end
  if string.upper(select(2, UnitClass('player'))) ~= "DRUID" then return end
  local _,p = UnitPowerType('player')

  if p ~= "MANA" then
    local min,max = UnitPower('player', SPELL_POWER_MANA), UnitPowerMax('player', SPELL_POWER_MANA)
    self.DruidMana:SetMinMaxValues(0, max)
    self.DruidMana:SetValue(min)
    self.DruidMana:SetAlpha(1)
    local mymana = util.gen_fontstring(self.DruidMana, cfg.font, 11, "THINOUTLINE")
    mymana:SetPoint("CENTER", self.DruidMana, "CENTER", 0, 0)
    local min,max = UnitPower('player', SPELL_POWER_MANA), UnitPowerMax('player', SPELL_POWER_MANA)
    mymana:SetText(format("%s/%s", min, max))
  else
    self.DruidMana:SetAlpha(0)
  end
end

ns.util = util