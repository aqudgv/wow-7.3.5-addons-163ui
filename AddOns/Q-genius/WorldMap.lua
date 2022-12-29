--[[
WorldMap.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

BuildEnv(...)

WorldMap = Addon:NewModule(CreateFrame('Frame', nil, WorldMapButton), 'WorldMap', 'AceEvent-3.0')

function WorldMap:OnInitialize()
    GUI:Embed(self, 'Refresh')

    self.freeBlips   = {}
    self.activeBlips = {}
    self.blipScripts = {}
    self.x           = 0
    self.y           = 0
    self.blipSize    = 16

    self:SetAllPoints(WorldMapButton)

    self:RegisterEvent('WORLD_MAP_UPDATE', 'Refresh')

    self:SetScript('OnSizeChanged', self.OnSizeChanged)
    self:SetScript('OnHide', self.OnHide)
    self:SetScript('OnShow', self.Refresh)

    self.Tooltip = GUI:GetClass('Tooltip'):GetGlobalTooltip()
end

function WorldMap:GetCurrentAreaInfo()
    local map = GetCurrentMapAreaID()
    local lvl = GetCurrentMapDungeonLevel()
    if DungeonUsesTerrainMap() then
        lvl = lvl - 1
    end
    return map, lvl
end

function WorldMap:OnHide()
    C_Timer.After(1, function()
        if self:IsVisible() then
            self:Refresh()
        else
            
            self:Clear()
            self.quests = nil
            self.zone   = nil
            self.level  = nil
        end
    end)
end

function WorldMap:Update()
    self:Clear()

    if not self:IsVisible() then
        return
    end
    if not self.quests then
        return
    end

    local zone, level = self:GetCurrentAreaInfo()
    if zone == self.zone and level == self.level then
        for _, questId in ipairs(self.quests) do
            self:DrawQuest(questId)
        end
    end
end

function WorldMap:OnSizeChanged()
    for blip in pairs(self.activeBlips) do
        self:UpdateBlipSize(blip)
    end
end

function WorldMap:Clear()
    
    for blip in pairs(self.activeBlips) do
        blip:Hide()
    end
end

function WorldMap:CreateBlip()
    local blip = Addon:GetClass('Blip'):New(self)

    blip:RegisterForClicks('LeftButtonUp', 'RightButtonUp')
    blip:Hide()
    blip:SetScript('OnClick', self:BlipScript(self.BlipOnClick))
    blip:SetScript('OnEnter', self:BlipScript(self.BlipOnEnter))
    blip:SetScript('OnLeave', self:BlipScript(self.BlipOnLeave))
    blip:SetScript('OnHide', self:BlipScript(self.BlipOnHide))
    blip:SetScript('OnShow', self:BlipScript(self.BlipOnShow))

    return blip
end

function WorldMap:AllocBlip()
    return next(self.freeBlips) or self:CreateBlip()
end

function WorldMap:BlipOnShow(blip)
    self.freeBlips[blip] = nil
    self.activeBlips[blip] = true
end

function WorldMap:BlipOnHide(blip)
    self.activeBlips[blip] = nil
    self.freeBlips[blip] = true
    blip:Hide()
end

function WorldMap:BlipScript(method)
    if not method then
        return nil
    end
    if not self.blipScripts[method] then
        self.blipScripts[method] = function(...)
            return method(self, ...)
        end
    end
    return self.blipScripts[method]
end

function WorldMap:BlipOnEnter(blip)
    self.Tooltip:SetOwner(blip, 'ANCHOR_RIGHT')

    local r, g, b = HIGHLIGHT_FONT_COLOR:GetRGB()

    self.Tooltip:AddHeader('任务达人', r, g, b)

    for _, blip in ipairs(self:GetMouseOverBlips()) do
        Addon:FillQuestTip(self.Tooltip, blip.questId)
    end

    self.Tooltip:Show()
    self.Tooltip:SetFrameStrata('TOOLTIP')
end

function WorldMap:GetMouseOverBlips()
    local blips = {}
    for blip in pairs(self.activeBlips) do
        if blip:IsMouseOver() then
            tinsert(blips, blip)
        end
    end
    return blips
end

function WorldMap:BlipOnLeave()
    self.Tooltip:Hide()
end

function WorldMap:DrawQuest(questId)
    local blip = self:AllocBlip()

    self:UpdateBlip(blip, questId)
    blip:Show()

end

function WorldMap:UpdateBlip(blip, questId)
    local x, y      = GetQuestPosition(questId)
    local canAccept = IsQuestCanAccept(questId)

    blip.questId = questId
    blip.Icon:SetVertexColor((canAccept and GREEN_FONT_COLOR or RED_FONT_COLOR):GetRGB())
    self:SetBlipPosition(blip, x, y)
    self:UpdateBlipSize(blip)
end

function WorldMap:SetQuests(zone, level, quests)
    self.zone, self.level, self.quests = zone, level, quests
    self:Refresh()
end

function WorldMap:SetBlipPosition(blip, x, y)
    local w, h = self:GetWidth()-self.x*2, self:GetHeight()+self.y*2
    local x, y = x*w/100+self.x, -y*h/100-self.y

    blip:ClearAllPoints()
    blip:SetPoint('CENTER', self, 'TOPLEFT', x, y)
end

function WorldMap:UpdateBlipSize(blip)
    local scale = self:GetEffectiveScale()
    blip:SetSize(16/scale, 16/scale)
    blip:SetFrameLevel(self:GetFrameLevel() + 1800)
end
