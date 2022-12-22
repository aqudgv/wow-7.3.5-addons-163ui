--[[
Helper.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

BuildEnv(...)

Helper = Addon:NewClass('Helper', 'Button')

Helper.Tooltip = GUI:GetClass('Tooltip'):GetGlobalTooltip()

function Helper:Constructor()
    self:SetPoint('LEFT', 22, -2)
    self:SetSize(12,12)

    self:SetNormalTexture([[Interface\FriendsFrame\InformationIcon]])
    self:SetHighlightTexture([[Interface\FriendsFrame\InformationIcon]], 'ADD')

    self:Hide()
    self:SetScript('OnClick', self.OnClick)
    self:SetScript('OnEnter', self.OnEnter)
    self:SetScript('OnLeave', self.OnLeave)
    self:SetCallback('OnQueryFinished', self.OnQueryFinished)
end

function Helper:OnQueryFinished()
    if GetMouseFocus() == self then
        return self:OnEnter()
    end
end

function Helper:OnClick()
    local quests = self:GetQuests() or self:QueryQuests()
    if not quests then
        return
    end

    if not self:IsOnlyOneZone() then
        Addon:ToggleQuestsMenuTable(quests, self)
    else
        Addon:ToggleWorldMap(quests)
    end
end

function Helper:OnEnter()
    local quests = self:GetQuests() or self:QueryQuests()
    local Tooltip = self.Tooltip

    Tooltip:SetOwner(self, 'ANCHOR_RIGHT')
    Tooltip:SetText('任务达人', HIGHLIGHT_FONT_COLOR:GetRGB())

    if quests then
        for _, questId in ipairs(self:GetQuests()) do
            Addon:FillQuestTip(Tooltip, questId)
        end
    else
        Tooltip:AddLine('正在计算任务线完成状态...', RED_FONT_COLOR:GetRGB())
    end
    Tooltip:Show()
end

function Helper:OnLeave()
    self.Tooltip:Hide()
end

function Helper:Set(achievementId, criteria)
    if achievementId == self.achievementId and criteria == self.criteria then
        return
    end
    self.achievementId = achievementId
    self.criteria = criteria
    self.quests = nil
    self.inQuery = nil
end

function Helper:GetQuests()
    return self.quests
end

function Helper:QueryQuests()
    if self.inQuery or self.quests then
        return
    end

    self.inQuery = true

    GetUncomplateQuestByAchievement(self.achievementId, self.criteria, function(quests)
        self.quests = quests
        self.inQuery = nil
        self:Fire('OnQueryFinished')
    end)
end

function Helper:IsOnlyOneZone()
    local zone, level
    for _, questId in pairs(self.quests) do
        local z, l = GetQuestZone(questId)

        if zone and z ~= zone then
            return false
        end
        if level and level ~= l then
            return false
        end
        zone, level = z, l
    end
    return true
end
