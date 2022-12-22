NPCMark = LibStub('AceAddon-3.0'):NewAddon('NPCMark', 'AceEvent-3.0', 'AceConsole-3.0', 'AceTimer-3.0')
MAP_ADJACENT_DISTANCE = 20
local _, node_index;
local NPCMark_Loaded = false
local npc_name;
local _, engClass = UnitClass("player")
MAP_MARK_TEXTURE = {
	-- 职业训练师
	[MAP_MARK_PROF_DRUID] = "Interface\\AddOns\\NPCMark\\icon\\28",
	[MAP_MARK_PROF_HUNTER] = "Interface\\AddOns\\NPCMark\\icon\\29",
	[MAP_MARK_PROF_MAGE] = "Interface\\AddOns\\NPCMark\\icon\\26",
	[MAP_MARK_PROF_MONK] = "Interface\\AddOns\\NPCMark\\icon\\43",
	[MAP_MARK_PROF_PALADIN] = "Interface\\AddOns\\NPCMark\\icon\\33",
	[MAP_MARK_PROF_PRIEST] = "Interface\\AddOns\\NPCMark\\icon\\31",
	[MAP_MARK_PROF_ROGUE] = "Interface\\AddOns\\NPCMark\\icon\\27",
	[MAP_MARK_PROF_SHAMAN] = "Interface\\AddOns\\NPCMark\\icon\\30",
	[MAP_MARK_PROF_WARLOCK] = "Interface\\AddOns\\NPCMark\\icon\\32",
	[MAP_MARK_PROF_WARRIOR] = "Interface\\AddOns\\NPCMark\\icon\\25",
	[MAP_MARK_PROF_DEATHKNIGHT] = "Interface\\AddOns\\NPCMark\\icon\\34",
	[MAP_MARK_PROF_DEMONHUNTER] = "Interface\\AddOns\\NPCMark\\icon\\44",
	-- 专业训练师
	[MAP_MARK_PROF_ALCHE] = "Interface\\AddOns\\NPCMark\\icon\\2",
	[MAP_MARK_PROF_ARCHAEOLOGY] = "Interface\\AddOns\\NPCMark\\icon\\36",
	[MAP_MARK_PROF_BLACKSMITH] = "Interface\\AddOns\\NPCMark\\icon\\17",
	[MAP_MARK_PROF_COOKING] = "Interface\\AddOns\\NPCMark\\icon\\11",
	[MAP_MARK_PROF_ENCHANTING] = "Interface\\AddOns\\NPCMark\\icon\\19",
	[MAP_MARK_PROF_ENGINEERING] = "Interface\\AddOns\\NPCMark\\icon\\18",
	[MAP_MARK_PROF_FIRSTAID] = "Interface\\AddOns\\NPCMark\\icon\\1",
	[MAP_MARK_PROF_FISHING] = "Interface\\AddOns\\NPCMark\\icon\\20",
	[MAP_MARK_PROF_HERBALISM] = "Interface\\AddOns\\NPCMark\\icon\\21",
	[MAP_MARK_PROF_INSCRIPTION] = "Interface\\AddOns\\NPCMark\\icon\\9",
	[MAP_MARK_PROF_JEWEL] = "Interface\\AddOns\\NPCMark\\icon\\12",
	[MAP_MARK_PROF_LEATHERWORKING]= "Interface\\AddOns\\NPCMark\\icon\\22",
	[MAP_MARK_PROF_MINING] = "Interface\\AddOns\\NPCMark\\icon\\23",
	[MAP_MARK_PROF_RIDING] = "Interface\\AddOns\\NPCMark\\icon\\16",
	[MAP_MARK_PROF_SKINNING] = "Interface\\AddOns\\NPCMark\\icon\\13",
	[MAP_MARK_PROF_TAILORING] = "Interface\\AddOns\\NPCMark\\icon\\24",
	-- 其他NPC
	[MAP_MARK_DEMON] = "Interface\\AddOns\\NPCMark\\icon\\5", -- 恶魔训练师
	[MAP_MARK_PORTAL] = "Interface\\AddOns\\NPCMark\\icon\\15", -- 传送门训练师

	[MAP_MARK_AUCTION] = "Interface\\AddOns\\NPCMark\\icon\\7", -- 拍卖师
	[MAP_MARK_BANK] = "Interface\\AddOns\\NPCMark\\icon\\14", -- 银行职员
	[MAP_MARK_BARBER] = "Interface\\AddOns\\NPCMark\\icon\\8", -- 理发师
	[MAP_MARK_DUMMY] = "Interface\\AddOns\\NPCMark\\icon\\38", -- 训练假人
	[MAP_MARK_FLY] = "Interface\\AddOns\\NPCMark\\icon\\3", -- 飞行管理员
	[MAP_MARK_INN] = "Interface\\AddOns\\NPCMark\\icon\\35", -- 旅馆老板
	[MAP_MARK_REFORGE] = "Interface\\AddOns\\NPCMark\\icon\\40", -- 幻化师
	[MAP_MARK_STABLE] = "Interface\\AddOns\\NPCMark\\icon\\4", -- 兽栏管理员
	[MAP_MARK_TRAFFIC] = "Interface\\AddOns\\NPCMark\\icon\\45", -- 交通工具
	[MAP_MARK_TRANSFER] = "Interface\\AddOns\\NPCMark\\icon\\46", -- 特殊传送

	[MAP_MARK_FACTION] = "Interface\\AddOns\\NPCMark\\icon\\41", -- 派系军需官
	[MAP_MARK_GUILD] = "Interface\\AddOns\\NPCMark\\icon\\6", -- 工会商人
	[MAP_MARK_HEIRLOOM] = "Interface\\AddOns\\NPCMark\\icon\\37", -- 传家宝商人
	[MAP_MARK_QMGOLD] = "Interface\\AddOns\\NPCMark\\icon\\42", -- PVE军需官
	[MAP_MARK_QMHONOR] = "Interface\\AddOns\\NPCMark\\icon\\39", -- PVP军需官
	[MAP_MARK_VENDOR] = "Interface\\AddOns\\NPCMark\\icon\\10", -- 杂货商人
}

MAP_MARK_MAPPING = {
	[NPCM_ALCHE] = MAP_MARK_PROF_ALCHE,
	[NPCM_ARCHAEOLOGY] = MAP_MARK_PROF_ARCHAEOLOGY,
	[NPCM_BLACKSMITH] = MAP_MARK_PROF_BLACKSMITH,
	[NPCM_ENCHANTING] = MAP_MARK_PROF_ENCHANTING,
	[NPCM_ENGINEERING] = MAP_MARK_PROF_ENGINEERING,
	[NPCM_HERBALISM] = MAP_MARK_PROF_HERBALISM,
	[NPCM_INSCRIPTION] = MAP_MARK_PROF_INSCRIPTION,
	[NPCM_JEWEL] = MAP_MARK_PROF_JEWEL,
	[NPCM_LEATHERWORKING] = MAP_MARK_PROF_LEATHERWORKING,
	[NPCM_MINING] = MAP_MARK_PROF_MINING,
	[NPCM_SKINNING] = MAP_MARK_PROF_SKINNING,
	[NPCM_TAILORING] = MAP_MARK_PROF_TAILORING,
}

MAP_MARK_MAPPING_TABLE = {
	MAP_MARK_AUCTION,
	MAP_MARK_BANK,
	MAP_MARK_BARBER,
	MAP_MARK_DEMON,
	MAP_MARK_DUMMY,
	MAP_MARK_FACTION,
	MAP_MARK_FLY,
	MAP_MARK_GUILD,
	MAP_MARK_HEIRLOOM,
	MAP_MARK_INN,
	MAP_MARK_PORTAL,
	MAP_MARK_PROF_ALCHE,
	MAP_MARK_PROF_ARCHAEOLOGY,
	MAP_MARK_PROF_BLACKSMITH,
	MAP_MARK_PROF_COOKING,
	MAP_MARK_PROF_DEATHKNIGHT,
	MAP_MARK_PROF_DEMONHUNTER,
	MAP_MARK_PROF_DRUID,
	MAP_MARK_PROF_ENCHANTING,
	MAP_MARK_PROF_ENGINEERING,
	MAP_MARK_PROF_FIRSTAID,
	MAP_MARK_PROF_FISHING,
	MAP_MARK_PROF_HERBALISM,
	MAP_MARK_PROF_HUNTER,
	MAP_MARK_PROF_INSCRIPTION,
	MAP_MARK_PROF_JEWEL,
	MAP_MARK_PROF_LEATHERWORKING,
	MAP_MARK_PROF_MAGE,
	MAP_MARK_PROF_MONK,
	MAP_MARK_PROF_MINING,
	MAP_MARK_PROF_PALADIN,
	MAP_MARK_PROF_PRIEST,
	MAP_MARK_PROF_RIDING,
	MAP_MARK_PROF_ROGUE,
	MAP_MARK_PROF_SHAMAN,
	MAP_MARK_PROF_SKINNING,
	MAP_MARK_PROF_TAILORING,
	MAP_MARK_PROF_WARLOCK,
	MAP_MARK_PROF_WARRIOR,
	MAP_MARK_QMGOLD,
	MAP_MARK_QMHONOR,
	MAP_MARK_REFORGE,
	MAP_MARK_STABLE,
	MAP_MARK_TRAFFIC,
	MAP_MARK_TRANSFER,
	MAP_MARK_VENDOR,
}

NPCMARKMAPPINGDB = {
	[MAP_MARK_FLY1] = MAP_MARK_FLY,
	[MAP_MARK_FLY2] = MAP_MARK_FLY,
	[MAP_MARK_FLY3] = MAP_MARK_FLY,
	[MAP_MARK_FLY4] = MAP_MARK_FLY,
	[MAP_MARK_FLY5] = MAP_MARK_FLY,
	[MAP_MARK_FLY6] = MAP_MARK_FLY,
	[MAP_MARK_FLY7] = MAP_MARK_FLY,
	[MAP_MARK_FLY8] = MAP_MARK_FLY,
	[MAP_MARK_FLY9] = MAP_MARK_FLY,

	[MAP_MARK_PROF_FLYING] = MAP_MARK_PROF_RIDING,

	[MAP_MARK_AUCTION1] = MAP_MARK_AUCTION,
	[MAP_MARK_BANK1] = MAP_MARK_BANK,

	[MAP_MARK_HEIRLOOM1] = MAP_MARK_HEIRLOOM,
	[MAP_MARK_HEIRLOOM2] = MAP_MARK_HEIRLOOM,
	[MAP_MARK_QMHONOR1] = MAP_MARK_QMHONOR,

	[MAP_MARK_TRAFFIC1] = MAP_MARK_TRAFFIC,
	[MAP_MARK_TRAFFIC2] = MAP_MARK_TRAFFIC,
	[MAP_MARK_TRAFFIC3] = MAP_MARK_TRAFFIC,
	[MAP_MARK_TRANSFER1] = MAP_MARK_TRANSFER,
	[MAP_MARK_TRANSFER2] = MAP_MARK_TRANSFER,
}

local function GetMappedType(_type)
	if NPCMARKMAPPINGDB[_type] then
		return NPCMARKMAPPINGDB[_type]
	end
	for _,val in pairs(MAP_MARK_MAPPING_TABLE) do
		if string.find(_type,val) then
			NPCMARKMAPPINGDB[_type] = val
			return val
		end
	end
	return ""
end

-- 默认开关状态
local function InitConfig()
	NPCMarkDB = {}
	-- 职业训练师
	if _G["MAP_MARK_PROF_"..engClass] then
		--NPCMarkDB[_G["MAP_MARK_PROF_"..engClass]] = true
	end
	-- 专业训练师
	local skills = {GetProfessions()};
	for k, v in pairs(skills) do
		local skillName = GetProfessionInfo(v)
		local mapping = MAP_MARK_MAPPING[skillName]
		if mapping then
			NPCMarkDB[mapping] = true
		end
	end
	-- 其他NPC
	NPCMarkDB[MAP_MARK_AUCTION] = true
	NPCMarkDB[MAP_MARK_BANK] = true
	NPCMarkDB[MAP_MARK_BARBER] = false
	NPCMarkDB[MAP_MARK_DEMON] = false
	NPCMarkDB[MAP_MARK_DUMMY] = false
	NPCMarkDB[MAP_MARK_FACTION] = false
	NPCMarkDB[MAP_MARK_FLY] = false
	NPCMarkDB[MAP_MARK_GUILD] = false
	NPCMarkDB[MAP_MARK_HEIRLOOM] = false
	NPCMarkDB[MAP_MARK_INN] = true
	NPCMarkDB[MAP_MARK_PORTAL] = false
	NPCMarkDB[MAP_MARK_QMGOLD] = false
	NPCMarkDB[MAP_MARK_QMHONOR] = false
	NPCMarkDB[MAP_MARK_REFORGE] = false
	NPCMarkDB[MAP_MARK_STABLE] = false
	NPCMarkDB[MAP_MARK_TRAFFIC] = false
	NPCMarkDB[MAP_MARK_TRANSFER] = false
	NPCMarkDB[MAP_MARK_VENDOR] = false
end

function NPCM_ToggleEnable(switch)
	if ( switch == 1 ) then
		if (not NPCMark_Loaded) then
			hooksecurefunc("WorldMapFrame_UpdateMap", NPCMark_WorldMapFrameOnUpdate);
			--WorldMapFrame:HookScript("OnUpdate", NPCMark_WorldMapFrameOnUpdate);
			NPCMark_Loaded = true;
			if (WorldMapFrame:HasScript("OnShow")) then
				WorldMapFrame:HookScript("OnShow", NPCMark_WorldMapFrameOnShow);
			else
				WorldMapFrame:SetScript("OnShow", NPCMark_WorldMapFrameOnShow);
			end
		end

		NPCMark_Enable = 1;
	else
		NPCMark_Enable = nil;
	end
	NPCMark_WorldMapFrameOnUpdate()
end

-- 分组设置
local MapMarkDDTable = {
	[MAP_MARK_PROF] = {
		[MAP_MARK_PROF_DRUID] = {func = true},
		[MAP_MARK_PROF_HUNTER] = {func = true},
		[MAP_MARK_PROF_MAGE] = {func = true},
		[MAP_MARK_PROF_MONK] = {func = true},
		[MAP_MARK_PROF_PALADIN] = {func = true},
		[MAP_MARK_PROF_PRIEST] = {func = true},
		[MAP_MARK_PROF_ROGUE] = {func = true},
		[MAP_MARK_PROF_SHAMAN] = {func = true},
		[MAP_MARK_PROF_WARLOCK] = {func = true},
		[MAP_MARK_PROF_WARRIOR] = {func = true},
		[MAP_MARK_PROF_DEATHKNIGHT] = {func = true},
		[MAP_MARK_PROF_DEMONHUNTER] = {func = true},
		[MAP_MARK_DEMON] = { func = true },
		[MAP_MARK_PORTAL] = { func = true },
	},
	[MAP_MARK_SKILL] = {
		[MAP_MARK_PROF_ALCHE] = {func = true},
		[MAP_MARK_PROF_ARCHAEOLOGY] = {func = true},
		[MAP_MARK_PROF_BLACKSMITH] = {func = true},
		[MAP_MARK_PROF_COOKING] = {func = true},
		[MAP_MARK_PROF_ENCHANTING] = {func = true},
		[MAP_MARK_PROF_ENGINEERING] = {func = true},
		[MAP_MARK_PROF_FIRSTAID] = {func = true},
		[MAP_MARK_PROF_FISHING] = {func = true},
		[MAP_MARK_PROF_HERBALISM] = {func = true},
		[MAP_MARK_PROF_INSCRIPTION] = {func = true},
		[MAP_MARK_PROF_JEWEL] = {func = true},
		[MAP_MARK_PROF_LEATHERWORKING] = {func = true},
		[MAP_MARK_PROF_MINING] = {func = true},
		[MAP_MARK_PROF_RIDING] = { func = true },
		[MAP_MARK_PROF_SKINNING] = {func = true},
		[MAP_MARK_PROF_TAILORING] = {func = true},
	},
	[MAP_MARK_VENDORS] = {
		[MAP_MARK_FACTION] = { func = true },
		[MAP_MARK_GUILD] = { func = true },
		[MAP_MARK_HEIRLOOM] = { func = true },
		[MAP_MARK_QMHONOR] = { func = true },
		[MAP_MARK_QMGOLD] = { func = true },
		[MAP_MARK_VENDOR] = { func = true },
	},
	[MAP_MARK_AUCTION] = { func = true },
	[MAP_MARK_BANK] = { func = true },
	[MAP_MARK_BARBER] = { func = true },
	[MAP_MARK_DUMMY] = { func = true },
	[MAP_MARK_FLY] = { func = true },
	[MAP_MARK_INN] = { func = true },
	[MAP_MARK_REFORGE] = { func = true },
	[MAP_MARK_STABLE] = { func = true },
	[MAP_MARK_TRAFFIC] = { func = true },
	[MAP_MARK_TRANSFER] = { func = true },
}

local function menuClick(self, key)
    NPCMarkDB[key] = not NPCMarkDB[key]
    NPCMark_WorldMapFrameOnUpdate()
end
local function clearAll()
    table.wipe(NPCMarkDB)
    NPCMark_WorldMapFrameOnUpdate()
    UIDropDownMenu_RefreshAll(MapPlusDDList)
    UIDropDownMenu_SetText(MapPlusDDList,MAPMARK_TITLE)
end
local function menuChecked(button)
    return button.arg1 and NPCMarkDB[button.arg1]
end
function MapMarkDDInit(self,level)
	level = level or 1;
	if (level == 1) then
        local info = UIDropDownMenu_CreateInfo()
        info.text = "全部取消"
        info.keepShownOnClick = true
        info.func = clearAll
        UIDropDownMenu_AddButton(info, level)
        
		for key, subarray in pairs(MapMarkDDTable) do 
			local info = UIDropDownMenu_CreateInfo();
            info.keepShownOnClick = true
            info.isNotRadio = true
            info.arg1 = key
			if (MAP_MARK_TRANSFER == key) then -- 特殊传送
				info.text = MAP_MARK_SPECTRANS;
			else
				info.text = key;
			end
			if subarray.func then
				info.hasArrow = false;
				info.func = menuClick
				info.checked = menuChecked
                info.icon = MAP_MARK_TEXTURE[GetMappedType(key)]
			else
				info.hasArrow = true;
			    info.checked = menuChecked
                info.func = function(self, key)
                    NPCMarkDB[key] = not NPCMarkDB[key]
                    local subarray = MapMarkDDTable[key];
                    for subkey, subsubarray in pairs(subarray) do
                        if key == MAP_MARK_PROF or key == MAP_MARK_SKILL then
                            NPCMarkDB[subkey] = nil --如果是职业或专业,则在下面选择与自己相关的
                        else
                            NPCMarkDB[subkey] = NPCMarkDB[key]
                        end
                    end
                    if NPCMarkDB[key] then
                        if key == MAP_MARK_PROF then
                            NPCMarkDB[_G["MAP_MARK_PROF_"..engClass]] = true
                        elseif key == MAP_MARK_SKILL then
                            local skills = {GetProfessions()};
                            for k, v in pairs(skills) do
                                local skillName = GetProfessionInfo(v)
                                local mapping = MAP_MARK_MAPPING[skillName]
                                if mapping then
                                    NPCMarkDB[mapping] = true
                                end
                            end
                        end
                    end
                    UIDropDownMenu_RefreshAll(MapPlusDDList)
                    UIDropDownMenu_SetText(MapPlusDDList,MAPMARK_TITLE)
                    NPCMark_WorldMapFrameOnUpdate()
                end
				info.value = { ["Level1_Key"] = key; }; 
			end 
			UIDropDownMenu_AddButton(info, level);
		end
	end

	if (level == 2) then
		local Level1_Key = UIDROPDOWNMENU_MENU_VALUE["Level1_Key"];
		local subarray = MapMarkDDTable[Level1_Key];
		for key, subsubarray in pairs(subarray) do
			local info = UIDropDownMenu_CreateInfo();
            info.keepShownOnClick = true
            info.isNotRadio = true
            info.arg1 = key
            local texture = MAP_MARK_TEXTURE[GetMappedType(key)]
            info.icon = texture;
			info.hasArrow = false;
			if (MAP_MARK_FACTION == key) then -- 派系军需官
				info.text = MAP_MARK_FACTIONS .. key;
			elseif (MAP_MARK_VENDOR == key) then -- 杂货商人
				info.text = MAP_MARK_OTHERS .. key;
			else
				info.text = key;
			end
			info.func = menuClick
			info.checked = menuChecked
			UIDropDownMenu_AddButton(info, level);
		end
	end
end

function NPCMark_WorldMapFrameOnShow()
	if (not NPCMark_Enable) then
		MapPlusDDList:Hide()
		MapMarkCheckButton:Hide()
		return;
	end

	if not NPCMarkDB then
		InitConfig()
	end

	UIDropDownMenu_Initialize(MapPlusDDList,MapMarkDDInit)
	UIDropDownMenu_SetText(MapPlusDDList,MAPMARK_TITLE)
	MapPlusDDList:Show()
	MapMarkCheckButton:Show()
end

local function isSelected(type)
	if NPCMarkDB[GetMappedType(type)] then
		return true
	end

	return false
end

local function coord_transform(width,height,x,y)
	return x*width/100, -y*height/100
end

local function showNodes(_type,name,...)
	local function showNode(name,_type,x,y)
		local texture = MAP_MARK_TEXTURE[GetMappedType(_type) ]
		local button = _G["MapMark"..node_index]
		if not button then
			button = CreateFrame("Button", "MapMark"..node_index, WorldMapDetailFrame, "MapMarkTemplate")
		end
		button:SetPoint("CENTER",WorldMapDetailFrame,"TOPLEFT",coord_transform(WorldMapDetailFrame:GetWidth(), WorldMapDetailFrame:GetHeight(),x,y))
		_G[button:GetName().."Icon"]:SetTexture(texture);

		button.text2 = name
		button.text = _type
		node_index = node_index + 1
		button:Show()
	end
	local _coord = ...
	showNode(name,_type,_coord[1],_coord[2])
end

local function hideNodes()
	local _i = 1
	while _G["MapMark".._i] do
		_G["MapMark".._i]:Hide()
		_i = _i + 1
	end
end

local function getCurrentMapName()
	local mapId = GetCurrentMapZone()
	if mapId >0 then
		local currLevel = GetCurrentMapDungeonLevel();
		return select(mapId,GetMapZones(GetCurrentMapContinent())), currLevel; 
	end
end

local function checkLevel(nodes, curLevel)
	for _, node in pairs(nodes) do
		if (node[4] and node[4] == curLevel) then
			return true;
		end
	end

	return false;
end

function NPCMark_WorldMapFrameOnUpdate(self)
    if not NPCMarkDB then InitConfig() end
    if not WorldMapFrame:IsVisible() then return end
	hideNodes()
	if not NPCMark_Enable then
		return
	end
	if MapMarkHide then
		return
	end
	local mapID = GetCurrentMapAreaID();
	local currLevel = GetCurrentMapDungeonLevel();
	local mapName;
	if mapID == 473 then
		mapName = MAP_MARK_ShadowmoonValleyOUTLAND; -- 影月谷外域
	elseif mapID == 477 then
		mapName = MAP_MARK_NagrandOUTLAND; -- 纳格兰外域
	elseif mapID == 947 then
		mapName = MAP_MARK_ShadowmoonValleyDRAENOR; -- 影月谷德拉诺
	elseif mapID == 950 then
		mapName = MAP_MARK_NagrandDRAENOR; -- 纳格兰德拉诺
	else
		mapName = GetMapNameByID(mapID);
	end

	if not MapPlusNodeData then
		return
	end
	node_index = 1
	if mapName and MapPlusNodeData[mapName] then
		local nodes = MapPlusNodeData[mapName]
		local bHasLvl = checkLevel(nodes, currLevel);
		for _,_node in pairs(nodes) do
			if isSelected(_node[1]) and ((not bHasLvl and not _node[4]) or  (_node[4] and _node[4] == currLevel)) then
				showNodes(_node[1],_node[2],select(3,unpack(_node)))
			end
		end
	end
end

function IsButtonsAdjacent(button1, button2)
	local cx1, cy1 = button1:GetCenter();
	local cx2, cy2 = button2:GetCenter();
	return ((cx1-cx2)^2 + (cy1-cy2)^2 <200)
end

function MapMarkPoint_OnEnter(self)
	local cx1, cy1 = self:GetCenter();
	local cx2 = self:GetParent():GetCenter();
	if ( cx1 > cx2 ) then
		NPCMTooltip:SetOwner(self, "ANCHOR_LEFT");
	else
		NPCMTooltip:SetOwner(self, "ANCHOR_RIGHT");
	end
	NPCMTooltip:AddLine(self.text)
	local font = _G["NPCMTooltipTextLeft"..NPCMTooltip:NumLines()]:GetFontObject()
	NPCMTooltip:AddLine(self.text2)
	_G["NPCMTooltipTextLeft"..NPCMTooltip:NumLines()]:SetTextColor(TOOLTIP_DEFAULT_COLOR.r, TOOLTIP_DEFAULT_COLOR.g, TOOLTIP_DEFAULT_COLOR.b)
	local _i = 1
	while _G["MapMark".._i] do
		local button = _G["MapMark".._i]
		if button:IsShown() and button ~= self and IsButtonsAdjacent(button,self) then
			NPCMTooltip:AddLine(" ")
			NPCMTooltip:AddLine(button.text)
			_G["NPCMTooltipTextLeft"..NPCMTooltip:NumLines()]:SetFontObject(font)
			NPCMTooltip:AddLine(button.text2)
			_G["NPCMTooltipTextLeft"..NPCMTooltip:NumLines()]:SetTextColor(TOOLTIP_DEFAULT_COLOR.r, TOOLTIP_DEFAULT_COLOR.g, TOOLTIP_DEFAULT_COLOR.b)
		end
		_i = _i + 1
    end
    NPCMTooltip:SetFrameStrata("TOOLTIP")
	NPCMTooltip:Show();
end

function MapMarkPoint_OnLeave(self)
	NPCMTooltip:Hide();
end

function MapMarkToggleEnable(tog)
	if tog then
		MapMarkHide = false
	else
		MapMarkHide = true
	end
    NPCMark_WorldMapFrameOnUpdate()
end

-- 求距离
function Distance(coord1,coord2)
	return (coord1[1]-coord2[1])^2 + (coord1[2]-coord2[2])^2
end

-- 判断是否相邻
function IsAdjacent(dbTable, entry)
	if not dbTable or not dbTable[GetMappedType(entry[1])] then
		return false
	end

	for _,_coord in pairs(dbTable[GetMappedType(entry[1])]) do
		if Distance(_coord,entry[3]) < MAP_ADJACENT_DISTANCE then
			return true
		end
	end
	return false
end

-- 缩小地图标记数据
function ReduceMap(_table)
	local tempDB = {}
	local outPut ={}
	for _,_entry in pairs(_table) do
		tempDB[GetMappedType(_entry[1])] = tempDB[GetMappedType(_entry[1])] or {}
		if not IsAdjacent(tempDB, _entry) then
			tinsert(tempDB[GetMappedType(_entry[1])], _entry[3])
			tinsert(outPut, _entry)
		end
	end
	return outPut
end

function NPCMark:ReduceData()
    if not MapPlusNodeData then return end
	for _name, _table in pairs(MapPlusNodeData) do
		MapPlusNodeData[_name]= ReduceMap(_table)
	end
end

function NPCMark:OnInitialize()
	self:ReduceData();
	NPCM_ToggleEnable(1)
end

function NPCMark:OnEnable()
	NPCM_ToggleEnable(1)
end

function NPCMark:OnDisable()
	NPCM_ToggleEnable(0)
end