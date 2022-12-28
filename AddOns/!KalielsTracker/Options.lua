--- Kaliel's Tracker
--- Copyright (c) 2012-2018, Marouan Sabbagh <mar.sabbagh@gmail.com>
--- All Rights Reserved.
---
--- This file is part of addon Kaliel's Tracker.

local addonName, KT = ...
KT.forcedUpdate = false

local ACD = LibStub("MSA-AceConfigDialog-3.0")
local ACR = LibStub("AceConfigRegistry-3.0")
local LSM = LibStub("LibSharedMedia-3.0")
local WidgetLists = AceGUIWidgetLSMlists
local _DBG = function(...) if _DBG then _DBG("KT", ...) end end

-- Lua API
local floor = math.floor
local fmod = math.fmod
local format = string.format
local ipairs = ipairs
local pairs = pairs
local strlen = string.len
local strsub = string.sub

local db, dbChar
local mediaPath = "Interface\\AddOns\\"..addonName.."\\Media\\"
local anchors = { "TOPLEFT", "TOPRIGHT", "BOTTOMLEFT", "BOTTOMRIGHT" }
local strata = { "LOW", "MEDIUM", "HIGH" }
local flags = { [""] = "無", ["OUTLINE"] = "外框", ["OUTLINE, MONOCHROME"] = "無消除鋸齒外框" }
local textures = { "無", "預設 (暴雪)", "單線", "雙線" }
local modifiers = { [""] = "無", ["ALT"] = "Alt", ["CTRL"] = "Ctrl", ["ALT-CTRL"] = "Alt + Ctrl" }

local cTitle = " "..NORMAL_FONT_COLOR_CODE
local cBold = "|cff00ffe3"
local cWarning = "|cffff7f00"
local beta = "|cffff7fff[Beta]|r"
local warning = cWarning.."注意:|r 將會重新載入介面!"

local KTF = KT.frame
local OTF = ObjectiveTrackerFrame

local GetModulesOptionsTable, MoveModule, SetSharedColor, IsSpecialLocale, DecToHex, RgbToHex	-- functions

local _, numQuests = GetNumQuestLogEntries()

local defaults = {
	profile = {
		anchorPoint = "TOPRIGHT",
		xOffset = 0,
		yOffset = -200,
		maxHeight = 600,
		frameScrollbar = true,
		frameStrata = "LOW",
		
		bgr = "Solid",
		bgrColor = { r=0, g=0, b=0, a=0 },
		border = "無",
		borderColor = { r=1, g=0.82, b=0 },
		classBorder = false,
		borderAlpha = 1,
		borderThickness = 16,
		bgrInset = 4,
		
		font = LSM:GetDefault("font"),
		fontSize = 14,
		fontFlag = "",
		fontShadow = 1,
		colorDifficulty = false,
		textWordWrap = false,
		objNumSwitch = false,

		hdrBgr = 2,
		hdrBgrColor = { r=1, g=0.82, b=0 },
		hdrBgrColorShare = false,
		hdrTxtColor = { r=1, g=0.82, b=0 },
		hdrTxtColorShare = false,
		hdrBtnColor = { r=1, g=0.82, b=0 },
		hdrBtnColorShare = false,
		hdrQuestsTitleAppend = true,
		hdrAchievsTitleAppend = true,
		hdrPetTrackerTitleAppend = true,
		hdrCollapsedTxt = 3,
		hdrOtherButtons = true,
		keyBindMinimize = "",
		
		qiBgrBorder = false,
		qiXOffset = -5,
		qiActiveButton = false,

		hideEmptyTracker = false,
		collapseInInstance = false,
		tooltipShow = true,
		tooltipShowRewards = true,
		tooltipShowID = false,
        menuWowheadURL = true,
        menuWowheadURLModifier = "ALT",
		
		sink20OutputSink = "RaidWarning",
		sink20Sticky = false,

		modulesOrder = {
			"SCENARIO_CONTENT_TRACKER_MODULE",
			"AUTO_QUEST_POPUP_TRACKER_MODULE",
			"WORLD_QUEST_TRACKER_MODULE",
			"BONUS_OBJECTIVE_TRACKER_MODULE",
			"QUEST_TRACKER_MODULE",
			"ACHIEVEMENT_TRACKER_MODULE"
		},

		addonMasque = false,
		addonPetTracker = false,
		addonTomTom = false,
	},
	char = {
		collapsed = false,
	}
}

local options = {
	name = "|T"..mediaPath.."KT_logo:22:22:-1:7|t"..KT.title,
	type = "group",
	get = function(info) return db[info[#info]] end,
	args = {
		general = {
			name = "選項",
			type = "group",
			args = {
				sec0 = {
					name = "資訊",
					type = "group",
					inline = true,
					order = 0,
					args = {
						version = {
							name = "  |cffffd100版本:|r  "..KT.version,
							type = "description",
							width = "double",
							fontSize = "medium",
							order = 0.1,
						},
						slashCmd = {
							name = cBold.." /kt|r  |cff808080...............|r  切換 (展開/收起) 任務目標清單\n"..
									cBold.." /kt config|r  |cff808080...|r  顯示設定選項視窗\n",
							type = "description",
							width = "double",
							order = 0.3,
						},
						news = {
							name = "更新資訊",
							type = "execute",
							disabled = function()
								return not KT.Help:IsEnabled()
							end,
							func = function()
								KT.Help:ShowHelp(true)
							end,
							order = 0.2,
						},
						help = {
							name = "使用說明",
							type = "execute",
							disabled = function()
								return not KT.Help:IsEnabled()
							end,
							func = function()
								KT.Help:ShowHelp()
							end,
							order = 0.4,
						},
					},
				},
				sec1 = {
					name = "位置/大小",
					type = "group",
					inline = true,
					order = 1,
					args = {
						anchorPoint = {
							name = "對齊畫面",
							desc = "- 預設: "..defaults.profile.anchorPoint,
							type = "select",
							values = anchors,
							get = function()
								for k, v in ipairs(anchors) do
									if db.anchorPoint == v then
										return k
									end
								end
							end,
							set = function(_, value)
								db.anchorPoint = anchors[value]
								db.xOffset = 0
								db.yOffset = 0
								KT:MoveTracker()
							end,
							order = 1.1,
						},
						xOffset = {
							name = "水平位置",
							desc = "- 預設: "..defaults.profile.xOffset.."\n- 單位: 1",
							type = "range",
							min = 0,
							max = 0,
							step = 1,
							set = function(_, value)
								db.xOffset = value
								KT:MoveTracker()
							end,
							order = 1.2,
						},
						yOffset = {
							name = "垂直位置",
							desc = "- 預設: "..defaults.profile.yOffset.."\n- 單位: 2",
							type = "range",
							min = 0,
							max = 0,
							step = 2,
							set = function(_, value)
								db.yOffset = value
								KT:MoveTracker()
								KT:SetSize()
							end,
							order = 1.3,
						},
						maxHeight = {
							name = "最大高度",
							desc = "- 預設: "..defaults.profile.maxHeight.."\n- 單位: 2",
							type = "range",
							min = 100,
							max = 100,
							step = 2,
							set = function(_, value)
								db.maxHeight = value
								KT:SetSize()
							end,
							order = 1.4,
						},
						maxHeightNote = {
							name = cBold.."最大高度會隨著垂直位置而變動。\n"..
								" 內容較少 ... 任務目標清單高度會自動縮小。\n"..
								" 內容較多 ... 任務目標清單會啟用捲動功能。",
							type = "description",
							width = "double",
							order = 1.41,
						},
						frameScrollbar = {
							name = "顯示捲動指示軸",
							desc = "啟用捲動功能時顯示捲動指示軸，使用與邊框相同顏色。",
							type = "toggle",
							set = function()
								db.frameScrollbar = not db.frameScrollbar
								KTF.Bar:SetShown(db.frameScrollbar)
								KT:SetSize()
							end,
							order = 1.5,
						},
						frameStrata = {
							name = "框架層級",
							desc = "- 預設: "..defaults.profile.frameStrata,
							type = "select",
							values = strata,
							get = function()
								for k, v in ipairs(strata) do
									if db.frameStrata == v then
										return k
									end
								end
							end,
							set = function(_, value)
								db.frameStrata = strata[value]
								KTF:SetFrameStrata(strata[value])
								KTF.Buttons:SetFrameStrata(strata[value])
							end,
							order = 1.6,
						},
					},
				},
				sec2 = {
					name = "背景/邊框",
					type = "group",
					inline = true,
					order = 2,
					args = {
						bgr = {
							name = "背景材質",
							type = "select",
							dialogControl = "LSM30_Background",
							values = WidgetLists.background,
							set = function(_, value)
								db.bgr = value
								KT:SetBackground()
							end,
							order = 2.1,
						},
						bgrColor = {
							name = "背景顏色",
							type = "color",
							hasAlpha = true,
							get = function()
								return db.bgrColor.r, db.bgrColor.g, db.bgrColor.b, db.bgrColor.a
							end,
							set = function(_, r, g, b, a)
								db.bgrColor.r = r
								db.bgrColor.g = g
								db.bgrColor.b = b
								db.bgrColor.a = a
								KT:SetBackground()
							end,
							order = 2.2,
						},
						bgrNote = {
							name = cBold.." 使用自訂背景時\n 材質設為白色。",
							type = "description",
							width = "normal",
							order = 2.21,
						},
						border = {
							name = "邊框材質",
							type = "select",
							dialogControl = "LSM30_Border",
							values = WidgetLists.border,
							set = function(_, value)
								db.border = value
								KT:SetBackground()
								KT:MoveButtons()
							end,
							order = 2.3,
						},
						borderColor = {
							name = "邊框顏色",
							type = "color",
							disabled = function()
								return db.classBorder
							end,
							get = function()
								if not db.classBorder then
									SetSharedColor(db.borderColor)
								end
								return db.borderColor.r, db.borderColor.g, db.borderColor.b
							end,
							set = function(_, r, g, b)
								db.borderColor.r = r
								db.borderColor.g = g
								db.borderColor.b = b
								KT:SetBackground()
								KT:SetText()
								SetSharedColor(db.borderColor)
							end,
							order = 2.4,
						},
						classBorder = {
							name = "邊框使用 |cff%s職業顏色|r",
							type = "toggle",
							get = function(info)
								if db[info[#info]] then
									SetSharedColor(KT.classColor)
								end
								return db[info[#info]]
							end,
							set = function()
								db.classBorder = not db.classBorder
								KT:SetBackground()
								KT:SetText()
							end,
							order = 2.5,
						},
						borderAlpha = {
							name = "邊框透明度",
							desc = "- 預設: "..defaults.profile.borderAlpha.."\n- 單位: 0.05",
							type = "range",
							min = 0.1,
							max = 1,
							step = 0.05,
							set = function(_, value)
								db.borderAlpha = value
								KT:SetBackground()
							end,
							order = 2.6,
						},
						borderThickness = {
							name = "邊框粗細",
							desc = "- 預設: "..defaults.profile.borderThickness.."\n- 單位: 0.5",
							type = "range",
							min = 1,
							max = 24,
							step = 0.5,
							set = function(_, value)
								db.borderThickness = value
								KT:SetBackground()
							end,
							order = 2.7,
						},
						bgrInset = {
							name = "背景內縮",
							desc = "- 預設: "..defaults.profile.bgrInset.."\n- 單位: 0.5",
							type = "range",
							min = 0,
							max = 10,
							step = 0.5,
							set = function(_, value)
								db.bgrInset = value
								KT:SetBackground()
								KT:MoveButtons()
							end,
							order = 2.8,
						},
					},
				},
				sec3 = {
					name = "文字",
					type = "group",
					inline = true,
					order = 3,
					args = {
						font = {
							name = "字體",
							type = "select",
							dialogControl = "LSM30_Font",
							values = WidgetLists.font,
							set = function(_, value)
								db.font = value
								KT.forcedUpdate = true
								KT:SetText()
								ObjectiveTracker_Update()
								if PetTracker then
									PetTracker.Objectives:TrackingChanged()
								end
								KT.forcedUpdate = false
							end,
							order = 3.1,
						},
						fontSize = {
							name = "字體大小",
							type = "range",
							min = 8,
							max = 24,
							step = 1,
							set = function(_, value)
								db.fontSize = value
								KT.forcedUpdate = true
								KT:SetText()
								ObjectiveTracker_Update()
								if PetTracker then
									PetTracker.Objectives:TrackingChanged()
								end
								KT.forcedUpdate = false
							end,
							order = 3.2,
						},
						fontFlag = {
							name = "字體樣式",
							type = "select",
							values = flags,
							get = function()
								for k, v in pairs(flags) do
									if db.fontFlag == k then
										return k
									end
								end
							end,
							set = function(_, value)
								db.fontFlag = value
								KT.forcedUpdate = true
								KT:SetText()
								ObjectiveTracker_Update()
								if PetTracker then
									PetTracker.Objectives:TrackingChanged()
								end
								KT.forcedUpdate = false
							end,
							order = 3.3,
						},
						fontShadow = {
							name = "字體陰影",
							type = "toggle",
							get = function()
								return (db.fontShadow == 1)
							end,
							set = function(_, value)
								db.fontShadow = value and 1 or 0
								KT.forcedUpdate = true
								KT:SetText()
								ObjectiveTracker_Update()
								if PetTracker then
									PetTracker.Objectives:TrackingChanged()
								end
								KT.forcedUpdate = false
							end,
							order = 3.4,
						},
						colorDifficulty = {
							name = "使用難度顏色",
							desc = "任務標題的顏色代表難度。",
							type = "toggle",
							set = function()
								db.colorDifficulty = not db.colorDifficulty
								ObjectiveTracker_Update()
								QuestMapFrame_UpdateAll()
							end,
							order = 3.5,
						},
						textWordWrap = {
							name = "文字自動換行",
							desc = "較長的文字顯示成兩行，或是單行加上 ... 來省略。\n"..warning,
							type = "toggle",
							confirm = true,
							confirmText = warning,
							set = function()
								db.textWordWrap = not db.textWordWrap
								ReloadUI()
							end,
							order = 3.6,
						},
						objNumSwitch = {
							name = "目標數字在前面 "..beta,
							desc = "將目標數字移動至每行的最前方。 "..
								   cBold.."只適用於德文, 西班牙文, 法文和俄文。",
							descStyle = "inline",
							type = "toggle",
							width = "double",
							disabled = function()
								return not IsSpecialLocale()
							end,
							set = function()
								db.objNumSwitch = not db.objNumSwitch
								ObjectiveTracker_Update()
							end,
							order = 3.7,
						},
					},
				},
				sec4 = {
					name = "標題列",
					type = "group",
					inline = true,
					order = 4,
					args = {
						hdrBgrLabel = {
							name = " 材質",
							type = "description",
							width = "half",
							fontSize = "medium",
							order = 4.1,
						},
						hdrBgr = {
							name = "",
							type = "select",
							values = textures,
							get = function()
								for k, v in ipairs(textures) do
									if db.hdrBgr == k then
										return k
									end
								end
							end,
							set = function(_, value)
								db.hdrBgr = value
								KT:SetBackground()
							end,
							order = 4.11,
						},
						hdrBgrColor = {
							name = "顏色",
							desc = "設定標題列材質的顏色。",
							type = "color",
							width = "half",
							disabled = function()
								return (db.hdrBgr < 3 or db.hdrBgrColorShare)
							end,
							get = function()
								return db.hdrBgrColor.r, db.hdrBgrColor.g, db.hdrBgrColor.b
							end,
							set = function(_, r, g, b)
								db.hdrBgrColor.r = r
								db.hdrBgrColor.g = g
								db.hdrBgrColor.b = b
								KT:SetBackground()
							end,
							order = 4.12,
						},
						hdrBgrColorShare = {
							name = "使用邊框顏色",
							desc = "材質使用與邊框相同的顏色。",
							type = "toggle",
							disabled = function()
								return (db.hdrBgr < 3)
							end,
							set = function()
								db.hdrBgrColorShare = not db.hdrBgrColorShare
								KT:SetBackground()
							end,
							order = 4.13,
						},
						hdrTxtLabel = {
							name = " 文字",
							type = "description",
							width = "half",
							fontSize = "medium",
							order = 4.2,
						},
						hdrTxtColor = {
							name = "顏色",
							desc = "設定標題列文字的顏色。",
							type = "color",
							width = "half",
							disabled = function()
								KT:SetText()
								return (db.hdrBgr == 2 or db.hdrTxtColorShare)
							end,
							get = function()
								return db.hdrTxtColor.r, db.hdrTxtColor.g, db.hdrTxtColor.b
							end,
							set = function(_, r, g, b)
								db.hdrTxtColor.r = r
								db.hdrTxtColor.g = g
								db.hdrTxtColor.b = b
								KT:SetText()
							end,
							order = 4.21,
						},
						hdrTxtColorShare = {
							name = "使用邊框顏色",
							desc = "標題列文字使用與邊框相同的顏色。",
							type = "toggle",
							disabled = function()
								return (db.hdrBgr == 2)
							end,
							set = function()
								db.hdrTxtColorShare = not db.hdrTxtColorShare
								KT:SetText()
							end,
							order = 4.22,
						},
						hdrTxtSpacer = {
							name = " ",
							type = "description",
							width = "normal",
							order = 4.23,
						},
						hdrBtnLabel = {
							name = " 按鈕",
							type = "description",
							width = "half",
							fontSize = "medium",
							order = 4.3,
						},
						hdrBtnColor = {
							name = "顏色",
							desc = "設定所有標題列按鈕的顏色。",
							type = "color",
							width = "half",
							disabled = function()
								return db.hdrBtnColorShare
							end,
							get = function()
								return db.hdrBtnColor.r, db.hdrBtnColor.g, db.hdrBtnColor.b
							end,
							set = function(_, r, g, b)
								db.hdrBtnColor.r = r
								db.hdrBtnColor.g = g
								db.hdrBtnColor.b = b
								KT:SetBackground()
							end,
							order = 4.32,
						},
						hdrBtnColorShare = {
							name = "使用邊框顏色",
							desc = "所有標題列按鈕都使用與邊框相同的顏色。",
							type = "toggle",
							set = function()
								db.hdrBtnColorShare = not db.hdrBtnColorShare
								KT:SetBackground()
							end,
							order = 4.33,
						},
						hdrBtnSpacer = {
							name = " ",
							type = "description",
							width = "normal",
							order = 4.34,
						},
						sec4SpacerMid1 = {
							name = " ",
							type = "description",
							order = 4.35,
						},
						hdrQuestsTitleAppend = {
							name = "顯示任務數量",
							desc = "在任務標題中顯示任務數量。",
							type = "toggle",
							width = "normal+half",
							set = function()
								db.hdrQuestsTitleAppend = not db.hdrQuestsTitleAppend
								KT:SetQuestsHeaderText(true)
							end,
							order = 4.4,
						},
						hdrAchievsTitleAppend = {
							name = "顯示成就點數",
							desc = "在成就標題中顯示成就點數。",
							type = "toggle",
							width = "normal+half",
							set = function()
								db.hdrAchievsTitleAppend = not db.hdrAchievsTitleAppend
								KT:SetAchievsHeaderText(true)
							end,
							order = 4.5,
						},
						hdrPetTrackerTitleAppend = {	-- Addon - PetTracker
							name = "顯示已收藏的戰寵數量",
							desc = "在戰寵助手 PetTracker 的標題中顯示已收藏的戰寵數量。",
							type = "toggle",
							width = "normal+half",
							disabled = function()
								return not KT.AddonPetTracker.isLoaded
							end,
							set = function()
								db.hdrPetTrackerTitleAppend = not db.hdrPetTrackerTitleAppend
								KT.AddonPetTracker:SetPetsHeaderText(true)
							end,
							order = 4.6,
						},
						sec4SpacerMid2 = {
							name = " ",
							type = "description",
							order = 4.65,
						},
						hdrCollapsedTxtLabel = {
							name = " 最小化的\n 摘要文字",
							type = "description",
							width = "half",
							fontSize = "medium",
							order = 4.7,
						},
						hdrCollapsedTxt1 = {
							name = "無",
							type = "toggle",
							width = "half",
							get = function()
								return (db.hdrCollapsedTxt == 1)
							end,
							set = function()
								db.hdrCollapsedTxt = 1
								ObjectiveTracker_Update()
							end,
							order = 4.71,
						},
						hdrCollapsedTxt2 = {
							name = ("%d/%d"):format(numQuests, MAX_QUESTS),
							type = "toggle",
							width = "half",
							get = function()
								return (db.hdrCollapsedTxt == 2)
							end,
							set = function()
								db.hdrCollapsedTxt = 2
								ObjectiveTracker_Update()
							end,
							order = 4.72,
						},
						hdrCollapsedTxt3 = {
							name = ("%d/%d 任務"):format(numQuests, MAX_QUESTS),
							type = "toggle",
							get = function()
								return (db.hdrCollapsedTxt == 3)
							end,
							set = function()
								db.hdrCollapsedTxt = 3
								ObjectiveTracker_Update()
							end,
							order = 4.73,
						},
						hdrOtherButtons = {
							name = "顯示任務日誌和成就按鈕",
							type = "toggle",
							width = "double",
							set = function()
								db.hdrOtherButtons = not db.hdrOtherButtons
								KT:ToggleOtherButtons()
								KT:SetBackground()
							end,
							order = 4.8,
						},
						keyBindMinimize = {
							name = "按鍵 - 最小化按鈕",
							type = "keybinding",
							set = function(_, value)
								SetOverrideBinding(KTF, false, db.keyBindMinimize, nil)
								if value ~= "" then
									local key = GetBindingKey("EXTRAACTIONBUTTON1")
									if key == value then
										SetBinding(key)
										SaveBindings(GetCurrentBindingSet())
									end
									SetOverrideBindingClick(KTF, false, value, KTF.MinimizeButton:GetName())
								end
								db.keyBindMinimize = value
							end,
							order = 4.9,
						},
					},
				},
				sec5 = {
					name = "任務物品按鈕",
					type = "group",
					inline = true,
					order = 5,
					args = {
						qiBgrBorder = {
							name = "顯示按鈕區塊的背景和邊框",
							type = "toggle",
							width = "double",
							set = function()
								db.qiBgrBorder = not db.qiBgrBorder
								KT:SetBackground()
								KT:MoveButtons()
							end,
							order = 5.1,
						},
						qiXOffset = {
							name = "水平位置",
							type = "range",
							min = -10,
							max = 10,
							step = 1,
							set = function(_, value)
								db.qiXOffset = value
								KT:MoveButtons()
							end,
							order = 5.2,
						},
						qiActiveButton = {
							name = "啟用大型任務物品按鈕  "..beta,
							desc = "距離最近的任務的物品按鈕顯示為 \"額外快捷鍵\"。"..
								   cBold.."和 額外快捷鍵1 使用相同的快捷鍵。",
							descStyle = "inline",
							width = "double",
							type = "toggle",
							set = function()
								db.qiActiveButton = not db.qiActiveButton
								if db.qiActiveButton then
									KT.ActiveButton:Enable()
								else
									KT.ActiveButton:Disable()
								end
							end,
							order = 5.3,
						},
						keyBindActiveButton = {
							name = "按鍵 - 大型任務物品按鈕",
							type = "keybinding",
							disabled = function()
								return not db.qiActiveButton
							end,
							get = function()
								local key = GetBindingKey("EXTRAACTIONBUTTON1")
								return key
							end,
							set = function(_, value)
								local key = GetBindingKey("EXTRAACTIONBUTTON1")
								if key then
									SetBinding(key)
								end
								if value ~= "" then
									if db.keyBindMinimize == value then
										SetOverrideBinding(KTF, false, db.keyBindMinimize, nil)
										db.keyBindMinimize = ""
									end
									SetBinding(value, "EXTRAACTIONBUTTON1")
								end
								SaveBindings(GetCurrentBindingSet())
							end,
							order = 5.4,
						},
						addonMasqueLabel = {
							name = " 外觀選項 - 用於任務物品按鈕和大型任務物品按鈕",
							type = "description",
							width = "double",
							fontSize = "medium",
							order = 5.5,
						},
						addonMasqueOptions = {
							name = "按鈕外觀 Masque",
							type = "execute",
							disabled = function()
								return (not IsAddOnLoaded("Masque") or not db.addonMasque or not KT.AddonOthers:IsEnabled())
							end,
							func = function()
								SlashCmdList["MASQUE"]()
							end,
							order = 5.51,
						},
					},
				},
				sec6 = {
					name = "其他選項",
					type = "group",
					inline = true,
					order = 6,
					args = {
						trackerTitle = {
							name = cTitle.."目標清單",
							type = "description",
							fontSize = "medium",
							order = 6.1,
						},
						hideEmptyTracker = {
							name = "隱藏空的清單",
							type = "toggle",
							set = function()
								db.hideEmptyTracker = not db.hideEmptyTracker
								KT:ToggleEmptyTracker()
							end,
							order = 6.11,
						},
						collapseInInstance = {
							name = "副本中最小化",
							desc = "進入副本時將目標清單收合起來。注意: 啟用自動過濾時會展開清單。",
							type = "toggle",
							set = function()
								db.collapseInInstance = not db.collapseInInstance
							end,
							order = 6.12,
						},
						tooltipTitle = {
							name = "\n"..cTitle.."滑鼠提示",
							type = "description",
							fontSize = "medium",
							order = 6.2,
						},
						tooltipShow = {
							name = "顯示滑鼠提示",
							desc = "顯示任務/世界任務/成就/事件的滑鼠提示。",
							type = "toggle",
							set = function()
								db.tooltipShow = not db.tooltipShow
							end,
							order = 6.21,
						},
						tooltipShowRewards = {
							name = "顯示獎勵",
							desc = "在滑鼠提示內顯示任務獎勵 - 神兵之力、職業大廳資源、金錢、裝備...等。",
							type = "toggle",
							disabled = function()
								return not db.tooltipShow
							end,
							set = function()
								db.tooltipShowRewards = not db.tooltipShowRewards
							end,
							order = 6.22,
						},
						tooltipShowID = {
							name = "顯示 ID",
							desc = "在滑鼠提示內顯示任務/世界任務/成就的 ID。",
							type = "toggle",
							disabled = function()
								return not db.tooltipShow
							end,
							set = function()
								db.tooltipShowID = not db.tooltipShowID
							end,
							order = 6.23,
						},
						menuTitle = {
							name = "\n"..cTitle.."選單項目",
							type = "description",
							fontSize = "medium",
							order = 6.3,
						},
                        menuWowheadURL = {
							name = "Wowhead URL",
							desc = "在目標清單和任務記錄內顯示 Wowhead 網址選單項目。",
							type = "toggle",
							set = function()
								db.menuWowheadURL = not db.menuWowheadURL
							end,
							order = 6.31,
						},
                        menuWowheadURLModifier = {
							name = "Wowhead URL 點擊組合按鍵",
							type = "select",
							values = modifiers,
							get = function()
								for k, v in pairs(modifiers) do
									if db.menuWowheadURLModifier == k then
										return k
									end
								end
							end,
							set = function(_, value)
								db.menuWowheadURLModifier = value
							end,
							order = 6.32,
						},
					},
				},
				sec7 = {
					-- LibSink
				},
			},
		},
		modules = {
			name = "模組",
			type = "group",
			args = {
				sec1 = {
					name = "模組順序 "..beta,
					type = "group",
					inline = true,
					order = 1,
				},
			},
		},
		addons = {
			name = "支援插件",
			type = "group",
			args = {
				desc = {
					name = "|cff00d200綠色|r - 相容版本 - 這個版本經過測試並且已經支援。\n"..
							"|cffff0000紅色|r - 不相容版本 - 這個版本尚未經過測試，可能需要修改程式碼。\n"..
							"請回報任何問題。",
					type = "description",
					order = 0,
				},
				sec1 = {
					name = "插件",
					type = "group",
					inline = true,
					order = 1,
					args = {
						addonMasque = {
							name = "按鈕外觀 Masque",
							desc = "版本: %s\n\n支援更換任務物品按鈕外觀。",
							descStyle = "inline",
							type = "toggle",
							confirm = true,
							confirmText = warning,
							disabled = function()
								return (not IsAddOnLoaded("Masque") or not KT.AddonOthers:IsEnabled())
							end,
							set = function()
								db.addonMasque = not db.addonMasque
								ReloadUI()
							end,
							order = 1.2,
						},
						addonPetTracker = {
							name = "戰寵助手 PetTracker",
							desc = "版本: %s\n\n"..beta.." 完整支援區域寵物追蹤清單。",
							descStyle = "inline",
							type = "toggle",
							confirm = true,
							confirmText = warning,
							disabled = function()
								return not IsAddOnLoaded("PetTracker")
							end,
							set = function()
								db.addonPetTracker = not db.addonPetTracker
								PetTracker.Sets.HideTracker = not db.addonPetTracker
								ReloadUI()
							end,
							order = 1.3,
						},
						addonTomTom = {
							name = "箭頭導航 TomTom",
							desc = "版本: %s\n\n"..beta.." 支援新增/移除任務路線導引。",
							descStyle = "inline",
							type = "toggle",
							confirm = true,
							confirmText = warning,
							disabled = function()
								return not IsAddOnLoaded("TomTom")
							end,
							set = function()
								db.addonTomTom = not db.addonTomTom
								ReloadUI()
							end,
							order = 1.4,
						},
					},
				},
				sec2 = {
					name = "介面套裝插件",
					type = "group",
					inline = true,
					order = 2,
					args = {
						elvui = {
							name = "ElvUI",
							type = "toggle",
							disabled = true,
							order = 2.1,
						},
						tukui = {
							name = "Tukui",
							type = "toggle",
							disabled = true,
							order = 2.2,
						},
						nibrealui = {
							name = "RealUI",
							type = "toggle",
							disabled = true,
							order = 2.3,
						},
						syncui = {
							name = "SyncUI",
							type = "toggle",
							disabled = true,
							order = 2.4,
						},
						spartanui = {
							name = "SpartanUI",
							type = "toggle",
							disabled = true,
							order = 2.5,
						},
						svui = {
							name = "SuperVillain UI",
							type = "toggle",
							disabled = true,
							order = 2.6,
						},
					},
				},
			},
		},
	},
}

local general = options.args.general.args
local modules = options.args.modules.args
local addons = options.args.addons.args

function KT:CheckAddOn(addon, version, isUI)
	local name = strsplit("_", addon)
	local ver = isUI and "" or "---"
	local result = false
	local path
	if IsAddOnLoaded(addon) then
		local actualVersion = GetAddOnMetadata(addon, "Version") or "unknown"
		ver = isUI and "  -  " or ""
		ver = (ver.."|cff%s"..actualVersion.."|r"):format(actualVersion == version and "00d200" or "ff0000")
		result = true
	end
	if not isUI then
		path =  addons.sec1.args["addon"..name]
		path.desc = path.desc:format(ver)
	else
		local path =  addons.sec2.args[strlower(name)]
		path.name = path.name..ver
		path.disabled = not result
		path.get = function() return result end
	end
	return result
end

function KT:OpenOptions()
	InterfaceOptionsFrame_OpenToCategory(self.optionsFrame.profiles)
	InterfaceOptionsFrame_OpenToCategory(self.optionsFrame.profiles)
	InterfaceOptionsFrame_OpenToCategory(self.optionsFrame.general)
end

function KT:InitProfile(event, database, profile)
	ReloadUI()
end

function KT:SetupOptions()
	self.db = LibStub("AceDB-3.0"):New(strsub(addonName, 2).."DB", defaults, true)
	self.options = options
	db = self.db.profile
	dbChar = self.db.char

	general.sec2.args.classBorder.name = general.sec2.args.classBorder.name:format(RgbToHex(self.classColor))

	general.sec7 = self:GetSinkAce3OptionsDataTable()
	general.sec7.name = "輸出任務目標訊息"
	general.sec7.inline = true
	general.sec7.order = 7
	self:SetSinkStorage(db)

	options.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	options.args.profiles.confirm = true
	options.args.profiles.args.reset.confirmText = warning
	options.args.profiles.args.new.confirmText = warning
	options.args.profiles.args.choose.confirmText = warning
	options.args.profiles.args.copyfrom.confirmText = warning
	
	ACR:RegisterOptionsTable(addonName, options, nil)
	
	self.optionsFrame = {}
	self.optionsFrame.general = ACD:AddToBlizOptions(addonName, "任務-目標清單", nil, "general")
	self.optionsFrame.modules = ACD:AddToBlizOptions(addonName, options.args.modules.name, "任務-目標清單", "modules")
	self.optionsFrame.addons = ACD:AddToBlizOptions(addonName, options.args.addons.name, "任務-目標清單", "addons")
	self.optionsFrame.profiles = ACD:AddToBlizOptions(addonName, options.args.profiles.name, "任務-目標清單", "profiles")

	self.db.RegisterCallback(self, "OnProfileChanged", "InitProfile")
	self.db.RegisterCallback(self, "OnProfileCopied", "InitProfile")
	self.db.RegisterCallback(self, "OnProfileReset", "InitProfile")

	-- Disable some options
	if not IsSpecialLocale() then
		db.objNumSwitch = false
	end
end

KT.settings = {}
InterfaceOptionsFrame:HookScript("OnHide", function(self)
	for k, v in pairs(KT.settings) do
		if strfind(k, "Save") then
			KT.settings[k] = false
		else
			db[k] = v
		end
	end
	ACR:NotifyChange(addonName)
end)

function GetModulesOptionsTable()
	local numModules = #db.modulesOrder
	local text
	local args = {
		descCurOrder = {
			name = cTitle.."目前順序",
			type = "description",
			width = "double",
			fontSize = "medium",
			order = 0.1,
		},
		descDefOrder = {
			name = "|T:1:42|t"..cTitle.."預設順序",
			type = "description",
			width = "normal",
			fontSize = "medium",
			order = 0.2,
		},
		descModules = {
			name = "\n * "..TRACKER_HEADER_DUNGEON.." / "..CHALLENGE_MODE.." / "..TRACKER_HEADER_SCENARIO.." / "..TRACKER_HEADER_PROVINGGROUNDS.."\n",
			type = "description",
			order = 20,
		},
	}
	for i, module in ipairs(db.modulesOrder) do
		text = _G[module].Header.Text:GetText()
		if module == "SCENARIO_CONTENT_TRACKER_MODULE" then
			text = text.." *"
		elseif module == "AUTO_QUEST_POPUP_TRACKER_MODULE" then
			text = "彈出的"..text
		end
		args["pos"..i] = {
			name = " "..text,
			type = "description",
			width = "normal",
			fontSize = "medium",
			order = i,
		}
		args["pos"..i.."up"] = {
			name = (i > 1) and "上移" or " ",
			desc = text,
			type = (i > 1) and "execute" or "description",
			width = "half",
			func = function()
				MoveModule(i, "up")
			end,
			order = i + 0.1,
		}
		args["pos"..i.."down"] = {
			name = (i < numModules) and "下移" or " ",
			desc = text,
			type = (i < numModules) and "execute" or "description",
			width = "half",
			func = function()
				MoveModule(i)
			end,
			order = i + 0.2,
		}
		args["pos"..i.."default"] = {
			name = "|T:1:55|t|cff808080"..(OTF.MODULES_UI_ORDER[i] == AUTO_QUEST_POPUP_TRACKER_MODULE and "彈出的" or "")..OTF.MODULES_UI_ORDER[i].Header.Text:GetText()..(OTF.MODULES_UI_ORDER[i] == SCENARIO_CONTENT_TRACKER_MODULE and " *" or ""),
			type = "description",
			width = "normal",
			order = i + 0.3,
		}
	end
	return args
end

function MoveModule(idx, direction)
	local text = strsub(modules.sec1.args["pos"..idx].name, 2)
	local tmpIdx = (direction == "up") and idx-1 or idx+1
	local tmpText = strsub(modules.sec1.args["pos"..tmpIdx].name, 2)
	modules.sec1.args["pos"..tmpIdx].name = " "..text
	modules.sec1.args["pos"..tmpIdx.."up"].desc = text
	modules.sec1.args["pos"..tmpIdx.."down"].desc = text
	modules.sec1.args["pos"..idx].name = " "..tmpText
	modules.sec1.args["pos"..idx.."up"].desc = tmpText
	modules.sec1.args["pos"..idx.."down"].desc = tmpText

	local module = tremove(db.modulesOrder, idx)
	tinsert(db.modulesOrder, tmpIdx, module)

	module = tremove(OTF.MODULES_UI_ORDER, idx)
	tinsert(OTF.MODULES_UI_ORDER, tmpIdx, module)
	ObjectiveTracker_Update()
end

function SetSharedColor(color)
	local name = "使用邊框|cff"..RgbToHex(color).."顏色|r"
	local sec4 = general.sec4.args
	sec4.hdrBgrColorShare.name = name
	sec4.hdrTxtColorShare.name = name
	sec4.hdrBtnColorShare.name = name
end

function IsSpecialLocale()
	return (KT.locale == "deDE" or
			KT.locale == "esES" or
			KT.locale == "frFR" or
			KT.locale == "ruRU")
end

function DecToHex(num)
	local b, k, hex, d = 16, "0123456789abcdef", "", 0
	while num > 0 do
		d = fmod(num, b) + 1
		hex = strsub(k, d, d)..hex
		num = floor(num/b)
	end
	hex = (hex == "") and "0" or hex
	return hex
end

function RgbToHex(color)
	local r, g, b = DecToHex(color.r*255), DecToHex(color.g*255), DecToHex(color.b*255)
	r = (strlen(r) < 2) and "0"..r or r
	g = (strlen(g) < 2) and "0"..g or g
	b = (strlen(b) < 2) and "0"..b or b
	return r..g..b
end

local initFrame = CreateFrame("Frame")
initFrame:SetScript("OnEvent", function(self, event)
	modules.sec1.args = GetModulesOptionsTable()
	self:UnregisterEvent(event)
end)
initFrame:RegisterEvent("PLAYER_ENTERING_WORLD")