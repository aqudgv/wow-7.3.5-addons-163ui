--[[
Addon.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

BuildEnv(...)

Addon = LibStub('AceAddon-3.0'):NewAddon('Q-genius', 'AceEvent-3.0', 'LibClass-2.0', 'LibModule-1.0')

GUI = LibStub('NetEaseGUI-2.0')

function Addon:OnEnable()
    hooksecurefunc('AchievementObjectives_DisplayCriteria', function(objectivesFrame, id, renderOffScreen)
        if not id then
            return
        end

    	local numCriteria = GetAchievementNumCriteria(id)
        if numCriteria == 0 then
            return
        end

        local textStrings = 0
        for i = 1, numCriteria do
            local criteriaString, criteriaType, completed, quantity, reqQuantity, charName, flags, assetID, quantityString = GetAchievementCriteriaInfo(id, i)

            if criteriaType == CRITERIA_TYPE_ACHIEVEMENT and assetID then
            elseif bit.band(flags, EVALUATION_TREE_FLAG_PROGRESS_BAR) == EVALUATION_TREE_FLAG_PROGRESS_BAR then
            else
                textStrings = textStrings + 1
                local metaCriteria = AchievementButton_GetCriteria(textStrings, renderOffScreen)
                if not metaCriteria.Helper then
                    metaCriteria.Helper = Helper:New(metaCriteria)
                end

                if completed or not GetAchievementData(id, criteriaString) then
                    metaCriteria.Helper:Hide()
                else
                    metaCriteria.Helper:Set(id, criteriaString)
                    metaCriteria.Helper:Show()
                end
            end
        end
    end)
end

function Addon:ToggleWorldMap(quests)
    local zone, zoneLevel = GetQuestZone(quests[1])
    if not zone then
        return
    end

    ShowUIPanel(WorldMapFrame)
    SetMapByID(zone)
    local level = zoneLevel + (DungeonUsesTerrainMap() and 1 or 0)
    SetDungeonMapLevel(level)
    WorldMap:SetQuests(zone, level, quests)
end

function Addon:ToggleQuestsMenuTable(quests, anchor)
    local menuTable = {
        {
            text = '任务达人',
            isTitle = true,
        },
    }

    for _, questId in ipairs(quests) do
        tinsert(menuTable, {
            text = GetQuestName(questId),
            func = function()
                self:ToggleWorldMap({questId})
            end
        })
    end

    GUI:ToggleMenu(anchor, menuTable)
end

function Addon:FillQuestTip(tip, questId)
    tip:AddHeader(GetQuestName(questId), NORMAL_FONT_COLOR:GetRGB())

    local r, g, b = HIGHLIGHT_FONT_COLOR:GetRGB()

    if IsQuestInLog(questId) then
        tip:AddLine('已经接取', GREEN_FONT_COLOR:GetRGB())
    else
        local zone, _, description = GetQuestZone(questId)
        if zone then
            local x, y = GetQuestPosition(questId)
            tip:AddDoubleLine('地区', format('%s (%d, %d)', GetMapNameByID(zone), x, y), r, g, b, r, g, b)
        else
            tip:AddDoubleLine('地区', description, r, g, b, r, g, b)
        end

        local reputation, reputationStanding = GetQuestReputation(questId)
        if reputation then
            local name, _, standingId = GetFactionInfoByID(reputation)
            local color = standingId >= reputationStanding and GREEN_FONT_COLOR or RED_FONT_COLOR
            tip:AddDoubleLine('声望', format('%s (%s)', name, _G['FACTION_STANDING_LABEL' .. reputationStanding]), r, g, b, color:GetRGB())
        end

        local level = GetQuestMinLevel(questId)
        if level then
            local color = level <= UnitLevel('player') and GREEN_FONT_COLOR or RED_FONT_COLOR
            tip:AddDoubleLine('等级', level, r, g, b, color:GetRGB())
        end
    end
end
