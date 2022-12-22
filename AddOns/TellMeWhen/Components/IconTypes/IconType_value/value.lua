﻿-- --------------------
-- TellMeWhen
-- Originally by Nephthys of Hyjal <lieandswell@yahoo.com>

-- Other contributions by:
--		Sweetmms of Blackrock, Oozebull of Twisting Nether, Oodyboo of Mug'thol,
--		Banjankri of Blackrock, Predeter of Proudmoore, Xenyr of Aszune

-- Currently maintained by
-- Cybeloras of Aerie Peak/Detheroc/Mal'Ganis
-- --------------------

local TMW = TMW
if not TMW then return end
local L = TMW.L

local print = TMW.print
local UnitPower, UnitPowerMax
	= UnitPower, UnitPowerMax
local pairs
	= pairs  
	
local _, pclass = UnitClass("Player")
local GetSpellTexture = TMW.GetSpellTexture



local Type = TMW.Classes.IconType:New("value")
Type.name = L["ICONMENU_VALUE"]
Type.desc = L["ICONMENU_VALUE_DESC"]
Type.menuIcon = "Interface/Icons/inv_potion_49"
Type.unitType = "unitid"
Type.hasNoGCD = true
Type.canControlGroup = true
Type.menuSpaceBefore = true

local STATE_UNITFOUND = TMW.CONST.STATE.DEFAULT_SHOW
local STATE_NOUNIT = TMW.CONST.STATE.DEFAULT_HIDE

Type:SetAllowanceForView("icon", false)


-- AUTOMATICALLY GENERATED: UsesAttributes
Type:UsesAttributes("value, maxValue, valueColor")
Type:UsesAttributes("state")
Type:UsesAttributes("unit, GUID")
Type:UsesAttributes("texture")
-- END AUTOMATICALLY GENERATED: UsesAttributes

Type:SetModuleAllowance("IconModule_TimerBar_Overlay", false)
Type:SetModuleAllowance("IconModule_CooldownSweep", false)


Type:RegisterIconDefaults{
	-- The unit to check for resources
	Unit					= "player", 

	-- The power type to display from the unit.
	-- -2 is the default resouce type. -1 is health.
	PowerType				= -2,

	-- Whether to represent value fragments, or only whole value increments.
	ValueFragments          = false,
}



Type:RegisterConfigPanel_XMLTemplate(105, "TellMeWhen_Unit", {
	implementsConditions = true,
})

Type:RegisterConfigPanel_XMLTemplate(165, "TellMeWhen_IconStates", {
	[STATE_UNITFOUND] = { text = "|cFF00FF00" .. L["ICONMENU_VALUE_HASUNIT"], },
	[STATE_NOUNIT]    = { text = "|cFFFF0000" .. L["ICONMENU_VALUE_NOUNIT"],  },
})

Type:RegisterConfigPanel_ConstructorFunc(100, "TellMeWhen_ValueSettings", function(self)
	self:SetTitle(L["ICONMENU_VALUE_POWERTYPE"])

	local types = {
		[-2] = L["CONDITIONPANEL_POWER"],
		[-1] = HEALTH,

	    [Enum.PowerType.Mana] = MANA,
		[Enum.PowerType.Rage] = RAGE,
		[Enum.PowerType.Energy] = ENERGY,
		[Enum.PowerType.ComboPoints] = COMBO_POINTS,
		[Enum.PowerType.Focus] = FOCUS,
		-- [SPELL_POWER_RUNES] = RUNES,
		[Enum.PowerType.RunicPower] = RUNIC_POWER,
		[Enum.PowerType.SoulShards] = SOUL_SHARDS_POWER,
		[Enum.PowerType.HolyPower] = HOLY_POWER,
		[Enum.PowerType.Chi] = CHI_POWER;
		[Enum.PowerType.Maelstrom] = MAELSTROM_POWER,
		[Enum.PowerType.ArcaneCharges] = ARCANE_CHARGES_POWER,
		[Enum.PowerType.LunarPower] = LUNAR_POWER,
		[Enum.PowerType.Insanity] = INSANITY_POWER,
		[Enum.PowerType.Fury] = FURY,
		[Enum.PowerType.Pain] = PAIN,
	    [Enum.PowerType.Alternate] = L["CONDITIONPANEL_ALTPOWER"],
	}



	self.PowerType = TMW.C.Config_DropDownMenu:New("Frame", "$parent", self, "TMW_DropDownMenuTemplate")

	self.PowerType:SetTexts(L["ICONMENU_VALUE_POWERTYPE"], L["ICONMENU_VALUE_POWERTYPE_DESC"])
	local function DropdownOnClick(button, arg1)
		TMW.CI.ics.PowerType = arg1
		self.PowerType:SetText(button.value)
		TMW.IE:LoadIcon(1)
	end
	self.PowerType:SetFunction(function(self)
		for id, name in TMW:OrderedPairs(types) do
			local info = TMW.DD:CreateInfo()
			info.text = name
			info.func = DropdownOnClick
			info.arg1 = id
			info.checked = info.arg1 == TMW.CI.ics.PowerType
			TMW.DD:AddButton(info)
		end
	end)

	self:SetHeight(36)
	-- self.PowerType:SetDropdownAnchor("TOPRIGHT", self.PowerType.Middle, "BOTTOMRIGHT")
	self.PowerType:SetPoint("TOPLEFT", 5, -5)
	self.PowerType:SetPoint("RIGHT", -5, 0)

	self:CScriptAdd("ReloadRequested", function()
		self.PowerType:SetText(types[TMW.CI.ics.PowerType])
	end)
end)

Type:RegisterConfigPanel_ConstructorFunc(105, "TellMeWhen_ValueCheckSettings", function(self)
	self:SetTitle(Type.name)
	self:BuildSimpleCheckSettingFrame({
		function(check)
			check:SetTexts(L["ICONMENU_VALUEFRAGMENTS"], L["ICONMENU_VALUEFRAGMENTS_DESC"])
			check:SetSetting("ValueFragments")
			check:CScriptAdd("ReloadRequested", function()
				local settings = self:GetSettingTable()
				-- pcall because this function doesn't accept invalid values.
				local success, powerMod = pcall(UnitPowerDisplayMod, settings.PowerType)
				check:SetEnabled(success and powerMod > 1 or false)
			end)
		end,
	})
end)

TMW:RegisterUpgrade(72011, {
	icon = function(self, ics)
		if ics.PowerType == 100 then
			ics.PowerType = SPELL_POWER_COMBO_POINTS
		end
	end,
})



local PowerBarColor = CopyTable(PowerBarColor)
for k, v in pairs(PowerBarColor) do
	v.a = 1
end
PowerBarColor[-1] = {{r=1, g=0, b=0, a=1}, {r=1, g=1, b=0, a=1}, {r=0, g=1, b=0, a=1}}

local function Value_OnUpdate(icon, time)
	local PowerType = icon.PowerType
	local ValueFragments = icon.ValueFragments
	local Units = icon.Units

	for u = 1, #Units do
		local unit = Units[u]
		-- UnitSet:UnitExists(unit) is an improved UnitExists() that returns early if the unit
		-- is known by TMW.UNITS to definitely exist.
		if icon.UnitSet:UnitExists(unit) then

			local value, maxValue, valueColor
			if PowerType == -1 then
				value, maxValue, valueColor = UnitHealth(unit), UnitHealthMax(unit), PowerBarColor[PowerType]
			else
				if PowerType == -2 then
					PowerType = UnitPowerType(unit)
				end
				if PowerType == 4 then -- combo points
					unit = "player"
				end
				
				value, maxValue, valueColor = UnitPower(unit, PowerType, ValueFragments), UnitPowerMax(unit, PowerType, ValueFragments), PowerBarColor[PowerType]

				if ValueFragments then
					local mod = UnitPowerDisplayMod(PowerType)
					value = value / mod
					maxValue = maxValue / mod
				end
			end

			if not icon:YieldInfo(true, unit, value, maxValue, valueColor) then
				return
			end
		end
	end

	icon:YieldInfo(false)
end

function Type:HandleYieldedInfo(icon, iconToSet, unit, value, maxValue, valueColor)
	if unit then
		iconToSet:SetInfo("state; value, maxValue, valueColor; unit, GUID",
			STATE_UNITFOUND,
			value, maxValue, valueColor,
			unit, nil
		)
	else
		iconToSet:SetInfo("state; value, maxValue, valueColor; unit, GUID",
			STATE_NOUNIT,
			0, 0, nil,
			nil, nil
		)
	end
end


function Type:Setup(icon)
	icon.Units, icon.UnitSet = TMW:GetUnits(icon, icon.Unit, icon:GetSettings().UnitConditions)

	icon:SetInfo("texture", "Interface/Icons/inv_potion_49")
	
	icon:SetUpdateMethod("auto")
	
	icon:SetUpdateFunction(Value_OnUpdate)
	
	
	icon:Update()
end

TMW:RegisterCallback("TMW_CONFIG_ICON_TYPE_CHANGED", function(event, icon, type, oldType)
	local icspv = icon:GetSettingsPerView()

	if type == Type.type then
		icon:GetSettings().CustomTex = "NONE"
		local layout = TMW.TEXT:GetTextLayoutForIcon(icon)

		if layout == "bar1" or layout == "bar2" then
			icspv.Texts[1] = "[(Value / ValueMax * 100):Round:Percent]"
			icspv.Texts[2] = "[Value:Short \"/\" ValueMax:Short]"
		end
	elseif oldType == Type.type then
		if icspv.Texts[1] == "[(Value / ValueMax * 100):Round:Percent]" then
			icspv.Texts[1] = nil
		end
		if icspv.Texts[2] == "[Value:Short \"/\" ValueMax:Short]" then
			icspv.Texts[2] = nil
		end
	end
end)


Type:Register(157)

