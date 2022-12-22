local APH,APHdata = ...

local STANDARD_TEXT_FONT = ChatFontNormal:GetFont()
_G.APHdata = APHdata

local APH = LibStub("AceAddon-3.0"):NewAddon("APH", "AceConsole-3.0", "AceEvent-3.0")


local AceGUI = LibStub("AceGUI-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")


local _G = getfenv(0)

local APHMainFrame
local ArtifactPowerFrame
local APHInfoFrame
local APHMover
local ArtPow = {}
local bankArtPow = {}
local TotalArtifactPower = 0
local BankTotalAP = 0
local BagAPItems = {}
local BankAPItems = {}
local inBank = false
local AKlvl
local db
local dbc
local L 
local inBShore = false
local inArgus = false
local APHNews

local _,class= UnitClass("PLAYER")

local PName, PRealm = UnitName("PLAYER")

--if UnitLevel("PLAYER")<100 then exit end

local msq, msqGroups = nil, {}
if LibStub then
	msq = LibStub("Masque",true)
	if msq then
		msqGroups = {
			APHItems = msq:Group("Artifact Power Helper", "Items"),
			APHWeapons = msq:Group("Artifact Power Helper", "Weapons"),
		}
	end
end
local anchorTransfer = {["TOPLEFT"]="BOTTOMRIGHT",["TOPRIGHT"]="BOTTOMLEFT",["LEFT"]="RIGHT",["RIGHT"]="LEFT",["BOTTOMLEFT"]="TOPRIGHT",["BOTTOMRIGHT"]="TOPLEFT"}

local defaults = {
    profile = {
		newVersion = false,
    },
	char = {
		MainPosX = UIParent:GetWidth() - 220 - 100,
		MainPosY = 100 + 200,
		Minimized = false,
		--bgColor = {r=0.0,g=0.0,b=0.0,a=0.5},
		bgColor =  {r=0, g=0, b=0, a=0.5 },
		ArtifactWeapons={},
		autoMinimize = false,
		minimizeAnchor = "TOPRIGHT",
		scale=1,
		AKLevel = 0,
		weapGlow = true,
		WeapGlowAll = false,
		shore = false,
		onlyBShore = false,
		argus = true,
		onlyArgus= true,
		showBank = true,
		useVAThreshold = true,
		VAThreshold = 650,
	}
	
}
for _,i in ipairs(APHdata.ArtifactWeapons[class]) do
	defaults.char.ArtifactWeapons[i] = {nil,nil,nil,nil} --{curAP,curPoints,toNext,extraTraits}
end

local options = {
    name = "Artifact Power Helper",
    handler = APH,
    type = 'group',
    args = {
		General = {
			type = "group",
			name = "General Options",
			guiInline = true,
			order = 100,
			args = {
				backgroundColorPicker = {
					type = 'color',
					name = 'Choose Background Color',
					hasAlpha = true,
					width = 'double',
					order = 3,
					get = function()
						return dbc.bgColor.r, dbc.bgColor.g, dbc.bgColor.b, dbc.bgColor.a
					end,
					set = function(_, r, g, b, a)
						dbc.bgColor.r = r
						dbc.bgColor.g = g
						dbc.bgColor.b = b
						dbc.bgColor.a = a
						APH:SetBackground()
					end,
				},
				autoMinimize = {
					type = 'toggle',
					name = 'Auto Minimize',
					width = 'normal',
					order = 1,
					set = function (info, val) dbc.autoMinimize = val end,
					get = function (info) return dbc.autoMinimize end,
				},
				minimizeAnchor = {
					type = 'select',
					name = 'Select Anchor Point for minimized frame',
					order = 2,
					values = {["TOPLEFT"]="TOPLEFT",["TOPRIGHT"]="TOPRIGHT",["LEFT"]="LEFT",["RIGHT"]="RIGHT",["BOTTOMLEFT"]="BOTTOMLEFT",["BOTTOMRIGHT"]="BOTTOMRIGHT"},
					width = 'normal',
					set = function(info, val) dbc.minimizeAnchor = val; APH:anchorsChange(val) end,
					get = function(info) return dbc.minimizeAnchor end,
				},
				scale = {
					type = 'range',
					name = 'Scale',
					order = 4,
					width = 'double',
					set = function(info, val) dbc.scale = val; APHMainFrame:SetScale(val);APHMinimizedFrame:SetScale(val); end,
					get = function(info) return dbc.scale end,
					min = 0.5,
					max = 2,
					softMin = 0.5,
					softMax = 2,
					step = 0.1,
				},
				bank = {
					type = "toggle",
					name = "Show Bank Items",
					width = "double",
					order = 5,
					set = function (info, val) dbc.showBank = val; APH:bankToggle(val); end,
					get = function (info) return dbc.showBank end,
				},
				weapGlow = {
					type = "toggle",
					name = "Show equipped Artifact icon glow when a point is available?",
					width = "full",
					order = 6,
					set = function (info, val) dbc.weapGlow = val; APH:PreUpdate(1); end,
					get = function (info) return dbc.weapGlow end,
				},
				weapGlowAll = {
					type = "toggle",
					name = "Show all Artifacts icon glow when a point is available?",
					width = "full",
					order = 7,
					disabled = function() return not dbc.weapGlow end,
					set = function (info, val) dbc.weapGlowAll = val; APH:PreUpdate(1); end,
					get = function (info) return dbc.weapGlowAll end,
				},
			},
		},
		BrokenShore = {
			type = "group",
			name = "Broken Shore Options",
			guiInline = true,
			order = 101,
			args = {
				shore = {
					type = 'toggle',
					name = 'Show Broken Shore Currency',
					width = 'double',
					order = 1,
					set = function (info, val) dbc.shore = val; APH:PreUpdate(1); end,
					get = function (info) return dbc.shore end,
				},
				onlyBShore = {
					type = 'toggle',
					name = 'Only Show while on Broken Shore',
					width = 'double',
					disabled = function() return not dbc.shore end,
					order = 2,
					set = function (info, val) dbc.onlyBShore = val; APH:PreUpdate(1); end,
					get = function (info) return dbc.onlyBShore end,
				}
			
			},
		},
		Argus = {
			type = "group",
			name = "Argus Options",
			guiInline = true,
			order = 102,
			args = {
				argus = {
					type = 'toggle',
					name = 'Show Argus Currency',
					width = 'double',
					order = 1,
					set = function (info, val) dbc.argus = val; APH:PreUpdate(1); end,
					get = function (info) return dbc.argus end,
				},
				onlyArgus = {
					type = 'toggle',
					name = 'Only Show while on Argus',
					width = 'full',
					disabled = function() return not dbc.argus end,
					order = 2,
					set = function (info, val) dbc.onlyArgus = val; APH:PreUpdate(1); end,
					get = function (info) return dbc.onlyArgus end,
				},
				useVAThreshold = {
					type = 'toggle',
					name = 'Highlight Veiled Argunite icon?',
					width = 'full',
					order = 3,
					set = function (info, val) dbc.useVAThreshold = val; APH:PreUpdate(1); end,
					get = function (info) return dbc.useVAThreshold end,
				},
				VAThreshold = {
					type = 'range',
					name = 'Select the threshold value for Veiled Argunite warning',
					order = 4,
					width = 'double',
					disabled = function() return not dbc.useVAThreshold end,
					min = 0,
					max = 2000,
					softMin = 0,
					softMax = 2000,
					step = 50,
					set = function(info, val) dbc.VAThreshold = val; APH:PreUpdate(1) end,
					get = function(info) return dbc.VAThreshold end,
				},
			
			}
		}
	},
}


function APH:OnInitialize()
	L = LibStub("AceLocale-3.0"):GetLocale("APH")--, true)
	self.db = LibStub("AceDB-3.0"):New("APHDB", defaults, true)
    LibStub("AceConfig-3.0"):RegisterOptionsTable("ArtifactPowerHelper", options)
	
	--self:UpdateOptions()
	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("ArtifactPowerHelper", "Artifact Power Helper")
	db = self.db.profile
	dbc = self.db.char
	if not db.newVersion or db.newVersion <2 then --[[APHNews:Show();]] db.newVersion=2; end
	APH.PosX = dbc.MainPosX
	APH.PosY = dbc.MainPosY
	APH.Minimized = dbc.Minimized
	APH.MoverAnchor = dbc.minimizeAnchor
	AKlvl = dbc.AKLevel
	APHMainFrame:SetScale(dbc.scale)
	APHMinimizedFrame:SetScale(dbc.scale)
	--APH:Print(APH.PosX, APH.PosY)
	APHMainFrame:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",APH.PosX,APH.PosY)
	APH:anchorsChange(APH.MoverAnchor)
	
	APH:ADDON_LOADED() --APH:RegisterEvent("ADDON_LOADED")
	APH:RegisterEvent("PLAYER_REGEN_DISABLED")
	APH:RegisterEvent("PLAYER_REGEN_ENABLED")
	--APH:RegisterEvent("UNIT_INVENTORY_CHANGED")
	APH:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	--APH:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	--APH:RegisterEvent("UNIT_AURA")
	--APH:RegisterEvent("BAG_UPDATE")
	APH:RegisterEvent("PLAYER_ENTERING_WORLD")
	-- APH:RegisterEvent("PLAYER_LEAVING_WORLD")
	-- APH:RegisterEvent("PLAYER_LOGOUT")
	APH:RegisterEvent("ARTIFACT_XP_UPDATE")
	APH:RegisterEvent("ARTIFACT_UPDATE")
	-- APH:RegisterEvent("WORLD_MAP_UPDATE",APH:WORLD_MAP_UPDATE())
	APH:RegisterEvent("ZONE_CHANGED")
	APH:RegisterEvent("ZONE_CHANGED_INDOORS")
	APH:RegisterEvent("ZONE_CHANGED_NEW_AREA")

	if dbc.showBank then
		APH:RegisterEvent("BANKFRAME_OPENED")
		APH:RegisterEvent("BANKFRAME_CLOSED")
	end
	APH:RegisterChatCommand("aph", "aph")
	-- APH:RegisterChatCommand("aphh","Hide")
	
	
	
end
	--[[##########TIMER FUNCTION##############]]--
	local timerFrame = CreateFrame("Frame")
    APH.timerFrame = timerFrame
	timerFrame:Hide()
	local delay = 0
	timerFrame:SetScript('OnUpdate', function(self, elapsed)
	  delay = delay - elapsed
	  if delay <= 0 then
		APH:PreUpdate()
		self:Hide()
	  end
	end)
	timerFrame:SetScript('OnEvent', function(self)
	  delay = 1--0.5
	  self:Show()
	end)
	timerFrame:RegisterEvent('BAG_UPDATE')	
	


 
function APH:Hide()
	APHMainFrame:Hide()
end


function APH:aph(input)
    if not input or input:trim() == "" then
        InterfaceOptionsFrame_OpenToCategory("Artifact Power Helper")
        InterfaceOptionsFrame_OpenToCategory("Artifact Power Helper")
	elseif input:trim() == "toggle" then
		APH:Minimize()
	elseif input:trim() == "stop" then
		APH:StopMoving()
	elseif input:trim() == "reset" then
		APHMainFrame:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",UIParent:GetWidth()/2,UIParent:GetHeight()/2)
	elseif input:trim() == "changelog" then
		APHNews:Show()
	elseif input:trim() == "help" then
		APH:Print("Artifact Power Helper")
		APH:Print("/aph toggle will toggle between minimized and maximized views")
		APH:Print("/aph reset will reset the window position")
		APH:Print("/aph stop will stop the moving action in case it gets stuck")
		APH:Print("/aph changelog will show changelog window")
	elseif input:trim() == "test" then
		--APH:ResearchNotes()
		APH:Print(APH:ReadAP(147548,1))
		-- local a = GetLocale()
		-- APH:Print(APH:ReadAP(146126,1))
		-- APH:Print(APH:ReadAP(146125,1))
		-- APH:Print(APH:ReadAP(147548,1))
		APH:Test()
    end
	---APH:UpdateWeapons()
end

function APH:Test()
	-- local a=C_ArtifactUI.GetPowers()
	-- APH:Print(a[18])
	-- for i, j in pairs( C_ArtifactUI.GetPowerInfo(a[18]) ) do
	-- APH:Print(i,j)
	-- end
	-- if C_ArtifactUI.GetPowerInfo(a[18]).maxRank > 1 then
	-- APH:Print('Not unlocked')
	-- end
	-- for i, powerID in ipairs(C_ArtifactUI.GetPowers()) do
	-- APH:Print(i, powerID)

	-- local a= C_ArtifactUI.GetPowerInfo(powerID)
	-- for i, j in pairs(a) do
	-- APH:Print(i,j)
	-- end
	-- local spellID, cost, currentRank, maxRank, bonusRanks, x, y, prereqsMet, isStart, isGoldMedal, isFinal = a
	-- APH:Print(spellID, cost, currentRank, maxRank, bonusRanks, x, y, prereqsMet, isStart, isGoldMedal, isFinal)
	-- you can now cache the info you want
	-- end 
end


--/run local a = C_Garrison.GetLooseShipments (LE_GARRISON_TYPE_7_0); for i=1,#a do print(C_Garrison.GetLandingPageShipmentInfoByContainerID (a [i])) end;

-- [18:41:34] Leyblood Recipes	134939 24 24 24 0 			0 	nil 	Leyblood Recipes 134939 1 133916 nil
-- [18:41:34] Frost Crux 		341980 1  0  1  1486406295 	600 6 min 	Frost Crux		 341980 3 139888 nil
function APH:ResearchNotes()
	local gls = C_Garrison.GetLooseShipments (LE_GARRISON_TYPE_7_0)
	if (gls and #gls > 0) then
		for i = 1, #gls do
			local name, texture, _, done, _, creationTime, duration, timeleft = C_Garrison.GetLandingPageShipmentInfoByContainerID (gls[i])
			--APH:Print(C_Garrison.GetLandingPageShipmentInfoByContainerID (gls[i]))
			if texture == 237446 then -- Artifact research found
				return done, timeleft, #gls
			end
			-- if (name and creationTime and creationTime > 0 and texture == 237446) then
				-- local elapsedTime = time() - creationTime
				-- local timeLeft = duration - elapsedTime
				-- APH:Print ("timeleft: ", timeLeft / 60 / 60)
				-- APH:Print (name, texture, shipmentCapacity, shipmentsReady, shipmentsTotal, creationTime, duration, timeleftString)
				-- return name, timeleftString, timeLeft, elapsedTime, done
			-- end
		end
	end
	return false
end

-- local anchorTransfer = {["TOPLEFT"]="BOTTOMRIGHT",["TOPRIGHT"]="BOTTOMLEFT",["LEFT"]="RIGHT",["RIGHT"]="LEFT",["BOTTOMLEFT"]="TOPRIGHT",["BOTTOMRIGHT"]="TOPLEFT"}


function APH:anchorsChange(newAnchor)
	APHMinimizedFrame:ClearAllPoints();
	APHMinimizedFrame:SetPoint(newAnchor, APHMainFrame)
	APHMover:ClearAllPoints();
	-- APHMover:SetPoint(anchorTransfer[newAnchor], APHMainFrame, newAnchor)
	if APH.Minimized then
		APHMover:SetPoint("CENTER", APHMinimizedFrame, anchorTransfer[newAnchor])
	else	
		APHMover:SetPoint("CENTER", APHMainFrame, anchorTransfer[newAnchor])
	end
	APH.MoverAnchor = newAnchor
end

function APH:bankToggle(val)
	if val then
		APH:RegisterEvent("BANKFRAME_OPENED")
		APH:RegisterEvent("BANKFRAME_CLOSED")
	else
		APH:UnregisterEvent("BANKFRAME_CLOSED")
		APH:UnregisterEvent("BANKFRAME_OPENED")
	end

end


function APH:HideTT()
	GameTooltip_Hide()
end
function APH:ShowTT(id)
	GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
	GameTooltip:SetItemByID(id)
	GameTooltip:Show()
end

function APH:TableContains(table, element,index)
local check
local index = index or false
--APH:Print(element)
  for i, value in pairs(table) do
  
	if index then check = value[index] else check = value end
--APH:Print(i,element,check)
    if check == element then
      return i
    end
  end
  return false
end

local function ReadableNumber(num, places)
    if GetLocale():sub(1,2)=="zh" then
        if num <= 9999 then
            return n2s(num, nil, true);
        elseif num <= 999999 then
            return f2s(num/1e4, 1).."万"
        elseif num <= 99999999 then
            return n2s(num/1e4, nil, true).."万"
        else
            return f2s(num/1e8, 2).."亿"
        end
    end
    local ret
    local placeValue = ("%%.%df"):format(places or 0)
    if not num then
        return 0
    elseif num >= 1000000000000 then
        ret = placeValue:format(num / 1000000000000) .. " T" -- trillion
    elseif num >= 1000000000 then
        ret = placeValue:format(num / 1000000000) .. " B" -- billion
    elseif num >= 1000000 then
        ret = placeValue:format(num / 1000000) .. " M" -- million
    elseif num >= 1000 then
        ret = placeValue:format(num / 1000) .. "K" -- thousand
    else
        ret = num -- hundreds
    end
    return ret
end


function APH:FindItemInBags(ItemID)
	local NumSlots
	for Container = 0, NUM_BAG_SLOTS do
		NumSlots = GetContainerNumSlots(Container)
		if NumSlots then
			for Slot = 1, NumSlots do
				if ItemID == GetContainerItemID(Container, Slot) then
					return Container, Slot
				end
			end
		end
	end
	return false
end


function APH:GetInventoryItems(bank)
    local newItemAP
	--local TotalArtifactPower=0
	--local ArtPow = {}
	local totalAP, APTable = 0, {}
	local fstart, fend = 0, 0
	if bank then
		fstart = NUM_BAG_SLOTS+1
		fend = NUM_BAG_SLOTS + NUM_BANKBAGSLOTS+1
	else
		fstart = 0 
		fend = NUM_BAG_SLOTS
	end
	
	for bag = fstart, fend  do
		if bag == fend and bank then bag =-1 end
        for slot = 1, GetContainerNumSlots(bag) do
			local id = GetContainerItemID(bag, slot)
			local ilink = GetContainerItemLink(bag, slot)
			local a = GetItemSpell(id)
			if a==L["Empowering"] or a== "Potencializando" or a=="Fortalecimento" or a=="Potencializador" then
				newItemAP=APH:ReadAP(id, ilink) or 0
				if bank then
					tinsert(APTable, {id,newItemAP,1,bag, slot}) 
				else
					local conf = nil
					for _, one in ipairs(APTable) do
						if one[1] == id and one[2] == newItemAP then
							conf = one
							break
						end
					end
					if conf then
						conf[3] = conf[3] + 1
					else
						tinsert(APTable,{id,newItemAP,1})
					end
				end
				totalAP = totalAP + newItemAP
			end
        end
		if bag==-1 then break end
    end
	sort(APTable,function(a,b) return a[2]>b[2] end)
	
	return APTable, totalAP
end


function APH:GetArtifactButtons(id,APTable)
	if APTable[id] then return APTable[id] end
	--if BagAPItems[id] then return BagAPItems[id] end
	
	local items = CreateFrame("Button","ArtPowerItem"..id,ArtifactPowerFrame,"SecureActionButtonTemplate")
	items:SetPushedTexture([[Interface\Buttons\UI-Quickslot-Depress]])
	items:SetHighlightTexture([[Interface\Buttons\ButtonHilight-Square]],"ADD")
	items:SetHeight(32)
	items:SetWidth(32)
	items.Icon=items:CreateTexture(nil,"BACKGROUND")
	items.Icon:SetAllPoints(items)
	items.Count = items:CreateFontString("Count"..id,"ARTWORK","NumberFontNormal")
	items.Count:SetJustifyH("RIGHT")
	items.Count:SetPoint("BOTTOMRIGHT",-2,2)
	items.AP = items:CreateFontString("AP"..id,"ARTWORK","NumberFontNormal")
	items.AP:SetJustifyH("LEFT")
	items.AP:SetPoint("TOP",0,2)
	items.AP:SetFont(STANDARD_TEXT_FONT, 10,"OUTLINE")
	items:RegisterForClicks("AnyUp")
	items:SetAttribute("type","item")

	if msqGroups["APHItems"] then msqGroups.APHItems:AddButton(items) end

	tinsert(APTable,items)
	return items
end



local Weapons = {}
function APH:CreateWeaponsIcons()
	for ct,weapon in ipairs(APHdata.ArtifactWeapons[class]) do
		local WeaponIcon=CreateFrame("Button","ArtifactWeapon"..ct,ArtifactInfoFrame,"SecureActionButtonTemplate")
            WeaponIcon:SetScript("OnEnter", function() APHMover:Show() end)
            WeaponIcon:SetScript("OnLeave", function() APHMover.anim:Play() end)
			WeaponIcon:SetSize(40,40)
			WeaponIcon:SetPushedTexture([[Interface\Buttons\UI-Quickslot-Depress]])
			WeaponIcon:SetHighlightTexture([[Interface\Buttons\ButtonHilight-Square]],"ADD")
			--WeaponIcon:SetButtonState("PUSHED",true)
			--if C_ArtifactUI.GetEquippedArtifactInfo()==weapon then ActionButton_ShowOverlayGlow(WeaponIcon) end
			--local icon= select(10,GetItemInfo(weapon))
			WeaponIcon.Icon=WeaponIcon:CreateTexture(nil, "BACKGROUND")
			--WeaponIcon.Icon:SetTexture(icon)
			WeaponIcon.Icon:SetAllPoints(WeaponIcon)
			--WeaponIcon:SetPoint("TOPLEFT",ArtifactInfoFrame,"TOPLEFT",60*ct,0)
			WeaponIcon.Percent = WeaponIcon:CreateFontString("Percent","ARTWORK","NumberFontNormal")
			WeaponIcon.Percent:SetFont(STANDARD_TEXT_FONT, 12, "THICKOUTLINE")
			WeaponIcon.Percent:SetJustifyH("CENTER")
			WeaponIcon.Percent:SetJustifyV("MIDDLE")
			WeaponIcon.Percent:SetPoint("CENTER",2,0)
			-- WeaponIcon.Bar = WeaponIcon:CreateTexture(nil,"OVERLAY")
			-- WeaponIcon.Bar:SetAllPoints(WeaponIcon)
			-- WeaponIcon.Bar:SetPoint("BOTTOMRIGHT",WeaponIcon,"BOTTOMLEFT",-5,0)
			-- WeaponIcon.Bar:SetColorTexture(1,0,0,.5)
			WeaponIcon.Id=0
			WeaponIcon.Cont, WeaponIcon.Slot = 0,0

			tinsert(Weapons,WeaponIcon)
			if msqGroups["APHWeapons"] then msqGroups.APHWeapons:AddButton(WeaponIcon) end
	end
	--MinimizedWeapons=Weapons[1]
end



local tip = CreateFrame ("GameTooltip", "APHTooltipReader", nil, "GameTooltipTemplate")
function APH:ReadAP (itemLink, ilink)
	tip:SetOwner (WorldFrame, "ANCHOR_NONE")
	if ilink then
		tip:SetHyperlink(ilink)
	else
		tip:SetItemByID (itemLink)
	end

	for i=tip:NumLines(),1,-1 do
		local txt=_G["APHTooltipReaderTextLeft"..i]:GetText()-- .. "100.000 BATATAS 100 000 00 "
        --使用： 将1.1 亿点神器能量注入到你当前装备的神器之中。
        if txt then
            txt = txt:gsub(",", "")
            local power, unit = txt:match(L["Use Grants ([0-9%.]+)[ ]?(.-) Artifact Power"])
            if power then
                --APH:Print(txt,string.gsub(string.gsub(txt,"%p",""),"%d+([ ])?%d+",""),L["Use Grants (%d+) Artifact Power"])
                return tonumber(power) * (unit and #unit>0 and L["UNIT_"..unit] or 1)
            end
        end
	end
	return 0
end

local function CalcPercent(rank,availableAP, ArtifactCostList)
if not rank or rank == nil then return 0 end
if not availableAP or availableAP == nil then return 0 end
--ArtifactCostList = ArtifactCostList or APHdata.ArtifactCosts
if not rank or not availableAP then return 0 end
    ArtifactCostList = APHdata.ArtifactCosts or ArtifactCostList
	local ret
	local ranksGained = 0
	local maxRank = #ArtifactCostList
	if rank > maxRank then return 0,-1 end
	local cost = ArtifactCostList[rank]
	local InitialRank = rank
	--availableAP = availableAP*1000
	-- APH:Print("cost",cost,"availableAP",availableAP,"rank",rank,"maxRank",maxRank)
	while cost <= availableAP and rank < maxRank do
		rank = rank + 1
		newCost = ArtifactCostList[rank]
		availableAP = availableAP - cost
		cost = newCost
	end
	--if rank == 55 then APH:Print(ArtifactCostList[rank],"Reached MAX") end
	availableAP = math.min(ArtifactCostList[maxRank],availableAP)
	ranksGained = rank - InitialRank
	ret = availableAP/cost

	return math.floor( (ret + ranksGained)*100), cost-availableAP, ret
end

local CostOfNext, CurPow, Equipped, CurRank = 0,0,0,0

function APH:UpdateWeapons()
--APH:Print("updateweapons2")
local ArtifactCostList = APHdata.ArtifactCosts
local unlocked = {}
Equipped = C_ArtifactUI.GetEquippedArtifactInfo() or 0
tinsert(unlocked,Equipped)
for _, i in ipairs(APHdata.ArtifactWeapons[class]) do
	if APH:FindItemInBags(i) then tinsert(unlocked,i) end
end
local nW = #unlocked
_,_,_,_,CurPow, CurRank = C_ArtifactUI.GetEquippedArtifactInfo()
CurPow, CurRank = CurPow or 0, CurRank or 0

if ArtifactFrame and ArtifactFrame:IsShown() then
	local weaponID = C_ArtifactUI.GetArtifactInfo()
	local a=C_ArtifactUI.GetPowers()
	if a[18] and C_ArtifactUI.GetPowerInfo(a[18]).maxRank > 1 then
		extraTraits=0
		ArtifactCostList = APHdata.OldArtifactCosts
	else
		extraTraits=1
		ArtifactCostList = APHdata.ArtifactCosts
	end
	if dbc.ArtifactWeapons[weaponID] then dbc.ArtifactWeapons[weaponID][4]=extraTraits end
end
-------------------------------

--APH:Print(extraTraits)
if Equipped >0 then
	CostOfNext = ArtifactCostList[CurRank]   --C_ArtifactUI.GetCostForPointAtRank(CurRank)
	dbc.ArtifactWeapons[Equipped] = {CurRank,CurPow,CostOfNext,dbc.ArtifactWeapons[Equipped][4] or 0} 
end
local saved = dbc.ArtifactWeapons
if not saved[unlocked[1]] then return end

for i,j in ipairs(unlocked) do
		local weap = Weapons[i]
		local texture = select(10, GetItemInfo(j) )
		weap.Icon:SetTexture(texture)
		--if i== 1 then weap.border:SetVertexColor(0, 1.0, 0, 0.35) end
	if saved[j] and saved[j][1] then
		local CR, CP, CN, ET = saved[j][1],saved[j][2],saved[j][3], saved[j][4]
		local Percent,remain, per  = CalcPercent(CR +1, CP + TotalArtifactPower, ET==1 and APHdata.ArtifactCosts or APHdata.OldArtifactCosts)
		--APH:Print(remain)
		if Percent>=100 then
			--if (i==1 and dbc.weapGlow) or (dbc.weapGlowAll and dbc.weapGlow) then ActionButton_ShowOverlayGlow(weap) else ActionButton_HideOverlayGlow(weap) end
			weap.Percent:SetText("可升\n" .. math.floor(Percent/100) .."级")
		else
			ActionButton_HideOverlayGlow(weap)
			weap.Percent:SetText(Percent.."%")
		end
		if remain < 0 then weap.Percent:SetText("") end
		-- weap.Bar:SetPoint("TOPLEFT",weap,"TOPLEFT",0,-40 + (remain > 0 and 40*per or 0) )
		weap.Id=j
		weap.Cont, weap.Slot = APH:FindItemInBags(j)
		
		weap:SetScript("OnEnter", function() APH:WeaponsTooltipEnter(j, CR, CP, remain) end)
		weap:SetScript("OnLeave", function() APH:WeaponsTooltipLeave() end)
		
		--Pressing active weapon uses AP, pressing other changes spec
        if not InCombatLockdown() then
			weap:SetAttribute("type", "click")
			weap:SetAttribute("*type-ignore", "")
        end

			weap:SetScript("PreClick", function(self, button) APH:ArtifactPreClick(self, button,i) end)
			weap:SetScript("PostClick", function(self, button) APH:ArtifactPostClick(self, button,i) end)
			weap:SetScript("OnMouseUp", function(self, button) APH:ButtonOnMouseUp(self, button,i) end)


		
		
	end
    if not InCombatLockdown() then
		weap:SetPoint("TOPLEFT",ArtifactInfoFrame,"TOPLEFT",APHdata.WC[nW].OffSet+(40+APHdata.WC[nW].Spacing)*(i-1),-30)
    end
end

APHMinimizedFrame.Icon.Texture:SetTexture(select(10,GetItemInfo(unlocked[1])))
		local Percent, remain = CalcPercent(CurRank +1, CurPow + TotalArtifactPower, saved[Equipped][4]==1 and APHdata.ArtifactCosts or APHdata.OldArtifactCosts)
		if Percent>=100 then
			--ActionButton_ShowOverlayGlow(weap)
			APHMinimizedFrame.Icon.Percent:SetText("可升\n" .. math.floor(Percent/100) .. "级")
		else
			--ActionButton_HideOverlayGlow(weap)
			APHMinimizedFrame.Icon.Percent:SetText(Percent.."%")
		end
		if remain < 0 then APHMinimizedFrame.Icon.Percent:SetText("") end

		--APHMinimizedFrame.Icon:SetScript("OnEnter", function() APH:WeaponsTooltipEnter(unlocked[1], CurRank, CurPow, CostOfNext-CurPow) end)
		APHMinimizedFrame.Icon:SetScript("OnEnter", function() APH:WeaponsTooltipEnter(unlocked[1], CurRank, CurPow, remain) end)
		APHMinimizedFrame.Icon:SetScript("OnLeave", function() APH:WeaponsTooltipLeave() end)
		-- if(#ArtPow>0) then
			-- APHMinimizedFrame.Icon:SetAttribute("item","item:"..ArtPow[1][1])
		-- end
        if not InCombatLockdown() then
			APHMinimizedFrame.Icon:SetAttribute("type", "click")
			APHMinimizedFrame.Icon:SetAttribute("*type-ignore", "")
        end

			APHMinimizedFrame.Icon:SetScript("PreClick", function(self, button) APH:ArtifactPreClick(self, button,1) end)
			APHMinimizedFrame.Icon:SetScript("PostClick", function(self, button) APH:ArtifactPostClick(self, button,1) end)
			APHMinimizedFrame.Icon:SetScript("OnMouseUp", function(self, button) APH:ButtonOnMouseUp(self, button,1) end)

end



function APH:Update()
if InCombatLockdown() then return end

	--ArtPow={}
	--ArtPow, TotalArtifactPower=APH:GetInventoryItems()
	for _,t in ipairs(BagAPItems) do t.Icon:SetTexture(0,0,0,1); t:Hide() end
	for _,t in ipairs(BankAPItems) do t.Icon:SetTexture(0,0,0,1); t:Hide() end
	local itemsNum=table.getn(ArtPow)
	--APH:Print(itemsNum)
	--local dimW, dimH = 220, 100
	--APHMainFrame:SetSize(dimW, dimH)
	local j=1
	for i, ids in ipairs(ArtPow) do
	--APH:Print("Update:",ids)
		--local button = APH:CreateArtifactItems(ids.id)
		--local button = BagAPItems[j]
		local button = APH:GetArtifactButtons(j,BagAPItems)
		--APH:Print(button)
		local texture = select(10, GetItemInfo(ids[1]) )
		button.Icon:SetTexture(texture)
		button:SetScript("OnEnter", function() APH:ShowTT(ids[1]) end)
		button:SetScript("OnLeave", function() APH:HideTT() end)
		button:SetAttribute("item","item:"..ids[1])
		local col, row = (j-1) - math.floor((j-1)/6)*6, math.floor((j-1)/6)
		button:SetPoint("TOPLEFT", ArtifactPowerFrame,"TOPLEFT", 4+col*36,-100-row*36)
		
		button.Count:SetText(ids[3])
		button.AP:SetText("|c0000ff00"..ReadableNumber(ids[2],1).."|r")
		
		button:Show()
		j=j+1
	end
	--APH:Print(90+(math.floor(#ArtPow/6)+1)*36,#ArtPow)
	local APItemsHeight = math.floor((#ArtPow+5)/6)*36
	
	local itemsNum=table.getn(bankArtPow)
	--if APHInfoFrame then
		--APHInfoFrame.BankAP:SetPoint("TOPLEFT",0,-110-(APItemsHeight or 20))
	--end
	if inBank then
		local j=1
		for i, ids in ipairs(bankArtPow) do
			local button = APH:GetArtifactButtons(j,BankAPItems)
			local texture = select(10, GetItemInfo(ids[1]) )
			button.Icon:SetTexture(texture)
			button:SetScript("OnEnter", function() APH:ShowTT(ids[1]) end)
			button:SetScript("OnLeave", function() APH:HideTT() end)
			button:SetScript("OnMouseUp", function () UseContainerItem(ids[4],ids[5]); end )
			--button:SetAttribute("item","item:"..ids[1])
			local col, row = (j-1) - math.floor((j-1)/6)*6, math.floor((j-1)/6)
			button:SetPoint("TOPLEFT", ArtifactPowerFrame,"TOPLEFT", 4+col*36,(-100-APItemsHeight-40)-row*36)
			button.Count:SetText(ids[3])
			button.AP:SetText("|c0000ff00"..ReadableNumber(ids[2],1).."|r")
			button:Show()
			j=j+1
		end
	end
	
	if msqGroups["APHItems"] then
		msqGroups.APHItems:ReSkin()
		msqGroups.APHWeapons:ReSkin()
	end
	--APH:Print(i)
	
	
	
	APH:UpdateWeapons()
	APH:WorldQuestsAP()
	APH:UpdateTexts()
	--local mem = GetAddOnMemoryUsage("APH")
	--APH:Print(mem)
end


function APH:PreUpdate(force)
if InCombatLockdown() then return end
--APH:Print(force or "No arguments")
--APH:Print(Equipped)
--APH:Print(#APHdata.ArtifactCosts)
if InCombatLockdown() then return end
if UnitLevel("PLAYER")<98 or Equipped ==0 then 
APHMainFrame:Hide()
APHMinimizedFrame:Hide()
APHMover:Hide()
--return
else
	if APH.Minimized then
		APHMinimizedFrame:Show();
	else
		APHMainFrame:Show()
	end

end
local newAP, newTotal = APH:GetInventoryItems()
local newBankAP, newBankTotal = APH:GetInventoryItems(true)
--APH:Print(newBankAP, newBankTotal)
if dbc.autoMinimize then
	if newTotal == 0 and not APH.Minimized then APH:Minimize() end
	if newTotal > 0 and APH.Minimized then APH:Minimize() end
end
if #newAP ~= #ArtPow or newTotal ~=TotalArtifactPower or force then
	--APH:Print("Values Changed. Updating")
	ArtPow=newAP
	TotalArtifactPower=newTotal
	bankArtPow = newBankAP
	BankTotalAP = newBankTotal
	APH:Update()
else
	--APH:Print("Nothing Changed")
end

	if APH:ResearchNotes() then
		local a = APH:ResearchNotes()
		if a>0 then
			APHInfoFrame.ResearchNotesReady:Show()	
		else
			APHInfoFrame.ResearchNotesReady:Hide()
		end
	end

	if dbc.shore and (inBShore or not dbc.onlyBShore) then
		APHBI:Show()
	else
		APHBI:Hide()
	end
	if dbc.argus and (inArgus or not dbc.onlyArgus) then
		APHArgus:Show()
	else
		APHArgus:Hide()
	end
	
	
	local APItemsHeight = math.floor((#ArtPow+5)/6)*36
	local BankAPHeight = 0

	if inBank then BankAPHeight = 40+math.floor((#bankArtPow+5)/6)*36 end
	if dbc.shore and (inBShore or not dbc.onlyBShore) then
		BrokenIsleFrameHeight = 30 
		APHBI:SetPoint("TOPLEFT",APHMainFrame,"BOTTOMLEFT",0,30)
	else
		BrokenIsleFrameHeight = 0
	end
	
	if dbc.argus and (inArgus or not dbc.onlyArgus) then
		ArgusHeight = 30
		APHArgus:SetPoint("TOPLEFT",APHMainFrame,"BOTTOMLEFT",0,30+BrokenIsleFrameHeight)
	else
		ArgusHeight=0
	end

	APHMainFrame:SetHeight(100+APItemsHeight + BankAPHeight + BrokenIsleFrameHeight + ArgusHeight)


	
end

local WQAP = 0
function APH:WorldQuestsAP()
local numWQ = 0
local newWQAP=0
	for i, j in pairs(APHdata.LegionMaps) do
		--APH:Print("teste",i,j.id,j.name)
		local questList = C_TaskQuest.GetQuestsForPlayerByMapID(j.id, j.parent)
		if questList then
			for ct=1, #questList do
				local timeLeft = C_TaskQuest.GetQuestTimeLeftMinutes(questList[ct].questId)
				if timeLeft>0 then
					_, _, WQType = GetQuestTagInfo(questList[ct].questId)
					if WQType ~= nil then
						numWQ=numWQ+1
						if GetNumQuestLogRewards(questList[ct].questId) > 0 then
							local _, _, _, _, _, itemId = GetQuestLogRewardInfo(1, questList[ct].questId)
								--APH:Print(itemId,GetItemSpell(itemId))
							if GetItemSpell(itemId) == L["Empowering"] then
								--APH:Print("Found APItem",questList[ct].questId,APH:ReadAP(itemId))
								newWQAP = newWQAP + APH:ReadAP(itemId)
							end
						end
					end
				end
			end
		end
	end

if newWQAP > 0 then
	WQAP = newWQAP
	APH:UpdateTexts()
end

end


--WeaponIcon:SetScript("PreClick", APH:ArtifactPreClick)
--WeaponIcon:SetScript("PostClick",APH:ArtifactPostClick)

function APH:ArtifactPreClick(artifact,MouseButton,i)
end

function APH:ArtifactPostClick()
--APH:Print("Post Click")
end
function APH:ButtonOnMouseUp(artifact,MouseButton,i)
	if MouseButton == "LeftButton" then
		if i == 1 then
			if(#ArtPow>0) then
				artifact:SetAttribute("type","item")
				artifact:SetAttribute("item","item:"..ArtPow[1][1])
			end
		else
			local specn=APH:TableContains(APHdata.ArtifactWeapons[class], artifact.Id)
			SetSpecialization(specn)
		end

	else
		if i==1 then
			SocketInventoryItem(16)
		else
			SocketContainerItem(artifact.Cont, artifact.Slot)
		end
	end

end

function APH:Minimize()
	if APH.Minimized then
		APHMinimizedFrame:Hide();
		--APHMinimizedFrame.Maxi:Hide()
		APHMover.Maxi:Hide();
		APHMover.Mini:Show()
		APHMainFrame:Show();
		APHMover:ClearAllPoints();
		APHMover:SetPoint("CENTER", APHMainFrame, anchorTransfer[APH.MoverAnchor])
		APH.Minimized = not APH.Minimized
	else
		APHMainFrame:Hide();
		APHMover.Mini:Hide();
		--APHMover.Maxi:Show()
		APHMinimizedFrame:Show();
		APHMover:ClearAllPoints();
		APHMover:SetPoint("CENTER", APHMinimizedFrame, anchorTransfer[APH.MoverAnchor])
		APH.Minimized = not APH.Minimized
	end
	APHMover:Hide()
	dbc.Minimized = APH.Minimized
end

function APH:WeaponsTooltipEnter(id,rank, ap, left)
	rank = rank or 0
	ap = ap or 0
	left = left or 0
	GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
--	GameTooltip_SetDefaultAnchor(APHMainFrame, APHMainFrame)
	GameTooltip:SetOwner(APHMainFrame,"ANCHOR_CURSOR")
	local name = GetItemInfo(id)
    if not name then return end
	GameTooltip:ClearLines()
	GameTooltip:AddLine(name .. " - Aph", 1, 0.9, 0.8,false)
	GameTooltip:AddDoubleLine("等级:", rank)
	GameTooltip:AddDoubleLine("当前能量:",BreakUpLargeNumbers(ap))
	GameTooltip:AddDoubleLine("升级还需:",BreakUpLargeNumbers(left))
    if APHMinimizedFrame:IsVisible() then
        if TotalArtifactPower and TotalArtifactPower > 0 then
            GameTooltip:AddDoubleLine("背包:",BreakUpLargeNumbers(TotalArtifactPower))
        end
        GameTooltip:AddLine("\n")
        GameTooltip:AddDoubleLine("左键点击:", "吃能量")
        GameTooltip:AddDoubleLine("左键拖动:", "移动位置")
        GameTooltip:AddDoubleLine("右键点击:", "显示详细窗口")
    end
	GameTooltip:Show()
end

function APH:WeaponsTooltipLeave(id)
	GameTooltip_Hide()
end

function APH:ResearchNotesEnter()
		GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
		GameTooltip:SetOwner(APHMainFrame,"ANCHOR_CURSOR")
		GameTooltip:ClearLines()
	if APH:ResearchNotes() then
		--APH:PreUpdate(true)
		local num, rem, total = APH:ResearchNotes()
		-- GameTooltipHeaderText:SetFont('Fonts\\FRIZQT__.TTF', 20)
		GameTooltip:AddLine("神器调查笔记",1,1,1)
		-- GameTooltipHeaderText:SetFont('Fonts\\FRIZQT__.TTF', 12)

		if num > 0 then GameTooltip:AddLine(format("已完成：%d/%d", num, total)) end
		if rem then GameTooltip:AddLine("下一个："..rem or "") end
		GameTooltip:AddTexture([[Interface\Icons\INV_Scroll_11]])
		-- GameTooltip:AddTexture(237446)
		GameTooltip:Show()
	end
end

function APH:ResearchNotesLeave()
	GameTooltip_Hide()
end

function APH:UseAP()

end


function APH:PLAYER_EQUIPMENT_CHANGED(slot,hasItem)
--APH:Print("PLAYER_EQUIPMENT_CHANGED",slot,hasItem)
if slot == 16 or 17 then
--APH:Print("Weapons Changed")
APH:UpdateWeapons()
APH:Update()

end
end


function APH:PLAYER_REGEN_DISABLED()
	timerFrame:UnregisterEvent("BAG_UPDATE")
	APHMainFrame:Hide()
	APHMinimizedFrame:Hide();
end

function APH:PLAYER_REGEN_ENABLED()
	timerFrame:RegisterEvent("BAG_UPDATE")
	if APH.Minimized then
		APHMinimizedFrame:Show();
	else
		APHMainFrame:Show()
	end
	APH:PreUpdate()
end

function APH:BAG_UPDATE()
--APH:Print("BAG_UPDATE")
	APH:PreUpdate()
end

function APH:PLAYER_ENTERING_WORLD()
--APH:Print("PLAYER_ENTERING_WORLD")
if InCombatLockdown() then return end
	
	a,b=GetAreaMapInfo(GetCurrentMapAreaID())
	
	if b==7543 then inBShore=true else inBShore=false end
	if a==1669 then inArgus=true else inArgus=false end

	APH:PreUpdate(true)
	APH.Minimized = not APH.Minimized
	APH:Minimize()
	APH:RegisterEvent("WORLD_MAP_UPDATE",APH.WORLD_MAP_UPDATE)
--	APH:Print(GetAreaMapInfo(GetCurrentMapAreaID()))
end

local function checkarea()
if InCombatLockdown() then return end
	a,b=GetAreaMapInfo(GetCurrentMapAreaID())
	--APH:Print(j,a)
	if b==7543 then inBShore=true else inBShore=false end
	if a==1669 then inArgus=true else inArgus=false end
	APH:PreUpdate()
end

function APH:ZONE_CHANGED()
	checkarea()
end
function APH:ZONE_CHANGED_INDOORS()
	checkarea()
end
function APH:ZONE_CHANGED_NEW_AREA()
	checkarea()
end

function APH:WORLD_MAP_UPDATE()
		APH:WorldQuestsAP()
	if not WorldMapFrame:IsVisible() then
		checkarea()
	end

end

-- function APH:PLAYER_LEAVING_WORLD()
-- timerFrame:UnregisterEvent("BAG_UPDATE")

-- end

-- function APH:PLAYER_LOGOUT()
-- timerFrame:UnregisterEvent("BAG_UPDATE")

-- end

function APH:ADDON_LOADED()
	APH:SetBackground()
end

function APH:PLAYER_LOGIN()
	--if UnitLevel("PLAYER")<100 then APH:Disable() end
end

function APH:ARTIFACT_XP_UPDATE()
--APH:Print("ARTIFACT_XP_UPDATE")
	APH:PreUpdate(1)
end

function APH:ARTIFACT_UPDATE()
	AKlvl=C_ArtifactUI.GetArtifactKnowledgeLevel()
	if AKlvl and AKlvl > dbc.AKLevel then dbc.AKLevel = AKlvl end
	APH:PreUpdate(true)
end

function APH:BANKFRAME_OPENED()

	if dbc.showBank then
		inBank = true
		APHMainFrame:SetFrameStrata("DIALOG")
		APHMinimizedFrame:SetFrameStrata("DIALOG")
		
		APH:PreUpdate(true)
	end
end

function APH:BANKFRAME_CLOSED()
-- inBank=false
	--if inBank then
		--APH:Print("Bank frame closed")
		inBank = false
		APHMainFrame:SetFrameStrata("BACKGROUND")
		APHMinimizedFrame:SetFrameStrata("BACKGROUND")
		APH:PreUpdate(true)
	--end
end



function APH:StopMoving()
	APHMainFrame:StopMovingOrSizing()
	dbc.MainPosX = APHMainFrame:GetLeft()
	dbc.MainPosY = APHMainFrame:GetBottom() + APHMainFrame:GetHeight()
end

function APH:SetBackground()
--db.bgColor.r, db.bgColor.g, db.bgColor.b, db.bgColor.a
APHMainFrame.texture:SetColorTexture(dbc.bgColor.r, dbc.bgColor.g, dbc.bgColor.b, dbc.bgColor.a)
APHMinimizedFrame.texture:SetColorTexture(dbc.bgColor.r, dbc.bgColor.g, dbc.bgColor.b, dbc.bgColor.a)
end


	
	
	
	
APHMainFrame = CreateFrame("Frame", "APHMainFrame", UIParent) ArtifactPowerFrame = APHMainFrame
    APHMainFrame:SetSize(220, 20)
	--APHMainFrame:SetScale(2)
	APHMainFrame:SetFrameStrata("BACKGROUND")
	APHMainFrame.texture = APHMainFrame:CreateTexture(nil, "BACKGROUND")
	--APHMainFrame.texture:SetColorTexture(0,0,0,.5)
	APHMainFrame.texture:SetAllPoints()
    --APHMainFrame:SetPoint("TOPLEFT", APHMover,"TOPRIGHT")--,"BOTTOMLEFT", APH.PosX,APH.PosY)
    APHMainFrame:SetMovable(true)
    APHMainFrame:SetClampedToScreen(true)
	APHMainFrame:SetDontSavePosition(true)
	APHMainFrame:EnableMouse(true)
	APHMainFrame:RegisterForDrag("LeftButton")
	APHMainFrame:SetScript("OnDragStart", APHMainFrame.StartMoving)
	APHMainFrame:SetScript("OnDragStop", function () APH:StopMoving() end)
	APHMainFrame:SetScript("OnEnter", function() APHMover:Show() end)
	APHMainFrame:SetScript("OnLeave", function() APHMover.anim:Play() end)
	--APHMainFrame:SetHitRectInsets(-20, -20, -20, -20)
	APHMainFrame:SetFrameStrata("BACKGROUND")
    --APHMainFrame:SetScript("OnMouseUp", function(self, button) if button == "RightButton" then UUI.OpenToAddon("aph", true) end end)


	
	
	
APHInfoFrame = CreateFrame("Frame", "ArtifactInfoFrame", ArtifactPowerFrame)
		APHInfoFrame:SetSize(220,40)
		APHInfoFrame:SetPoint("TOPLEFT", ArtifactPowerFrame, 0, -5)
		APHInfoFrame.ItemsAP= APHInfoFrame:CreateFontString("TotalItemsAP","ARTWORK","NumberFontNormal")
		APHInfoFrame.ItemsAP:SetFont(STANDARD_TEXT_FONT, 10)
		APHInfoFrame.ItemsAP:SetJustifyH("CENTER")
		APHInfoFrame.ItemsAP:SetPoint("TOPLEFT")
		APHInfoFrame.ItemsAP:SetWidth(110)
		APHInfoFrame.WorldQuestsAP= APHInfoFrame:CreateFontString("WorldQuestsAP","ARTWORK","NumberFontNormal")
		APHInfoFrame.WorldQuestsAP:SetFont(STANDARD_TEXT_FONT, 10)
		APHInfoFrame.WorldQuestsAP:SetJustifyH("CENTER")
		APHInfoFrame.WorldQuestsAP:SetPoint("TOPLEFT",110,0)
		APHInfoFrame.WorldQuestsAP:SetWidth(110)
		APHInfoFrame.ArtK= APHInfoFrame:CreateFontString("ArtK","ARTWORK","NumberFontNormal")
		APHInfoFrame.ArtK:SetFont(STANDARD_TEXT_FONT, 10)
		APHInfoFrame.ArtK:SetJustifyH("CENTER")
		APHInfoFrame.ArtK:SetJustifyV("MIDDLE")
		APHInfoFrame.ArtK:SetPoint("TOP",0,-75)
		APHInfoFrame.ArtK:SetSize(100,20)

		APHInfoFrame.ResearchNotes = CreateFrame("Frame","ResearchNote",APHInfoFrame)--,"SecureActionButtonTemplate")
		APHInfoFrame.ResearchNotes:SetSize(50,20)
		APHInfoFrame.ResearchNotes:SetPoint("CENTER",APHInfoFrame.ArtK,"CENTER")
		APHInfoFrame.ResearchNotes:SetScript("OnEnter", function() APH:ResearchNotesEnter() end)
		APHInfoFrame.ResearchNotes:SetScript("OnLeave", function() APH:ResearchNotesLeave() end)
		APHInfoFrame.ResearchNotesReady = CreateFrame("Button","ResearchNoteReady",APHInfoFrame,"SecureActionButtonTemplate")
		APHInfoFrame.ResearchNotesReady:SetSize(20,20)
		APHInfoFrame.ResearchNotesReady:SetPoint("CENTER",APHInfoFrame,"CENTER",-25,-62)
		APHInfoFrame.ResearchNotesReady.Texture = APHInfoFrame.ResearchNotesReady:CreateTexture(nil,"BACKGROUND")
		APHInfoFrame.ResearchNotesReady.Texture:SetAllPoints()
		APHInfoFrame.ResearchNotesReady.Texture:SetTexture(237446)
		APHInfoFrame.ResearchNotesReady:SetHighlightTexture([[Interface\Buttons\ButtonHilight-Square]],"ADD")
		ActionButton_ShowOverlayGlow(APHInfoFrame.ResearchNotesReady)
		APHInfoFrame.ResearchNotesReady:Hide()

		if msqGroups["APHItems"] then msqGroups.APHItems:AddButton(APHInfoFrame.ResearchNotesReady) end
		
		
		
		APHInfoFrame.BankAP = APHInfoFrame:CreateFontString("BankAP","ARTWORK","NumberFontNormal")
		APHInfoFrame.BankAP:SetFont(STANDARD_TEXT_FONT, 10)
		APHInfoFrame.BankAP:SetJustifyH("CENTER")
		APHInfoFrame.BankAP:SetPoint("TOPLEFT",0,-110-(APItemsHeight or 20))
		APHInfoFrame.BankAP:SetWidth(220)
		APHInfoFrame.BankAP:Hide()

function APH:UpdateTexts()
	--APHInfoFrame.CurAp:SetText("Current\n"..BreakUpLargeNumbers(CurPow))
	APHInfoFrame.ItemsAP:SetText("背包\n"..BreakUpLargeNumbers(TotalArtifactPower)) --.. "/" .. BreakUpLargeNumbers( (CostOfNext or 0) - (CurPow or 0) ) )
	APHInfoFrame.WorldQuestsAP:SetText("世界任务\n"..BreakUpLargeNumbers(WQAP))
	--APHInfoFrame.RemainingAP:SetText("Remaining\n"..BreakUpLargeNumbers(CostOfNext - CurPow))
	APHInfoFrame.ArtK:SetText("知识等级 "..AKlvl or "未知")
	--APH:Print("inbank:",inBank)
	if inBank then
		APHInfoFrame.BankAP:Show()
		APHInfoFrame.BankAP:SetText("银行\n"..BreakUpLargeNumbers(BankTotalAP))
		APHInfoFrame.BankAP:SetPoint("TOPLEFT",0,-100-(math.floor((#ArtPow+5)/6)*36 or 20))
	else
		APHInfoFrame.BankAP:Hide()
	end

	_,val=GetCurrencyInfo(1342)
	APHBIWarSupplies.Value:SetText(val or 0)
	_,val=GetCurrencyInfo(1226)
	APHBINether.Value:SetText(val or 0)
	_,val=GetCurrencyInfo(1508)
	APHArgusVA.Value:SetText(val or 0)
	if (val or 0) >= dbc.VAThreshold and dbc.useVAThreshold and dbc.VAThreshold > 0 then
		ActionButton_ShowOverlayGlow(APHArgusVA.Icon)
	else
		ActionButton_HideOverlayGlow(APHArgusVA.Icon)
	end

end	
	
local APHItemFrame = CreateFrame("Frame", "ArtifactItemFrame", ArtifactPowerFrame)
	APHItemFrame:SetPoint("BOTTOMLEFT", ArtifactInfoFrame,"BOTTOMLEFT",0,0)
	--APH:CreateArtifactItems()
	APH:CreateWeaponsIcons()

local APHMinimizedFrame = CreateFrame("Frame","APHMinimizedFrame", UIParent)
	APHMinimizedFrame:SetSize(45,45)
	APHMinimizedFrame:SetFrameStrata("BACKGROUND")
	APHMinimizedFrame.texture = APHMinimizedFrame:CreateTexture(nil, "BACKGROUND")
	APHMinimizedFrame.texture:SetColorTexture(0,0,0,1)
	APHMinimizedFrame.texture:SetAllPoints()
	APHMinimizedFrame.texture:SetAlpha(0)
	APHMinimizedFrame:SetClampedToScreen(true)
	APHMinimizedFrame:EnableMouse(true)
	APHMinimizedFrame:RegisterForDrag("LeftButton")
	APHMinimizedFrame:SetScript("OnDragStart", function() APHMainFrame:StartMoving() end)
	APHMinimizedFrame:SetScript("OnDragStop",  function () APH:StopMoving() end)


	APHMinimizedFrame.Icon = CreateFrame("Button","MinimizedWeapon",APHMinimizedFrame,"SecureActionButtonTemplate")
	APHMinimizedFrame.Icon:SetSize(36,36)
	APHMinimizedFrame.Icon.Texture=APHMinimizedFrame.Icon:CreateTexture(nil,"BACKGROUND")
	APHMinimizedFrame.Icon.Texture:SetAllPoints()
	APHMinimizedFrame.Icon:SetPoint("CENTER",APHMinimizedFrame)
	APHMinimizedFrame.Icon:SetPushedTexture([[Interface\Buttons\UI-Quickslot-Depress]])
	APHMinimizedFrame.Icon:SetHighlightTexture([[Interface\Buttons\ButtonHilight-Square]],"ADD")
	APHMinimizedFrame.Icon.Percent = APHMinimizedFrame.Icon:CreateFontString("Percent","ARTWORK","NumberFontNormal")
	APHMinimizedFrame.Icon.Percent:SetFont(STANDARD_TEXT_FONT, 10, "THICKOUTLINE")
	APHMinimizedFrame.Icon.Percent:SetJustifyH("CENTER")
	APHMinimizedFrame.Icon.Percent:SetJustifyV("MIDDLE")
	APHMinimizedFrame.Icon.Percent:SetPoint("CENTER",2,0)
	APHMinimizedFrame.Icon:SetScript("OnEnter", function() --[[APHMinimizedFrame.Maxi:Show()]] end)
	APHMinimizedFrame.Icon:SetScript("OnLeave", function() APHMinimizedFrame.Maxi:Hide() end)
	APHMinimizedFrame.Icon:RegisterForClicks("AnyUp")
	APHMinimizedFrame.Icon:SetAttribute("type1","item")
    WW(APHMinimizedFrame.Icon):RegisterForDrag("LeftButton")
    :SetScript("OnDragStart", function() APHMainFrame:StartMoving() end)
    :SetScript("OnDragStop", function () APH:StopMoving() end)
    :HookScript("OnClick", function(self, button) if button == "RightButton" then APH:Minimize() end end)
    :un()


	if msqGroups["APHWeapons"] then msqGroups.APHWeapons:AddButton(APHMinimizedFrame.Icon) end


	APHMinimizedFrame:SetScript("OnEnter", function() APHMover:Show() end)
	APHMinimizedFrame:SetScript("OnLeave", function() APHMover.anim:Play() end)
	APHMinimizedFrame:SetHitRectInsets(-10, -10, -10, -10)
	APHMinimizedFrame:SetFrameStrata("BACKGROUND")

	APHMinimizedFrame:Hide()


APHMover = CreateFrame("Frame","APHMover",UIParent)

    APHMover.anim = APHMover:CreateAnimationGroup()
    local alpha = APHMover.anim:CreateAnimation("Alpha")
    alpha:SetFromAlpha(1)
    alpha:SetToAlpha(0)
    alpha:SetDuration(0.4)
    APHMover.anim:SetScript("OnFinished", function(self) if InCombatLockdown() then return end self:GetParent():Hide() end)
    hooksecurefunc(APHMover, "Show", function(self) self.anim:Stop() end)

	APHMover:SetSize(24,24)
    APHMover:SetPoint("TOPRIGHT", APHMainFrame,"TOPLEFT")--,"BOTTOMLEFT", APH.PosX,APH.PosY)
	APHMover.Texture = APHMover:CreateTexture(nil,"BACKGROUND")
	--APHMover.Texture:SetColorTexture(0.3,0.3,0.3,0.9)
	APHMover.Texture:SetAllPoints()
	APHMover:SetFrameLevel(20)
	APHMover:EnableMouse(true)
	APHMover:SetScript("OnEnter", function() APHMover:Show() end)
	APHMover:SetScript("OnLeave", function() APHMover.anim:Play() end)
	APHMover:SetHitRectInsets(0, -10, 0, -10)
	APHMover:Hide()

	APHMover.Mini = CreateFrame("Button","Minimize",APHMover,"SecureActionButtonTemplate")
	APHMover.Mini:SetSize(32,32)
	APHMover.Mini.Texture=APHMover.Mini:CreateTexture(nil,"BACKGROUND")
	APHMover.Mini.Texture:SetAllPoints()
    APHMover.Mini:SetPoint("TOPRIGHT",APHMainFrame,5,5) --APHMover.Mini:SetPoint("CENTER",APHMover)
	APHMover.Mini:SetNormalTexture([[Interface\Buttons\UI-Panel-SmallerButton-Up]])
	APHMover.Mini:SetPushedTexture([[Interface\Buttons\UI-Panel-SmallerButton-Down]])
	APHMover.Mini:SetHighlightTexture([[Interface\Buttons\UI-Panel-MinimizeButton-Highlight]],"ADD")
	--APHMover.Mini:Hide()
	APHMover.Mini:SetScript("OnEnter", function() APHMover:Show() end)
	APHMover.Mini:SetScript("OnMouseUp", function() APH:Minimize() end)

	APHMover.Maxi = CreateFrame("Button","APHMaximize",APHMover,"SecureActionButtonTemplate")
	APHMover.Maxi:SetSize(32,32)
	APHMover.Maxi.Texture=APHMover.Maxi:CreateTexture(nil,"BACKGROUND")
	APHMover.Maxi.Texture:SetAllPoints()
	APHMover.Maxi:SetPoint("CENTER",APHMover)
	APHMover.Maxi:SetNormalTexture([[Interface\Buttons\UI-Panel-BiggerButton-Up]])
	APHMover.Maxi:SetPushedTexture([[Interface\Buttons\UI-Panel-BiggerButton-Down]])
	APHMover.Maxi:SetHighlightTexture([[Interface\Buttons\UI-Panel-MinimizeButton-Highlight]],"ADD")
	APHMover.Maxi:SetScript("OnEnter", function() APHMover:Show() end)
	APHMover.Maxi:SetScript("OnMouseUp", function() APH:Minimize() end)
	APHMover.Maxi:Hide()

APHBI = CreateFrame("Frame", "APHBI",APHMainFrame)
	APHBI:SetSize(220,30)
	--APHBI:SetPoint("TOPLEFT",APHItemFrame,"BOTTOMLEFT")
	APHBI.Texture = APHBI:CreateTexture(nil,"BACKGROUND")
	-- APHBI.Texture:SetColorTexture(0.3,0.3,0.3,0.9)
	APHBI.Texture:SetAllPoints()
	
APHBIWarSupplies = CreateFrame("Frame", "APHBIWarSupplies", APHBI)
	APHBIWarSupplies:SetSize(110,30)
	APHBIWarSupplies:SetPoint("TOPLEFT",APHBI)
	APHBIWarSupplies.Texture = APHBIWarSupplies:CreateTexture(nil,"BACKGROUND")
	-- APHBIWarSupplies.Texture:SetColorTexture(1,1,0,0.9)
	APHBIWarSupplies.Texture:SetAllPoints()
	APHBIWarSupplies.Value = APHBIWarSupplies:CreateFontString("APHBIWarSuppliesText","ARTWORK","NumberFontNormal")
	APHBIWarSupplies.Value:SetFont("Fonts\\FRIZQT__.TTF", 10)
	APHBIWarSupplies.Value:SetJustifyH("CENTER")
	APHBIWarSupplies.Value:SetJustifyV("MIDDLE")
	APHBIWarSupplies.Value:SetPoint("BOTTOM",APHBIWarSupplies,"BOTTOM")
	APHBIWarSupplies.Value:SetText()
	APHBIWarSupplies.Icon = CreateFrame("Button","APHBIWarSuppliesIcon",APHBIWarSupplies,"SecureActionButtonTemplate")
	APHBIWarSupplies.Icon:SetSize(16,16)
	APHBIWarSupplies.Icon.Texture=APHBIWarSupplies.Icon:CreateTexture(nil,"BACKGROUND")
	APHBIWarSupplies.Icon.Texture:SetAllPoints()
	APHBIWarSupplies.Icon:SetPoint("TOP",APHBIWarSupplies,"TOP",-3,0)
	APHBIWarSupplies.Icon.Texture:SetTexture(803763)
	if msqGroups["APHItems"] then msqGroups.APHItems:AddButton(APHBIWarSupplies.Icon) end

	
	
APHBINether = CreateFrame("Frame", "APHBINether", APHBI)
	APHBINether:SetSize(110,30)
	APHBINether:SetPoint("TOPRIGHT",APHBI)
	APHBINether.Texture = APHBINether:CreateTexture(nil,"BACKGROUND")
	--APHBINether.Texture:SetColorTexture(1,0,0,0.9)
	APHBINether.Texture:SetAllPoints()
	APHBINether.Value = APHBINether:CreateFontString("APHBINetherText","ARTWORK","NumberFontNormal")
	APHBINether.Value:SetFont("Fonts\\FRIZQT__.TTF", 10)
	APHBINether.Value:SetJustifyH("CENTER")
	APHBINether.Value:SetJustifyV("MIDDLE")
	APHBINether.Value:SetPoint("BOTTOM",APHBINether,"BOTTOM")
	APHBINether.Value:SetText()
	APHBINether.Icon = CreateFrame("Button","APHBINetherIcon",APHBINether,"SecureActionButtonTemplate")
	APHBINether.Icon:SetSize(16,16)
	APHBINether.Icon.Texture=APHBINether.Icon:CreateTexture(nil,"BACKGROUND")
	APHBINether.Icon.Texture:SetAllPoints()
	APHBINether.Icon.Texture:SetTexture(132775)
	APHBINether.Icon:SetPoint("TOP",APHBINether,"TOP",-3,0)
	if msqGroups["APHItems"] then msqGroups.APHItems:AddButton(APHBINether.Icon) end

	
APHArgus = CreateFrame("Frame", "APHArgus", APHMainFrame)
	APHArgus:SetSize(220,30)
	--APHArgus:SetPoint("BOTTOMLEFT", APHMainFrame, "TOPLEFT")
	APHArgus.Texture = APHArgus:CreateTexture(nil, "BACKGROUND")
	--APHArgus.Texture:SetColorTexture(1,0.3,0.3,0.9)
	APHArgus.Texture:SetAllPoints()

APHArgusVA = CreateFrame("Frame", "APHArgusVA", APHArgus)
	APHArgusVA:SetSize(110,30)
	APHArgusVA:SetPoint("CENTER",APHArgus)
		APHArgusVA.Texture = APHArgusVA:CreateTexture(nil,"BACKGROUND")
	--APHArgusVA.Texture:SetColorTexture(1,0,0,0.9)
	APHArgusVA.Texture:SetAllPoints()
	APHArgusVA.Value = APHArgusVA:CreateFontString("APHArgusVAText","ARTWORK","NumberFontNormal")
	APHArgusVA.Value:SetFont("Fonts\\FRIZQT__.TTF", 10)
	APHArgusVA.Value:SetJustifyH("CENTER")
	APHArgusVA.Value:SetJustifyV("MIDDLE")
	APHArgusVA.Value:SetPoint("BOTTOM",APHArgusVA,"BOTTOM")
	APHArgusVA.Value:SetText("20")
	APHArgusVA.Icon = CreateFrame("Button","APHArgusVAIcon",APHArgusVA,"SecureActionButtonTemplate")
	APHArgusVA.Icon:SetSize(16,16)
	APHArgusVA.Icon.Texture=APHArgusVA.Icon:CreateTexture(nil,"BACKGROUND")
	APHArgusVA.Icon.Texture:SetAllPoints()
	APHArgusVA.Icon.Texture:SetTexture(1064188)
	APHArgusVA.Icon:SetPoint("TOP",APHArgusVA,"TOP",-3,0)
	APHArgusVA.Icon:SetHighlightTexture([[Interface\Buttons\ButtonHilight-Square]],"ADD")

	if msqGroups["APHItems"] then msqGroups.APHItems:AddButton(APHArgusVA.Icon) end

	
	
	-- APHBINether.Icon:SetHighlightTexture([[Interface\Buttons\UI-Panel-MinimizeButton-Highlight]],"ADD")
	
	--APHTest = CreateFrame("Frame","TEST",UIParent)
	--APHTest:SetSize(50,50)
	--APHTest.Texture=APHTest:CreateTexture(nil,"BACKGROUND")
	--APHTest.Texture:SetAllPoints()
	--APHTest.Texture:SetTexture (237446)
	--APHTest:SetPoint("RIGHT",ArtifactPowerFrame)
	

-- APHNews:Show()	

-- Updates--
APHNews = AceGUI:Create("Frame")
APHNews:SetTitle("Artifact Power Helper")
APHNews:SetStatusText("Changelog for version 1.3.8")
APHNews:SetLayout("Flow")
APHNews:SetWidth(1024)
APHNews:Hide()

local update = "|cFFFFFF0009/10/2017|r"..
"\n    •Updated calculations to detect values in the billion Artifact Power range;"..
-- "\n    •|cFFFF0000(NEW)|rAdded support for Argus Veiled Argunite Currency;"..
-- "\n    •|cFFFF0000(NEW)|rAdded the option to switch on/off the highlight of the Veiled Argunite icon;"..
-- "\n    •|cFFFF0000(NEW)|rAdded the option to specify a value threshold for the highlight;(Defaults to 650, the cost of tokens)"..
-- "\n    •|cFFFF0000(NEW)|rAdded option to turn off use of bank Artifact Items;"..
-- "\n    •Fixed bank search functions to include all bags;"..
-- "\n    •|cFFFF0000(NEW)|rAdded the option to turn on/off glowing icons for Artifacts when a point is available;"..
-- "\n    •Attempted to fix an issue with the Portuguese localization;(They use more than one spell name for Empowering)"..
-- "\n    •Attempted to fix an issue with bank AP frame showing when it shouldn't;"..
-- "\n    •Attempted to fix an issue with Combat Lockdown updates that were causing errors;"..
-- "\n    •Added the slash command /aph help to display a few helpful commands when things to wrong;"..
"\n\n As always, feedback is appreciated!"

local body = AceGUI:Create("Label")
body:SetText(update)
body:SetFont("Fonts\\FRIZQT__.TTF", 14, "THINOUTLINE")
body:SetFullWidth(true)

APHNews:AddChild(body)
