local myname, ns = ...

local HandyNotes = LibStub("AceAddon-3.0"):GetAddon("HandyNotes", true)
if not HandyNotes then return end

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("HandyNotes", "AceEvent-3.0")
local Debug = core.Debug

local HBD = LibStub("HereBeDragons-1.0")

local db
-- local icon = "Interface\\Icons\\INV_Misc_Head_Dragon_01"
local icon, icon_mount, icon_partial, icon_mount_partial, icon_done, icon_mount_done

local nodes = {}
module.nodes = nodes

local handler = {}
do
	local currentLevel, currentZone
	local function should_show_mob(id)
		if db.hidden[id] or (ns.mobdb[id] and ns.mobdb[id].hidden) then
			return false
		end
		local quest, achievement = ns:CompletionStatus(id)
		if quest ~= nil and achievement ~= nil then
			-- we have a quest *and* an achievement; we're going to treat "show achieved" as "show achieved if I can still loot them"
			return (module.db.profile.questcomplete or not quest) and (module.db.profile.achieved or not achievement)
		end
		if quest ~= nil then
			return module.db.profile.questcomplete or not quest
		end
		if achievement ~= nil then
			return module.db.profile.achieved or not achievement
		end
		return module.db.profile.achievementless
	end
	local function icon_for_mob(id)
		if not icon then
			local function tex(atlas, r, g, b)
				local texture, _, _, left, right, top, bottom = GetAtlasInfo(atlas)
				return {
					icon = texture,
					tCoordLeft = left, tCoordRight = right, tCoordTop = top, tCoordBottom = bottom,
					r = r, g = g, b = b, a = 0.9,
				}
			end
			icon = tex("DungeonSkull", 1, 0.33, 0.33) -- red skull
			icon_partial = tex("DungeonSkull", 1, 1, 0.33) -- yellow skull
			icon_done = tex("DungeonSkull", 0.33, 1, 0.33) -- green skull
			icon_mount = tex("VignetteKillElite", 1, 0.33, 0.33) -- red shiny skull
			icon_mount_partial = tex("VignetteKillElite", 1, 1, 0.33) -- yellow shiny skull
			icon_mount_done = tex("VignetteKillElite", 0.33, 1, 0.33) -- green shiny skull
		end
		if not ns.mobdb[id] then
			return icon
		end
		local quest, achievement = ns:CompletionStatus(id)
		if quest or achievement then
			if (quest and achievement) or (quest == nil or achievement == nil) then
				-- full completion
				return ns.mobdb[id].mount and icon_mount_done or icon_done
			end
			-- partial completion
			return ns.mobdb[id].mount and icon_mount_partial or icon_partial
		end
		return ns.mobdb[id].mount and icon_mount or icon

		-- local achievement, name, completed = ns:AchievementMobStatus(id)
		-- if achievement and completed then
		-- 	return ns.mobdb[id].mount and icon_mount_found or icon_found
		-- end
	end
	local function iter(t, prestate)
		if not t then return nil end
		local state, value = next(t, prestate)
		while state do
			-- Debug("HandyNotes node", state, value, should_show_mob(value))
			if value then
				if should_show_mob(value) then
					return state, nil, icon_for_mob(value), db.icon_scale, db.icon_alpha
				end
			end
			state, value = next(t, state)
		end
		return nil, nil, nil, nil, nil
	end
	function handler:GetNodes(mapFile, minimap, level)
		-- Debug("HandyNotes GetNodes", mapFile, HBD:GetMapIDFromFile(mapFile), nodes[mapFile])
		currentZone = mapFile
		currentLevel = level
		return iter, nodes[mapFile], nil
	end
end

function handler:OnEnter(mapFile, coord)
	local tooltip = self:GetParent() == WorldMapButton and WorldMapTooltip or GameTooltip
	if self:GetCenter() > UIParent:GetCenter() then -- compare X coordinate
		tooltip:SetOwner(self, "ANCHOR_LEFT")
	else
		tooltip:SetOwner(self, "ANCHOR_RIGHT")
	end
	local zoneid = HBD:GetMapIDFromFile(mapFile)
	local id, name, questid, _, _, lastseen = core:GetMobByCoord(zoneid, coord)
	if not name then
		tooltip:AddLine(UNKNOWN)
		tooltip:AddDoubleLine("At", zoneid .. ':' .. coord)
		return tooltip:Show()
	end
	tooltip:AddLine(name)
	if ns.mobdb[id].notes then
		tooltip:AddDoubleLine("備註", ns.mobdb[id].notes)
	end

	tooltip:AddDoubleLine("最近看到", core:FormatLastSeen(lastseen))
	tooltip:AddDoubleLine("ID", id)

	ns:UpdateTooltipWithCompletion(tooltip, id)

	tooltip:Show()
end

function handler:OnLeave(mapFile, coord)
	if self:GetParent() == WorldMapButton then
		WorldMapTooltip:Hide()
	else
		GameTooltip:Hide()
	end
end

local clicked_zone, clicked_coord
local info = {}

local function hideMob(button, mapFile, coord)
	local zoneid = HBD:GetMapIDFromFile(mapFile)
	local id = core:GetMobByCoord(zoneid, coord)
	if id then
		db.hidden[id] = true
		module:SendMessage("HandyNotes_NotifyUpdate", "SilverDragon")
	end
end

local function createWaypoint(button, mapFile, coord)
	if TomTom then
		local mapId = HandyNotes:GetMapFiletoMapID(mapFile)
		local x, y = HandyNotes:getXY(coord)
		local id, name = core:GetMobByCoord(mapId, coord)
		TomTom:AddMFWaypoint(mapId, nil, x, y, {
			title = name,
			persistent = nil,
			minimap = true,
			world = true
		})
	end
end

local function generateMenu(button, level)
	if (not level) then return end
	table.wipe(info)
	if (level == 1) then
		-- Create the title of the menu
		info.isTitle      = 1
		info.text         = "地圖標記 - 稀有怪獸與牠們的產地"
		info.notCheckable = 1
		UIDropDownMenu_AddButton(info, level)

		if TomTom then
			-- Waypoint menu item
			info.disabled     = nil
			info.isTitle      = nil
			info.notCheckable = nil
			info.text = "建立路線導引"
			info.icon = nil
			info.func = createWaypoint
			info.arg1 = clicked_zone
			info.arg2 = clicked_coord
			UIDropDownMenu_AddButton(info, level);
		end

		-- Hide menu item
		info.disabled     = nil
		info.isTitle      = nil
		info.notCheckable = nil
		info.text = "隱藏這個怪獸"
		info.icon = icon
		info.func = hideMob
		info.arg1 = clicked_zone
		info.arg2 = clicked_coord
		UIDropDownMenu_AddButton(info, level);

		-- Close menu item
		info.text         = "關閉"
		info.icon         = nil
		info.func         = function() CloseDropDownMenus() end
		info.arg1         = nil
		info.notCheckable = 1
		UIDropDownMenu_AddButton(info, level);
	end
end

local dropdown = CreateFrame("Frame")
dropdown.displayMode = "MENU"
dropdown.initialize = generateMenu
function handler:OnClick(button, down, mapFile, coord)
	if button == "RightButton" and not down then
		clicked_zone = mapFile
		clicked_coord = coord
		ToggleDropDownMenu(1, nil, dropdown, self, 0, 0)
	end
end

function module:OnInitialize()
	self.db = core.db:RegisterNamespace("HandyNotes", {
		profile = {
			icon_scale = 1.0,
			icon_alpha = 1.0,
			achieved = true,
			questcomplete = false,
			achievementless = true,
			hidden = {},
		},
	})
	db = self.db.profile

	local options = {
		type = "group",
		name = "稀有怪",
		desc = "和牠們的產地",
		get = function(info) return db[info.arg] end,
		set = function(info, v)
			db[info.arg] = v
			module:SendMessage("HandyNotes_NotifyUpdate", "SilverDragon")
		end,
		args = {
			icon = {
				type = "group",
				name = "圖示設定",
				inline = true,
				args = {
					desc = {
						name = "這些設定控制圖示的外觀及風格。",
						type = "description",
						order = 0,
					},
					icon_scale = {
						type = "range",
						name = "圖示大小",
						desc = "圖示的縮放大小",
						min = 0.25, max = 2, step = 0.01,
						arg = "icon_scale",
						order = 20,
					},
					icon_alpha = {
						type = "range",
						name = "圖示透明度",
						desc = "圖示的透明度",
						min = 0, max = 1, step = 0.01,
						arg = "icon_alpha",
						order = 30,
					},
				},
			},
			display = {
				type = "group",
				name = "要顯示的內容",
				inline = true,
				args = {
					achieved = {
						type = "toggle",
						name = "顯示已達成的",
						desc = "是否要顯示你已經擊殺過的稀有怪圖示 (使用成就進度來判斷)",
						arg = "achieved",
						order = 10,
					},
					questcomplete = {
						type = "toggle",
						name = "顯示任務完成的",
						desc = "是否要顯示任務完成的稀有怪圖示 (表示牠們不會再掉落任何東西)",
						arg = "questcomplete",
						order = 15,
					},
					achievementless = {
						type = "toggle",
						name = "顯示和成就無關的",
						desc = "是否要顯示不屬於任何已知成就的稀有怪圖示",
						arg = "achievementless",
						width = "full",
						order = 20,
					},
					unhide = {
						type = "execute",
						name = "重置被隱藏的怪獸",
						desc = "顯示所有手動點右鍵選擇 '隱藏' 的標記。",
						func = function()
							wipe(db.hidden)
							module:SendMessage("HandyNotes_NotifyUpdate", "SilverDragon")
						end,
						order = 50,
					},
				},
			},
		},
	}

	local config = core:GetModule("Config", true)
	if config then
		config.options.plugins.handynotes = {
			handynotes = {
				type = "group",
				name = "地圖標記",
				get = options.get,
				set = options.set,
				args = options.args,
			},
		}
	end

	HandyNotes:RegisterPluginDB("稀有怪", handler, options)

	core.RegisterCallback(self, "Ready", "UpdateNodes")

	self:RegisterEvent("LOOT_CLOSED")
end

function module:UpdateNodes()
	wipe(nodes)
	for zone, mobs in pairs(ns.mobsByZone) do
		local mapFile = HBD:GetMapFileFromID(zone)
		Debug("UpdateNodes", zone, mapFile)
		if mapFile then
			nodes[mapFile] = {}
			for id, locs in pairs(mobs) do
				for _, loc in ipairs(locs) do
					nodes[mapFile][loc] = id
				end
			end
		else
			Debug("No mapfile for zone!", zone)
		end
	end
	self.nodes = nodes
	self:SendMessage("HandyNotes_NotifyUpdate", "SilverDragon")
end


function module:LOOT_CLOSED()
	self:SendMessage("HandyNotes_NotifyUpdate", "SilverDragon")
end
