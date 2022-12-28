
local addon = TinyTooltip or select(2, ...)

if (GetLocale() ~= "zhCN") then return end

addon.L = {
    ["general.mask"]                        = "顶部遮罩",
    ["general.statusbarText"]               = "HP文字",
    ["general.background"]                  = "背景颜色",
    ["general.borderColor"]                 = "边框颜色",
    ["general.scale"]                       = "框架缩放",
    ["general.borderSize"]                  = "边框大小",
    ["general.statusbarHeight"]             = "HP高度",
    ["general.borderCorner"]                = "边框样式",
    ["general.bgfile"]                      = "背景材质",
    ["general.statusbarPosition"]           = "HP位置",
    ["general.statusbarOffsetX"]            = "HP位置X边距",
    ["general.statusbarOffsetY"]            = "HP位置Y偏移",
    ["general.statusbarFontSize"]           = "HP文字大小",
    ["general.statusbarFont"]               = "HP文字字體",
    ["general.statusbarFontFlag"]           = "HP字体描边",
    ["general.statusbarTexture"]            = "HP背景材质",
    ["general.statusbarColor"]              = "HP颜色",
    ["general.anchor.position"]             = "框架锚点",
    ["general.anchor.returnInCombat"]       = "战斗时复位",
    ["general.anchor.returnOnUnitFrame"]    = "UnitFrame上时复位",
	["general.showCaster"]            		= "显示施法者名字",
    ["general.alwaysShowIdInfo"]            = "始终显示id信息(关闭后按住alt/shift显示)",
    ["general.skinMoreFrames"]              = "样式应用于更多框架 |cffcccc33(重载生效)|r",
    
    ["item.coloredItemBorder"]              = "物品边框染色",
    ["item.showItemIcon"]                   = "显示物品图标",
    ["quest.coloredQuestBorder"]            = "任务边框染色",
    
    ["unit.player.anchor.position"]         = "框架锚点",
    ["unit.player.anchor.returnInCombat"]   = "战斗时复位",
    ["unit.player.anchor.returnOnUnitFrame"] = "UnitFrame上时复位",
    ["unit.player.background"]              = "背景染色",
    ["unit.player.coloredBorder"]           = "边框染色",
    ["unit.player.showTarget"]              = "显示目标",
    ["unit.player.showTargetBy"]            = "显示被关注",
    ["unit.player.showModel"]               = "显示模型",
    ["unit.player.grayForDead"]             = "死亡目标灰度染色",
    ["unit.player.elements.roleIcon"]       = "角色图标",
    ["unit.player.elements.raidIcon"]       = "标记图标",
    ["unit.player.elements.pvpIcon"]        = "PVP状态",
    ["unit.player.elements.factionIcon"]    = "阵营图标",
    ["unit.player.elements.classIcon"]      = "职业图标",
    ["unit.player.elements.title"]          = "头衔",
    ["unit.player.elements.name"]           = "名称",
    ["unit.player.elements.realm"]          = "服务器",
    ["unit.player.elements.statusAFK"]      = "AFK",
    ["unit.player.elements.statusDND"]      = "DND",
    ["unit.player.elements.statusDC"]       = "OFFLINE",
    ["unit.player.elements.guildName"]      = "公会名称",
    ["unit.player.elements.guildIndex"]     = "公会阶级数字",
    ["unit.player.elements.guildRank"]      = "公会阶级名称",
    ["unit.player.elements.guildRealm"]     = "公会服务器",
    ["unit.player.elements.levelValue"]     = "等级",
    ["unit.player.elements.factionName"]    = "阵营",
    ["unit.player.elements.gender"]         = "性别",
    ["unit.player.elements.raceName"]       = "种族",
    ["unit.player.elements.className"]      = "职业",
    ["unit.player.elements.isPlayer"]       = "玩家",
    ["unit.player.elements.role"]           = "角色",
    ["unit.player.elements.moveSpeed"]      = "移动速度",
    ["unit.player.elements.zone"]           = "地区",
    
    ["unit.npc.anchor.position"]            = "框架锚点",
    ["unit.npc.anchor.returnInCombat"]      = "战斗时复位",
    ["unit.npc.anchor.returnOnUnitFrame"]   = "UnitFrame上时复位",
    ["unit.npc.background"]                 = "背景染色",
    ["unit.npc.coloredBorder"]              = "边框染色",
    ["unit.npc.showTarget"]                 = "显示目标",
    ["unit.npc.showTargetBy"]               = "显示被关注数",
    ["unit.npc.grayForDead"]                = "死亡目标灰度染色",
    ["unit.npc.elements.raidIcon"]          = "标记图标",
    ["unit.npc.elements.classIcon"]         = "职业图标",
    ["unit.npc.elements.questIcon"]         = "任务图标",
    ["unit.npc.elements.npcTitle"]          = "头衔",
    ["unit.npc.elements.name"]              = "名称",
    ["unit.npc.elements.levelValue"]        = "等级",
    ["unit.npc.elements.classifBoss"]       = "首领",
    ["unit.npc.elements.classifElite"]      = "精英",
    ["unit.npc.elements.classifRare"]       = "稀有",
    ["unit.npc.elements.creature"]          = "类型",
    ["unit.npc.elements.reactionName"]      = "声望",
    ["unit.npc.elements.moveSpeed"]         = "移动速度",
    
    ["spell.background"]                    = "背景顔色",
    ["spell.borderColor"]                   = "边框颜色",
    ["spell.showIcon"]                      = "法术图标",
    
    ["dropdown.inherit"]        = "|cffffee00继承全局|r",
    ["dropdown.default"]        = "|cffaaaaaa系统默认|r",
    ["dropdown.angular"]        = "直角边框",
    ["dropdown.bottom"]         = "底部",
    ["dropdown.top"]            = "顶部",
    ["dropdown.auto"]           = "智能匹配",
    ["dropdown.smooth"]         = "百分比动态",
    ["dropdown.cursorRight"]    = "鼠标右侧",
    ["dropdown.cursor"]         = "|cff33ccff鼠标|r",
    ["dropdown.static"]         = "|cff33ccff固定位置|r",
    ["dropdown.class"]          = "职业染色",
    ["dropdown.level"]          = "等差染色",
    ["dropdown.reaction"]       = "声望染色",
    ["dropdown.itemQuality"]    = "物品品质染色",
    ["dropdown.selection"]      = "类型染色",
    ["dropdown.faction"]        = "阵营染色",
    ["dropdown.dark"]           = "深黑",
    ["dropdown.alpha"]          = "透明",
    ["dropdown.gradual"]        = "渐变",
    ["dropdown.rock"]           = "岩石",
    ["dropdown.marble"]         = "大理石",

    ["dropdown.none"]           = "|cffaaaaaa(无)|r",
    ["dropdown.reaction5"]      = "声望友好以上",
    ["dropdown.reaction6"]      = "声望尊敬以上",
    ["dropdown.inraid"]         = "团队时",
    ["dropdown.incombat"]       = "战斗中",
    ["dropdown.inpvp"]          = "战场里",
    ["dropdown.inarena"]        = "竞技场",
    ["dropdown.ininstance"]     = "副本时",
    ["dropdown.samerealm"]      = "同服务器",
    ["dropdown.samecrossrealm"]     = "同跨服务器",
    ["dropdown.not reaction5"]      = "|cffff3333非|r声望友好以上",
    ["dropdown.not reaction6"]      = "|cffff3333非|r声望尊敬以上",
    ["dropdown.not inraid"]         = "|cffff3333非|r团队时",
    ["dropdown.not incombat"]       = "|cffff3333非|r战斗中",
    ["dropdown.not inpvp"]          = "|cffff3333非|r战场里",
    ["dropdown.not inarena"]        = "|cffff3333非|r竞技场",
    ["dropdown.not ininstance"]     = "|cffff3333非|r副本时",
    ["dropdown.not samerealm"]      = "|cffff3333非|r同服务器",
    ["dropdown.not samecrossrealm"]  = "|cffff3333非|r同跨服务器",
    
    ["headerFont"]        = "标头字体",
    ["headerFontSize"]    = "标头字体大小",
    ["headerFontFlag"]    = "标头字体描边",
    ["bodyFont"]          = "内容字体",
    ["bodyFontSize"]      = "内容字体大小",
    ["bodyFontFlag"]      = "内容字体描边",
    
    ["Anchor"]   = "锚点器",
    
    ["TargetBy"] = "被关注",
	["Caster"] = "施法者",
}
