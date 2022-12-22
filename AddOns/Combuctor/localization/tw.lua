--[[
	Traditional Chinese
		By Irene Wang
--]]

local L = LibStub("AceLocale-3.0"):NewLocale("Combuctor", "zhTW")
if not L then return end


L.Updated = '更新到%s版'

--binding actions
L.ToggleInventory = "    打開/關閉背包"
L.ToggleBank = "    打開/關閉銀行"

--frame titles
L.InventoryTitle = "%s的背包"
L.BankTitle = "%s的銀行"

--tooltips
L.Inventory = '背包'
L.Bank = '銀行'
L.Total = '總'
L.ClickToPurchase = '<點選>購買'
L.Bags = '容器'
L.BagToggle = '|CFF00FFFF<左鍵點選>|r顯示或隱藏容器'
L.InventoryToggle = '|CFF00FFFF<右鍵點選>|r打開或關閉背包視窗'
L.BankToggle = '|CFF00FFFF<右鍵點選>|r打開或關閉銀行視窗'
L.Characters = '|CFF00FFFF<左键点击>|r插件其他角色背包(为历史记录，不一定符合现况)'
L.PurchaseBag = '购买银行栏位'
L.SortItems = '|CFF00FFFF<左键点击>|r整理背包(|CFFD74DE1正序|r).|CFF00FFFF<Ctrl+左击>|r(|CFFD74DE1逆序|r).'
L.DepositReagents = '|CFF00FFFF<右键点击>|r将材料存放到材料银行(系统默认).'
L.PurchaseBag = '点击购买此银行栏位.'



-- options
L.Sets = '装备分类'
L.Panel = '面板'
L.OptionsSubtitle = '背包设置'
L.LeftFilters = '将物品分类栏显示在窗体左侧'
L.ActPanel = '作为标准面板运作'
L.HighlightItemsByQuality = '物品品质染色' 
L.HighlightUnusableItems = '不可用物品染色'
L.HighlightSetItems = '已定义套装染色'
L.HighlightQuestItems = '任务物品染色'
L.TipCounts = '在道具的信息提示悬浮窗中启用道具计数器'
L.HighlightNewItems = '高亮显示新获得的物品'  
L.HighlightQuestItems = '高亮显示任务物品'
L.TipCounts = '鼠标提示显示数量'

-- options tooltips
L.LeftFiltersTip = [[
若勾选，物品分类栏将显示在此面板左侧。]]

L.ActPanelTip = [[
若勾选，则此面板将自动定位在普通面板所定位的地方，
如|cffffffff法术书和技能|r界面或|cffffffff地下城查找器|r界面
默认出现的地点，且不可被移动。]]

L.TipCountsTip = [[
若勾选，道具的信息提示悬浮窗将显示哪位角色拥有
这项道具，拥有多少，以及这些道具处于何方。]]


L.Normal = '一般'
L.Equipment = '裝備'
L.Trade = '商業'
L.Ammo = '彈藥'
L.Shards = '碎片'
L.SoulShard = '靈魂碎片'
L.Usable = '消耗品'

--itemcount tooltips
L.TipCount1 = ', 已裝備: %d'
L.TipCount2 = ', 背包: %d'
L.TipCount3 = ', 銀行: %d'
L.TipCount4 = '虚空仓库: %d'
L.TipDelimiter = '|'

--these are automatically localized (aka, don't translate them :)
do
  L.General = GENERAL
  L.Weapon = GetItemClassInfo(LE_ITEM_CLASS_WEAPON)
  L.Armor = GetItemClassInfo(LE_ITEM_CLASS_ARMOR)
  L.Container = GetItemClassInfo(LE_ITEM_CLASS_CONTAINER)
  L.Consumable = GetItemClassInfo(LE_ITEM_CLASS_CONSUMABLE)
  L.Glyph = GetItemClassInfo(LE_ITEM_CLASS_GLYPH)
  L.TradeGood = GetItemClassInfo(LE_ITEM_CLASS_TRADEGOODS)
  L.Recipe = GetItemClassInfo(LE_ITEM_CLASS_RECIPE)
  L.Gem = GetItemClassInfo(LE_ITEM_CLASS_GEM)
  L.Misc = GetItemClassInfo(LE_ITEM_CLASS_MISCELLANEOUS)
  L.Quest = GetItemClassInfo(LE_ITEM_CLASS_QUESTITEM)
  L.Trinket = _G['INVTYPE_TRINKET']
end