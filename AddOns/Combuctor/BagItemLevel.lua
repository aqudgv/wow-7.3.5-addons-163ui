-- 物品信息庫 Author: M---------------------------------
--Toolip
local tooltip = CreateFrame("GameTooltip", "TinyLibItemTooltip", UIParent, "GameTooltipTemplate")
--物品是否本地化
local function hasLocally(ItemID)
    if (not ItemID or ItemID == "" or ItemID == "0") then return true end
    return select(10, GetItemInfo(tonumber(ItemID)))
end
--物品是否本地化
local function ItemLocally(ItemLink)
    local id, gem1, gem2, gem3 = string.match(ItemLink, "item:(%d+):[^:]*:(%d-):(%d-):(%d-):")
    return (hasLocally(id) and hasLocally(gem1) and hasLocally(gem2) and hasLocally(gem3))
end
--物品等級匹配規則
local ItemLevelPattern = gsub(ITEM_LEVEL, "%%d", "(%%d+)")
--獲取物品實際信息
local function GetItemInfoActually(ItemLink)
    if (not ItemLink or ItemLink == "") then
        return 0, 0
    end
    if (not string.match(ItemLink, "item:%d+:")) then
        return -1, 0
    end
    if (not ItemLocally(ItemLink)) then
        return 1, 0
    end
    local level, text
    tooltip:SetOwner(UIParent, "ANCHOR_NONE")
    tooltip:ClearLines()
    tooltip:SetHyperlink(ItemLink)
    for i = 2, 5 do
        text = _G[tooltip:GetName().."TextLeft" .. i]:GetText() or ""
        level = string.match(text, ItemLevelPattern)
        if (level) then break end
    end
    return 0, tonumber(level) or 0, GetItemInfo(ItemLink)
end
----------------------------  API 封裝--------------------------
local _, LibItem = ...
--API 喚起計劃任務
function LibItem:GetItemInfoActually(ItemLink) return GetItemInfoActually(ItemLink) end
--------------------------------------- 包包顯示物品等級 Author: M-------------------------------------
local function SetContainerItemLevel(button, ItemLink)
    if (not button) then return end
    if (not button.levelString) then
        button.levelString = button:CreateFontString(nil, "OVERLAY")
		button.levelString:SetFont(STANDARD_TEXT_FONT, 13, "OUTLINE")
		button.levelString:SetPoint("TOP")
        button.levelString:SetTextColor(1, 0.82, 0)
    end
    if (button.origItemLink ~= ItemLink) then
        button.origItemLink = ItemLink
    else
        return
    end
    if (ItemLink) then
        local count, level, _, _, quality, _, _, class, _, _, equipSlot = LibItem:GetItemInfoActually(ItemLink)
        if (count == 0 and level > 0) then
            button.levelString:SetText(level)
        else
            button.levelString:SetText("")
        end
        if (quality and quality > 1) then
            local r, g, b, hex = GetItemQualityColor(quality)            --button.levelString:SetTextColor(r, g, b)
        end
    else
        button.levelString:SetText("")
    end
end
-- 背包
hooksecurefunc("ContainerFrame_Update", function(self)
    local id = self:GetID()
    local name = self:GetName()
    local button
    for i = 1, self.size do
        button = _G[name.."Item"..i]
        SetContainerItemLevel(button, GetContainerItemLink(id, button:GetID()))
    end
end)
-- 银行
hooksecurefunc("BankFrameItemButton_Update", function(self)
    SetContainerItemLevel(self, GetContainerItemLink(self:GetParent():GetID(), self:GetID()))
end)
-- For Combuctor
if (Combuctor and Combuctor.ItemSlot) then
    local origFunc = Combuctor.ItemSlot.Update
    function Combuctor.ItemSlot:Update()
        origFunc(self)
        SetContainerItemLevel(self, self:GetItem())
    end
end