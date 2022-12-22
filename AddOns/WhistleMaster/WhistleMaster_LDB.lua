local dataobj = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("WhistleMaster", {
	type = "data source",
	label = "哨子",
	text = "未知",
	icon = "Interface\\Icons\\Ability_Hunter_Beastcall",
	OnClick = function(clickedframe, button)
		ToggleFrame(WorldMapFrame)
	end,
})

local f = CreateFrame("frame")
local UPDATEPERIOD, elapsed = 5, 0

f:SetScript("OnUpdate", function(self, elap)
	elapsed = elapsed + elap
	if elapsed < UPDATEPERIOD then return end
	elapsed = 0
	if UpdateWhistleMaster() then
		dataobj.text = WM_ClosestNode.name:gsub("，.*$","")
	else
		dataobj.text = "未知"
	end

end)

function dataobj:OnTooltipShow()
	self:AddLine("点击开启世界地图")
end

function dataobj:OnEnter()
	GameTooltip:SetOwner(self, "ANCHOR_NONE")
	GameTooltip:SetPoint("TOP", self, "BOTTOM")
	GameTooltip:ClearLines()
	dataobj.OnTooltipShow(GameTooltip)
	GameTooltip:Show()
end

function dataobj:OnLeave()
	GameTooltip:Hide()
end
