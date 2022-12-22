U1RegisterAddon("AtlasLoot", { 
    title = "副本掉落查询",
    tags = {TAG_ITEM, TAG_BIG, },
    minimap = "LibDBIcon10_AtlasLoot",
    defaultEnable = 0,

    author = "Hegarol",
    desc = "显示副本中的首领与小怪可能掉落的物品，并且可以查询各种声望、战场、兑换物的奖励物品等。`快捷命令：/al 或 /atlasloot``|cff00d100本插件下的子模块全部开启即可，会自动加载需要的部分|r",
    icon = [[Interface\Icons\INV_Box_01]],

    --children = {"^AtlasLoot$", "AtlasLoot_.*"}, --AtlasLootReverse, AtlasLoot_Tooltip

    {
        type="button",
        text="开启主界面",
        tip="快捷命令`/al 或 /atlasloot",
        callback = function() AtlasLoot.SlashCommands:Run("") end
    },
    {
        type="button",
        text="配置选项",
        callback = function() AtlasLoot.SlashCommands:Run("options") end
    },
});

U1RegisterAddon("AtlasLoot_WarlordsofDraenor", {title = "德拉诺之王数据",});

U1RegisterAddon("AtlasLoot_Legion", {title = "军团再临数据",});

U1RegisterAddon("AtlasLoot_Collections", {title = "收藏品数据",});
U1RegisterAddon("AtlasLoot_PvP", {title = "PvP装备数据",});
U1RegisterAddon("AtlasLoot_Factions", {title = "声望奖励物品数据",});
U1RegisterAddon("AtlasLoot_Crafting", {title = "商业制造物品数据",});
U1RegisterAddon("AtlasLoot_WorldEvents", {title = "世界事件数据",});

U1RegisterAddon("AtlasLoot_Classic", {title = "经典旧世数据",});
U1RegisterAddon("AtlasLoot_BurningCrusade", {title = "燃烧的远征数据",});
U1RegisterAddon("AtlasLoot_WrathoftheLichKing", {title = "巫妖王之怒数据",});
U1RegisterAddon("AtlasLoot_Cataclysm", {title = "大地的裂变数据",});
U1RegisterAddon("AtlasLoot_MistsofPandaria", {title = "熊猫人之谜数据",});

U1RegisterAddon("AtlasLoot_Options", {title = "配置界面",});

