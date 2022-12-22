
function WM_Debug() 
	print("debug text")
end

--indexes corrispond to map IDs that contain valid flight points for the Flight Masters Whistle
--Doesn't work in 1021 (Broken Shore)
WM_validIDs = { [1014] = true, [1015] = true, [1017] = true, [1018] = true, [1021] = true, [1024] = true, [1033] = true, [1096] = true }

local WhistleLoc = CreateFrame("FRAME", "WhistleLOC", WorldMapPOIFrame)
WhistleLoc:SetSize(64, 64)
WhistleLoc:SetPoint("CENTER", 0, 0)
WhistleLoc:Show()

WM_ClosestNode = nil

local function GetDistance(nX, nY)
	local pX, pY = GetPlayerMapPosition("player")
	local dX, dY
	if pX and pY then
		dX = pX - nX
    	dY = pY - nY
    else 
    	return nil
    end
 
	return math.sqrt( ( dX^2 ) + ( dY^2 ) )
end

local function GetNode()
	local node
	local distance
	local index
	for k = 1, GetNumMapLandmarks() do
		local n = {}
		n.type, n.name, n.description, n.textureIndex, n.x, n.y = GetMapLandmarkInfo(k)
		if n.type == LE_MAP_LANDMARK_TYPE_TAXINODE then --LE_MAP_LANDMARK_TYPE_TAXINODE is a constant defined by Blizzard
			local d = GetDistance(n.x, n.y)
			if distance == nil or d < distance then
				n.index = k
				distance = d
				node = n
			end
		end
	end
	return node
end

function UpdateWhistleMaster()
	if GetCurrentMapContinent() == 8 and WM_validIDs[ select(1, GetCurrentMapAreaID() ) ] and GetMapNameByID(GetCurrentMapAreaID()) == GetZoneText() and not GetNumDungeonMapLevels() then
		WM_ClosestNode = GetNode()
		if WM_ClosestNode and _G[("WorldMapFramePOI" .. WM_ClosestNode.index)] then
			WhistleLoc:SetPoint("CENTER", "WorldMapFramePOI" .. WM_ClosestNode.index, 0, 0)
			WhistleLoc:Show()
			WhistlePing.Ping:Play()
			return true
		else
			return false
		end
	else
		WhistleLoc:Hide()
		WhistlePing.Ping:Stop()
		return false
	end
end

local mapVisible = false

local function EventHandler(self, event, ...)
	if ( (event == "WORLD_MAP_UPDATE") and WorldMapFrame:IsVisible() ) then
		mapVisible = true
		UpdateWhistleMaster()
	end
	if ( (mapVisible) and not WorldMapFrame:IsVisible() ) then
 		mapVisible = false
 	end
 	if (event == "PLAYER_ENTERING_WORLD") then
		WorldMapFrame:Show()
		WorldMapFrame:Hide()
 		UpdateWhistleMaster()
 	end
end

local WhistleMaster = CreateFrame("FRAME", "WhistleMaster", WorldMapPOIFrame)
WhistleMaster:RegisterEvent("WORLD_MAP_UPDATE")
WhistleMaster:RegisterEvent("VARIABLES_LOADED")
WhistleMaster:RegisterEvent("PLAYER_ENTERING_WORLD")
WhistleMaster:SetScript("OnEvent", EventHandler)

local cleared = true
local function OnTooltipCleared(self)
   cleared = true   
end
 
local function OnTooltipSetItem(self)
	if cleared then
		local name, tooltipLink = self:GetItem()
		if tooltipLink then
			local item = tooltipLink:match("Hitem:(%d+)")
			if item == "141605" then
				if UpdateWhistleMaster() then
					self:AddLine("\n预计抵达：|cFFFFFFFF " .. WM_ClosestNode.name ,0.5,1,0.5, true)
				else
					self:AddLine("\n预计抵达：|cFFFFFFFF 未知",0.5,1,0.5, true)
				end
			end
			cleared = true
		end
	end
end
 
GameTooltip:HookScript("OnTooltipCleared", OnTooltipCleared)
GameTooltip:HookScript("OnTooltipSetItem", OnTooltipSetItem)
ItemRefTooltip:HookScript("OnTooltipCleared", OnTooltipCleared)
ItemRefTooltip:HookScript("OnTooltipSetItem", OnTooltipSetItem)

