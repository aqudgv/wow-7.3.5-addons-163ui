U1RegisterAddon("RaidAchievement", {
    title = "副本成就助手",
    defaultEnable = 0,
    load = "NORMAL",
    deps = { "AchievementsReminder" }, --必须先加载AchievementReminder，否则无法生效
    minimap = "RA_MinimapButton",

    tags = { TAG_RAID },
    icon = [[Interface\Icons\Achievement_Quests_Completed_08]],
    desc = "自动检测你所在的副本类型加载相应的模块，检测通报副本成就的失败与否，显示失败的原因和失败者的名字。如演示图，显示成就失败，并显示导致成就失败的队友名字。",
    nopic = 1,

    toggle = function(name, info, enabled, justload)
        return true
    end,

    {
        type="button",
        text="配置选项",
        callback = function(cfg, v, loading) HideUIPanel(GameMenuFrame); PHOENIXSTYLEEASYACH_Command() end,
    },
    
});

--[[U1RegisterAddon("RaidAchievement_AchieveReminder", {title = '设置模块', protected = nil, hide = nil, });
U1RegisterAddon("RaidAchievement_CataHeroics", {title = 'CTM英雄副本模块', protected = nil, hide = nil, });
U1RegisterAddon("RaidAchievement_CataRaids", {title = 'CTM团队副本模块', protected = nil, hide = nil, });
U1RegisterAddon("RaidAchievement_Icecrown", {title = '冰冠模块', protected = nil, hide = nil, });
U1RegisterAddon("RaidAchievement_Naxxramas", {title = 'NAXX模块', protected = nil, hide = nil, });
U1RegisterAddon("RaidAchievement_PandaHeroics", {title = 'MOP英雄副本模块', protected = nil, hide = nil, });
U1RegisterAddon("RaidAchievement_PandaRaids", {title = 'MOP团队副本模块', protected = nil, hide = nil, });
U1RegisterAddon("RaidAchievement_PandaScenarios", {title = 'MOP事件副本模块', protected = nil, hide = nil, });
U1RegisterAddon("RaidAchievement_Ulduar", {title = '奥杜亚模块', protected = nil, hide = nil, });
U1RegisterAddon("RaidAchievement_WotlkHeroics", {title = 'WLK英雄副本模块', protected = nil, hide = nil, });]]


