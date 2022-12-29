--[[
API.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

BuildEnv(...)

function IsQuestCompleted(questId)
    local completed = GetQuestsCompleted() or {}
    return completed[questId]
end

function GetQuestDependencies(questId)
    local info = QUEST_DATA[questId]
    return info and info.dependencies
end

function IsPrevQuestCompleted(questId)
    local dependencies = GetQuestDependencies(questId)
    if not dependencies then
        return true
    end

    for _, questId in ipairs(dependencies) do
        if IsQuestValid(questId) and not IsQuestCompleted(questId) then
            return false
        end
    end
    return true
end

function GetUncomplateQuest(quests, callback, continue)
    local touched = {}
    local count = 0
    local db = {}
    local co

    local function fn(quests)
        if not quests then
            return
        end

        for _, questId in ipairs(quests) do
            if not touched[questId] and IsQuestValid(questId) and not IsQuestCompleted(questId) then
                touched[questId] = true
                count = count + 1

                if count > 10 then
                    C_Timer.After(0.05, function()
                        coroutine.resume(co, not continue or continue())
                    end)
                    if not coroutine.yield() then
                        return
                    end
                    count = 0
                end

                if IsPrevQuestCompleted(questId) then
                    tinsert(db, questId)
                else
                    fn(GetQuestDependencies(questId))
                end
            end
        end
        return db
    end

    co = coroutine.create(function()
        return callback(fn(quests))
    end)
    coroutine.resume(co)
end

function GetAchievementData(achievementId, criteria)
    local info = ACHIEVEMENT_DATA[achievementId]
    return info and info[criteria]
end

function GetUncomplateQuestByAchievement(achievementId, criteria, ...)
    local quests = GetAchievementData(achievementId, criteria)
    if quests then
        return GetUncomplateQuest(quests, ...)
    end
end

function GetQuestData(questId, key)
    local info = QUEST_DATA[questId]
    if not info then
        return false
    end
    return info[key] or false
end

function GetQuestName(questId)
    local info = QUEST_DATA[questId]
    if not info then
        return
    end
    return info.name
end

function IsQuestValid(questId)
    local info = QUEST_DATA[questId]
    if not info then
        return
    end
    return not info.faction or info.faction == UnitFactionGroup('player')
end

function GetQuestZone(questId)
    local info = QUEST_DATA[questId]
    if not info then
        return
    end
    return MAP_FILE_TO_ID[info.zone], info.zoneLevel, info.zoneDescription
end

function GetQuestReputation(questId)
    local info = QUEST_DATA[questId]
    if not info then
        return
    end
    return info.reputation, info.reputationLevel
end

function GetQuestMinLevel(questId)
    local info = QUEST_DATA[questId]
    if not info then
        return
    end
    return info.level
end

function GetQuestPosition(questId)
    local info = QUEST_DATA[questId]
    if not info then
        return
    end
    return info.x, info.y
end

function IsQuestInLog(questId)
    local numEntries, numQuests = GetNumQuestLogEntries()
    for i = 1, numEntries do
        local _, _, _, isHeader, _, _, _, id = GetQuestLogTitle(i)

        if not isHeader and id == questId then
            return true
        end
    end
end

function IsQuestCanAccept(questId)
    local level = GetQuestMinLevel(questId)
    if level and level > UnitLevel('player') then
        return false
    end

    local reputation, reputationStanding = GetQuestReputation(questId)
    if reputation and select(3, GetFactionInfoByID(reputation)) < reputationStanding then
        return false
    end
    return true
end

MAP_FILE_TO_ID = {} do
    for _, id in ipairs(GetAreaMaps()) do
        -- SetMapByID(id)

        local file = select(2, GetAreaMapInfo(id))
        MAP_FILE_TO_ID[file] = id
    end
end
