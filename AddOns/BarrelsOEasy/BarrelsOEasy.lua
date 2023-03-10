local BOEIconFrame = CreateFrame("Frame", "BOEIconFrame", UIParent);
local BarrelsFrame = CreateFrame("Frame");
local Buttons = {};
local SkullMarker = 8;
local CurrentMarker = SkullMarker;
local UsedMarkers = {};
local FrameShown = false;
local IsOnWorldQuest = false;
local BarrelQuests = {[45068]=true,[45069]=true,[45070]=true,[45071]=true,[45072]=true,};
local TexturePath = "Interface\\TargetingFrame\\UI-RaidTargetingIcons.blp";

local function AddButton(index, parent)
	Buttons[index] = CreateFrame("CheckButton", "Radio" .. index, BOEIconFrame, "UICheckButtonTemplate");
	local texture 	 = Buttons[index]:CreateTexture("BarrelsOEasyTarget" .. index);
	
	Buttons[index]:ClearAllPoints();
	Buttons[index]:SetWidth(32);
	Buttons[index]:SetHeight(32);
	Buttons[index]:SetFrameStrata("FULLSCREEN_DIALOG");
	
	if index < 9 then
		texture:SetTexture(TexturePath);
		texture:SetWidth(32);
		texture:SetHeight(32);
		texture:SetPoint("TOPRIGHT", Buttons[index], "TOPRIGHT", 30, 0);
	end
	
	if parent ~= nil then
		Buttons[index]:SetPoint("TOPLEFT", parent, "TOPLEFT", 10, -25);
	else
		Buttons[index]:SetPoint("BOTTOM", Buttons[index + 1], "BOTTOM", 0, -40);
	end
	
	if index > 4 then
			texture:SetTexCoord((0.25 * (index - 5)), (0.25 * (index - 4)), 0.25, 0.5);
	else
		texture:SetTexCoord((0.25 * (index - 1)), (0.25 * index), 0, 0.25);
	end

	Buttons[index]:SetScript("OnClick", function(self)
		local checkedIndex = 0;
	
		if self:GetChecked() then
			checkedIndex = self:GetName():sub(6);
		end
		
		for i = 1, 9 do
			Buttons[i]:SetChecked(false);
		end
		
		if checkedIndex ~= nil and tonumber(checkedIndex) ~= nil then
			Buttons[tonumber(checkedIndex)]:SetChecked(true);
		end
	end);
end

local function ToggleFrame()
	if not InCombatLockdown() then
		FrameShown = not FrameShown;
		
		if FrameShown then
			BOEIconFrame:Show();
		else
			print("標記圖示框架已經暫時隱藏，輸入 /boe hide 將它永遠停用，或是 /boe show 將它重新顯示。");
			BOEIconFrame:Hide();
		end
	end
end

BarrelsFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
BarrelsFrame:RegisterEvent("QUEST_ACCEPTED");
BarrelsFrame:RegisterEvent("QUEST_REMOVED");

BOEIconFrame:SetBackdrop({
      bgFile="Interface\\DialogFrame\\UI-DialogBox-Background", 
      edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border", 
      tile=1, tileSize=20, edgeSize=20, 
      insets={left=5, right=5, top=5, bottom=5}
})

BOEIconFrame:SetWidth(85)
BOEIconFrame:SetHeight(390)
BOEIconFrame:SetPoint("CENTER", UIParent)
BOEIconFrame:EnableMouse(true)
BOEIconFrame:SetMovable(true)
BOEIconFrame:RegisterForDrag("LeftButton")
BOEIconFrame:SetFrameStrata("FULLSCREEN_DIALOG")
BOEIconFrame:Hide()
BOEIconFrame:SetScript("OnDragStart", function(self) self:StartMoving() end)
BOEIconFrame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
BOEIconFrame:SetScript("OnMouseDown", BOEIconFrame.StartMoving)
BOEIconFrame:SetScript("OnMouseUp",	function(self, button)
					self:StopMovingOrSizing();
				    local from, _, to, x, y = self:GetPoint();
					BarrelsOEasyFrom = from;
					BarrelsOEasyTo = to;
					BarrelsOEasyX = x;
					BarrelsOEasyY = y;
					end);

					BOEIconFrame.Close = CreateFrame("Button", "BarrelsOEasyClose", BOEIconFrame, "UIPanelCloseButton")
BOEIconFrame.Close:SetWidth(25)
BOEIconFrame.Close:SetHeight(25)
BOEIconFrame.Close:SetPoint("TOPRIGHT", -3, -3)
BOEIconFrame.Close:SetScript("OnClick", function(self) ToggleFrame() end)

AddButton(9, BOEIconFrame);
AddButton(8);
AddButton(7);
AddButton(6);
AddButton(5);
AddButton(4);
AddButton(3);
AddButton(2);
AddButton(1);

BarrelsFrame:SetScript("OnEvent", function(self,event,arg1,arg2)
	if event == "PLAYER_ENTERING_WORLD" then
		if BarrelsOEasyShowFrame == nil then
			BarrelsOEasyShowFrame = true;
			local from, _, to, x, y = self:GetPoint();
			BarrelsOEasyFrom = from;
			BarrelsOEasyTo = to;
			BarrelsOEasyX = x;
			BarrelsOEasyY = y;
		end
		
		if BarrelsOEasyShowMessageCount == nil then
			BarrelsOEasyShowMessageCount = 0;
		end
		
		local questLogCount = GetNumQuestLogEntries();

		for i = 1, questLogCount do
			local title, _, _, _, _, _, _, questID  = GetQuestLogTitle(i);
			if BarrelQuests[questID] then
				self:RegisterEvent("UPDATE_MOUSEOVER_UNIT");
				CurrentMarker = SkullMarker;
				IsOnWorldQuest = true;
				
				if BarrelsOEasyShowFrame then
					BOEIconFrame:Show();
					FrameShown = true;
				end
			end
		end
		
		if BarrelsOEasyX ~= nil and BarrelsOEasyY ~= nil then
			BOEIconFrame:SetPoint(BarrelsOEasyFrom, UIParent, BarrelsOEasyTo, BarrelsOEasyX, BarrelsOEasyY);
		end
	elseif event == "QUEST_ACCEPTED" then
		if (arg1 and BarrelQuests[arg1]) or (arg2 and BarrelQuests[arg2]) then
			IsOnWorldQuest = true;
			
			if IsInGroup() then
				RaidNotice_AddMessage(RaidWarningFrame, "警告! 解這個世界任務的時候請 '不要組隊'，否則標記會被自動清除。", ChatTypeInfo["SYSTEM"]);
				DEFAULT_CHAT_FRAME:AddMessage("警告! 解這個世界任務的時候請 '不要組隊'，否則標記會被自動清除。", 1.0, 0.0, 0.0, ChatTypeInfo["RAID_WARNING"], 5);
			end
			
			if BarrelsOEasyShowMessageCount < 5 then
				RaidNotice_AddMessage(RaidWarningFrame, "請先開始玩第一輪，當桶子停止移動時，再將滑鼠指向桶子來上標記。", ChatTypeInfo["RAID_WARNING"]);
				BarrelsOEasyShowMessageCount = BarrelsOEasyShowMessageCount + 1;
			end
			 
			if BarrelsOEasyShowFrame then
				BOEIconFrame:Show();
				FrameShown = true;
			end
			
			self:RegisterEvent("UPDATE_MOUSEOVER_UNIT");
			CurrentMarker = SkullMarker;
		end
	elseif event == "QUEST_REMOVED" then
		if (arg1 and BarrelQuests[arg1]) or (arg2 and BarrelQuests[arg2]) then
			BOEIconFrame:Hide();
			IsOnWorldQuest = false;
			FrameShown = false;
			self:UnregisterEvent("UPDATE_MOUSEOVER_UNIT");
			CurrentMarker = SkullMarker;
		end
	elseif event == "UPDATE_MOUSEOVER_UNIT" then
		local guid = UnitGUID("mouseover");
		
		if guid ~= nil then
			local _,_,_,_,_,id,_ = strsplit("-", guid)
			if id == "115947" then
				if not UsedMarkers[guid] then
					UsedMarkers[guid] = CurrentMarker;
					CurrentMarker = CurrentMarker - 1;
					
					if CurrentMarker == 0 then
						CurrentMarker = SkullMarker;
					end
				end
				
				if GetRaidTargetIndex("mouseover") ~= UsedMarkers[guid] then
					SetRaidTarget("mouseover", UsedMarkers[guid]);
				end
			end
		end
	end
end)

SLASH_BarrelsOEasy1 = "/barrels";
SLASH_BarrelsOEasy2 = "/boe";

function SlashCmdList.BarrelsOEasy(command)
	if command == nil then
		return;
	end
	
	local lowered = command:lower();
	
	if lowered == "hide" then
		FrameShown = false;
		print("標記圖示框架已經永遠隱藏，輸入 /boe show 重新顯示框架。");
		BarrelsOEasyShowFrame = false;
		BOEIconFrame:Hide();
	elseif lowered == "show" then
		FrameShown = true;
		BarrelsOEasyShowFrame = true;
		BOEIconFrame:Show();
	end
end