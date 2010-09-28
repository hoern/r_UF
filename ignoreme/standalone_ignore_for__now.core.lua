locked = true;

local in_combat = false
local replace_uf = 0

playerDataFrame = CreateFrame("Frame", "playerDataFrame")
playerDataFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
playerDataFrame:RegisterEvent("UNIT_ENTERED_VEHICLE")
playerDataFrame:RegisterEvent("UNIT_EXITED_VEHICLE")
playerDataFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
playerDataFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
playerDataFrame:SetScript('OnEvent', function(self, event, ...) self[event](self, ...) end)

function rUFSay(str)
	DEFAULT_CHAT_FRAME:AddMessage("|cFF006699rUF|r: " .. str)
end


function playerDataFrame:PLAYER_ENTERING_WORLD()
		playerDataFrame:Init()
		PlaceTF()
		playerDataFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

function playerDataFrame:UNIT_ENTERED_VEHICLE(unit)
	if unit == "player" then
		if in_combat then
			replace_uf = 1
		else
			PlayerFrame_ToVehicleArt(PlayerFrame, UnitVehicleSkin("player"));
			PlacePF()
		end
	end
end

function playerDataFrame:UNIT_EXITED_VEHICLE(unit)
	if unit == "player" then
		if in_combat then
			replace_uf = 2
		else
			PlayerFrame_ToPlayerArt(PlayerFrame);
			PlacePF()
		end
	end
end

function playerDataFrame:PLAYER_REGEN_ENABLED()
	if replace_uf == 1 then
		PlayerFrame_ToVehicleArt(PlayerFrame, UnitVehicleSkin("player"));
		PlacePF()
		replace_uf = 0
	elseif replace_uf == 2 then
		PlayerFrame_ToPlayerArt(PlayerFrame);
		PlacePF()
		replace_uf = 0
	end
	in_combat = false
end

function playerDataFrame:PLAYER_REGEN_DISABLED()
	in_combat = true
end

function playerDataFrame:Init()
	local setbar = [[Interface\Addons\r_UF\p\Armory]]
	PlayerFrameHealthBar:SetStatusBarTexture(setbar)
	PlayerFrameManaBar:SetStatusBarTexture(setbar)
	point, relativeTo, relativePoint, xOfs, yOfs = PlayerFrame:GetPoint()
	PlayerFrame:SetUserPlaced(true)
	PlayerFrame:ClearAllPoints()
	PlayerFrame:SetPoint(point, UIParent, relativePoint, xOfs, yOfs)

	for _, f in pairs{PlayerFrame, TargetFrame} do
		f:SetClampedToScreen(true)
	end
	TargetFrameHealthBar:SetStatusBarTexture(setbar)
	TargetFrameManaBar:SetStatusBarTexture(setbar)
end


function PlaceTF()
	point, relativeTo, relativePoint, xOfs, yOfs = PlayerFrame:GetPoint()
	if relativePoint == "CENTER" or relativePoint == "TOP" or relativePoint == "BOTTOM" then
		TargetFrame:ClearAllPoints()
		TargetFrame:SetPoint(point, UIParent, relativePoint, -xOfs, yOfs)
	elseif relativePoint == "LEFT" then
		TargetFrame:ClearAllPoints()
		TargetFrame:SetPoint(point, UIParent, "RIGHT", -xOfs, yOfs)
	else
		TargetFrame:ClearAllPoints()
		xOfs = 100
		TargetFrame:SetPoint("TOPLEFT", PlayerFrame, "TOPRIGHT", xOfs, 0)
	end
end

function PlacePF()
	PetFrame:ClearAllPoints()
	PetFrame:SetPoint("TOP", PlayerFrame, "BOTTOM", 30, 30)
end

SLASH_RUF1 = "/ruf";
SlashCmdList["RUF"] = function(arg1) SlashHandler(arg1) end

function SlashHandler(msg)
	if msg == "lock" then
		if in_combat == true then
			rUFSay("Can't do this while in combat")
			return
		end
		if locked then
			locked = false
			for _, f in pairs{PlayerFrame, TargetFrame} do
				f:SetMovable(true)
				f:SetUserPlaced(true)
			end
			PlayerFrame:RegisterForDrag("LeftButton")
			PlayerFrame:SetScript("OnDragStart", function(self)
				PlayerFrame:StartMoving()
			end)
			PlayerFrame:SetScript("OnDragStop", function(self)
				PlayerFrame:StopMovingOrSizing()
				PlaceTF()
			end)
		else
			locked = true
			PlayerFrame:SetScript("OnDragStart", nil)
		end
	elseif msg == "repos" then
		playerDataFrame:Init()
	end
end

playerDataFrame:Init()