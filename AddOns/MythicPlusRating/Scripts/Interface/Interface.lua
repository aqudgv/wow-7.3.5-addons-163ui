--[[
    https://uWow.biz/
    Author: Glazzer
]]

local _, NS = ...
local MPR = NS.MPR
local L = NS.L

local FALLBACK_FRAME = _G.UIParent
local FALLBACK_ANCHOR = _G.PVEFrame
local FALLBACK_ANCHOR_STRATA = "LOW"

local InterfaceGUI = CreateFrame("Frame")
do
    InterfaceGUI.Profile = CreateFrame("GameTooltip", MPR.AddonName .. "_ProfileTooltip", FALLBACK_FRAME, "GameTooltipTemplate")
    InterfaceGUI.Profile:SetClampedToScreen(true)
end

-- Buttons
do
    function InterfaceGUI:SwitchButtonState(button, disable)
        if button then
            if disable then
                button:SetAlpha(0.5)
                button.text:SetTextColor(0.7, 0.7, 0.7)
            else
                button:SetAlpha(1.0)
                button.text:SetTextColor(1, 0.8, 0)
            end
            button:SetEnabled(disable)
        end
    end

    InterfaceGUI.Buttons = {}
    InterfaceGUI.Buttons.ShowOwnerProfile = MPR:CreateButton(InterfaceGUI)
    InterfaceGUI.Buttons.ShowOwnerProfile:SetScript("OnClick", function()
        InterfaceGUI:ShowLadder()
    end)

    InterfaceGUI.Buttons.ShowLadder = MPR:CreateButton(InterfaceGUI)
    InterfaceGUI.Buttons.ShowLadder:SetScript("OnClick", function()
        InterfaceGUI:SwitchButtonState(InterfaceGUI.Buttons.ShowLadder, false)
        InterfaceGUI:SwitchButtonState(InterfaceGUI.Buttons.ShowOwnerProfile, true)
        InterfaceGUI:ShowProfile(false, MPR:GetNumberGUID(UnitGUID("player")), false)
    end)

    for _, button in pairs(InterfaceGUI.Buttons) do
        if button then
            button:SetNormalTexture("Interface\\chatframe\\chatframetab-bgmid.blp")
            button:SetHighlightTexture("Interface\\chatframe\\chatframetab-bgmid.blp")
            button.text = button:CreateFontString(nil, "ARTWORK") 
            button.text:SetFontObject("GameFontNormal")
        end
    end
end

-- Ladder
do
    InterfaceGUI.Ladder = CreateFrame("Frame")

    InterfaceGUI.Ladder.ScrollFrame = CreateFrame("ScrollFrame", "$parentScrollFrame", FALLBACK_FRAME, "UIPanelScrollFrameTemplate")
    InterfaceGUI.Ladder.ScrollFrame:SetClampedToScreen(true)
    InterfaceGUI.Ladder.ScrollFrame:SetBackdrop({ bgFile = "Interface/Tooltips/UI-Tooltip-Background", "Interface\\AddOns\\MythicPlusRating\\Icons\\Border.tga", tile = false, edgeSize = 8 })
    InterfaceGUI.Ladder.ScrollFrame:SetBackdropColor(0, 0, 0, 0.7)
    InterfaceGUI.Ladder.ScrollFrame:SetBackdropBorderColor(0.24, 0.25, 0.30, 1)
    InterfaceGUI.Ladder.ScrollFrame:SetPoint("TOP", 450, -55)
    InterfaceGUI.Ladder.ScrollFrame:SetSize(400, 400)
    InterfaceGUI.Ladder.ScrollFrame:SetShown(false)

    InterfaceGUI.Ladder.ScrollFrame.Container = CreateFrame("Frame", nil, InterfaceGUI)
    InterfaceGUI.Ladder.ScrollFrame.Container:SetPoint("TOP", 450, -55)
    InterfaceGUI.Ladder.ScrollFrame.Container:SetSize(400, 400)

    InterfaceGUI.Ladder.DecorationLine_1 = CreateFrame("Frame", nil, InterfaceGUI.Ladder.ScrollFrame)
    InterfaceGUI.Ladder.DecorationLine_1.texture = InterfaceGUI.Ladder.DecorationLine_1:CreateTexture(nil, "BACKGROUND")
    InterfaceGUI.Ladder.DecorationLine_1:ClearAllPoints();
    InterfaceGUI.Ladder.DecorationLine_1:SetPoint("TOPLEFT", InterfaceGUI.Ladder.ScrollFrame, 0, -2)
    InterfaceGUI.Ladder.DecorationLine_1:SetPoint("BOTTOMRIGHT", InterfaceGUI.Ladder.ScrollFrame, "TOPRIGHT", 0, 20)
    InterfaceGUI.Ladder.DecorationLine_1.texture:SetTexture("Interface\\QuestFrame\\UI-QuestLogTitleHighlight")
    InterfaceGUI.Ladder.DecorationLine_1.texture:SetAllPoints()
    InterfaceGUI.Ladder.DecorationLine_1.texture:SetColorTexture(1, 1, 1, 0.6)
    InterfaceGUI.Ladder.DecorationLine_1.texture:SetGradientAlpha("VERTICAL", 0.24, 0.25, 0.30, 1, 0.27, 0.28, 0.33, 1)
    InterfaceGUI.Ladder.DecorationLine_1:SetFrameStrata(FALLBACK_ANCHOR_STRATA)

    InterfaceGUI.Ladder.DecorationLine_2 = CreateFrame("Frame", nil, InterfaceGUI.Ladder.ScrollFrame)
    InterfaceGUI.Ladder.DecorationLine_2.texture = InterfaceGUI.Ladder.DecorationLine_2:CreateTexture(nil, "BACKGROUND")
    InterfaceGUI.Ladder.DecorationLine_2:ClearAllPoints();
    InterfaceGUI.Ladder.DecorationLine_2:SetPoint("BOTTOM", 0, -20)
    InterfaceGUI.Ladder.DecorationLine_2:SetPoint("TOPRIGHT", 0, -398)
    InterfaceGUI.Ladder.DecorationLine_2.texture:SetTexture("Interface\\QuestFrame\\UI-QuestLogTitleHighlight")
    InterfaceGUI.Ladder.DecorationLine_2.texture:SetAllPoints()
    InterfaceGUI.Ladder.DecorationLine_2.texture:SetColorTexture(1, 1, 1, 0.6)
    InterfaceGUI.Ladder.DecorationLine_2.texture:SetGradientAlpha("VERTICAL", 0.24, 0.25, 0.30, 1, 0.27, 0.28, 0.33, 1)
    InterfaceGUI.Ladder.DecorationLine_2:SetFrameStrata(FALLBACK_ANCHOR_STRATA)

    local height = InterfaceGUI.Ladder.ScrollFrame:GetHeight()
    local calc_h = height / 5

    InterfaceGUI.Ladder.ScrollFrame.Lines = {}
    for i = 1, 50 do
        if i == 1 then
            MPR:_CreateFrame(InterfaceGUI.Ladder.DecorationLine_1, "Text_1", 400, 18, "TOPLEFT", 5, -3-18*(i-1))
            MPR:CreateLine(InterfaceGUI.Ladder.DecorationLine_1.Text_1, "Number", "LEFT", 5, 0, 1, 1, 1, L.RANK)
            MPR:CreateLine(InterfaceGUI.Ladder.DecorationLine_1.Text_1, "Name", "LEFT", calc_h / 1.5, 0, 1, 1, 1, L.PLAYER_NAME)
            MPR:CreateLine(InterfaceGUI.Ladder.DecorationLine_1.Text_1, "Server", "LEFT", calc_h*2, 0, 1, 1, 1, L.SERVER_NAME)
            MPR:CreateLine(InterfaceGUI.Ladder.DecorationLine_1.Text_1, "Score", "RIGHT", -10, 0, 1, 1, 1, L.SCORE_COUNT)

            -- YOUR RANK
            MPR:_CreateFrame(InterfaceGUI.Ladder.DecorationLine_2, "Text_2", 400, 18, "TOPLEFT", 5, -5)
            MPR:CreateLine(InterfaceGUI.Ladder.DecorationLine_2.Text_2, "Number", "LEFT", 5, 0, 1, 1, 1, "")
            MPR:CreateLine(InterfaceGUI.Ladder.DecorationLine_2.Text_2, "Name", "LEFT", 360, 0, 1, 1, 1, "")
        end

        InterfaceGUI.Ladder.ScrollFrame.Lines[i] = CreateFrame("Frame", nil, InterfaceGUI.Ladder.ScrollFrame.Container)
        InterfaceGUI.Ladder.ScrollFrame.Lines[i]:SetSize(400, 18)
        InterfaceGUI.Ladder.ScrollFrame.Lines[i]:SetPoint("TOPLEFT", 5, -3-18*(i-1))

        MPR:CreateLine(InterfaceGUI.Ladder.ScrollFrame.Lines[i], "Number", "LEFT", 5, 0, 1, 1, 1, "")
        MPR:CreateLine(InterfaceGUI.Ladder.ScrollFrame.Lines[i], "Name", "LEFT", calc_h / 1.5, 0, 1, 1, 1, "")
        MPR:CreateLine(InterfaceGUI.Ladder.ScrollFrame.Lines[i], "Server", "LEFT", calc_h*2, 0, 1, 1, 1, "")
        MPR:CreateLine(InterfaceGUI.Ladder.ScrollFrame.Lines[i], "MiscInfo", "LEFT", calc_h*3, 0, 1, 1, 1, "") -- Race, Class, Fraction (Icons)
        MPR:CreateLine(InterfaceGUI.Ladder.ScrollFrame.Lines[i], "Score", "RIGHT", -10, 0, 1, 1, 1, "")

        InterfaceGUI.Ladder.ScrollFrame.Lines[i].FractionHeader = InterfaceGUI.Ladder.ScrollFrame.Lines[i]:CreateTexture(nil, "BACKGROUND")
        InterfaceGUI.Ladder.ScrollFrame.Lines[i].FractionHeader:SetPoint("LEFT", 0, 0)
        InterfaceGUI.Ladder.ScrollFrame.Lines[i].FractionHeader:SetPoint("RIGHT", 0, 0)
        InterfaceGUI.Ladder.ScrollFrame.Lines[i].FractionHeader:SetTexture("Interface\\QuestFrame\\UI-QuestLogTitleHighlight")
        InterfaceGUI.Ladder.ScrollFrame.Lines[i].FractionHeader:SetBlendMode("ADD")
        InterfaceGUI.Ladder.ScrollFrame.Lines[i].FractionHeader:Hide()

        InterfaceGUI.Ladder.ScrollFrame.Lines[i].AnimationHeader = InterfaceGUI.Ladder.ScrollFrame.Lines[i]:CreateTexture(nil, "BACKGROUND")
        InterfaceGUI.Ladder.ScrollFrame.Lines[i].AnimationHeader:SetPoint("LEFT", 0, 0)
        InterfaceGUI.Ladder.ScrollFrame.Lines[i].AnimationHeader:SetPoint("RIGHT", 0, 0)
        InterfaceGUI.Ladder.ScrollFrame.Lines[i].AnimationHeader:SetTexture("Interface\\QuestFrame\\UI-QuestLogTitleHighlight")
        InterfaceGUI.Ladder.ScrollFrame.Lines[i].AnimationHeader:SetBlendMode("ADD")
        InterfaceGUI.Ladder.ScrollFrame.Lines[i].AnimationHeader:Hide()

        InterfaceGUI.Ladder.ScrollFrame.Lines[i].Button = MPR:CreateButton(InterfaceGUI.Ladder.ScrollFrame.Lines[i], 380, 18, "LEFT", 0, 0)
        InterfaceGUI.Ladder.ScrollFrame.Lines[i].Button.PGuid = 0
        InterfaceGUI.Ladder.ScrollFrame.Lines[i].Button.PRealmId = 0
        InterfaceGUI.Ladder.ScrollFrame.Lines[i].Button:SetEnabled(false)
        InterfaceGUI.Ladder.ScrollFrame.Lines[i].Button:EnableMouse()
        InterfaceGUI.Ladder.ScrollFrame.Lines[i].Button:SetScript('OnEnter', function()
            InterfaceGUI.Ladder.ScrollFrame.Lines[i].AnimationHeader:Show()
        end)
        InterfaceGUI.Ladder.ScrollFrame.Lines[i].Button:SetScript('OnLeave', function()
            InterfaceGUI.Ladder.ScrollFrame.Lines[i].AnimationHeader:Hide()
        end)
        InterfaceGUI.Ladder.ScrollFrame.Lines[i].Button:SetScript('OnClick', function(self)
            if self then
                local guid = self.PGuid
                local realmId = self.PRealmId

                if guid and realmId then
                    InterfaceGUI:Request(false, false, guid, realmId, true)
                end
            end
        end)
    end

    InterfaceGUI.Ladder.ScrollFrame:SetScrollChild(InterfaceGUI.Ladder.ScrollFrame.Container)
    InterfaceGUI.Ladder.ScrollFrame:SetScript("OnMouseWheel", function(self, delta) 
        local value = self:GetVerticalScroll() - delta * 18
        if value < 0 then
            value = 0
        elseif value > self:GetVerticalScrollRange() then
            value = self:GetVerticalScrollRange()
        end

        self:SetVerticalScroll(value)
    end)
end

-- Cashe
do
    InterfaceGUI.Cashe_1 = {}
    InterfaceGUI.Cashe_2 = {}
    InterfaceGUI.Cashe_3 =
    {
        ["UIMSG_M_PLUS_LADDER_DATA"] = {}
    }
    InterfaceGUI.Cashe_3.TimeStamp = time()
    InterfaceGUI.Cashe_3.WaitResponse = true

    -- Check if there is a player cache (if not, create it)
    local function GUIDHasCashe(guid)
        if not InterfaceGUI.Cashe_1[guid] then
            InterfaceGUI.Cashe_1[guid] =
            {
                ["UIMSG_SCORE_DATA"] = {},
                ["UIMSG_BEST_RUN"] = {},
                ["UIMSG_COMPLETED_RUNS"] = {},
                ["UIMSG_BEST_RUNS"] = {},
                ["UIMSG_RANK_IN_LADDER"] = {}
            }
            InterfaceGUI.Cashe_1[guid].TimeStamp = 0
            InterfaceGUI.Cashe_1[guid].WaitResponse = true
            InterfaceGUI.Cashe_1[guid].ShowProfile = false
            InterfaceGUI.Cashe_1[guid].FromLadder = false
            InterfaceGUI.Cashe_1[guid].PacketsCount = 0
            return false
        end

        return true
    end

    local function CanOpenProfile(guid)
        return not InterfaceGUI.Profile:IsShown() and not InterfaceGUI.Ladder.ScrollFrame:IsShown() and not InterfaceGUI.Cashe_1[guid].WaitResponse
    end

    function InterfaceGUI:Request(ignoreCashe, showProfile, guid, realmId, fromLadder)
        if InterfaceGUI.Cashe_1[guid] and time() - InterfaceGUI.Cashe_1[guid].TimeStamp >= 300 then
            ignoreCashe = true
        end

        if not GUIDHasCashe(guid) or ignoreCashe then
            local _, realmName = UnitFullName("player")
            InterfaceGUI.Cashe_1[guid].WaitResponse = true
            MPR:SendPacket("UIMSG_M_PLUS_LADDER_DATA")
            MPR:SendPacket("UIMSG_M_PLUS_PROFILE_DATA", guid, realmName, realmId)
        end

        if showProfile then
            if not CanOpenProfile(guid) then
                InterfaceGUI.Cashe_1[guid].ShowProfile = showProfile
            else
                InterfaceGUI:ShowProfile(true, guid, false)
            end
        end

        if fromLadder then
            if InterfaceGUI.Cashe_1[guid].WaitResponse then
                InterfaceGUI.Cashe_1[guid].FromLadder = fromLadder
            else
                InterfaceGUI:ShowProfile(false, guid, true)
            end
        end
    end
end

-- Hooks
do
    local function WaitAllPackets(guid)
        InterfaceGUI.Cashe_1[guid].PacketsCount = InterfaceGUI.Cashe_1[guid].PacketsCount + 1
        if InterfaceGUI.Cashe_1[guid].PacketsCount >= 5 then
            InterfaceGUI.Cashe_1[guid].PacketsCount = 0
            InterfaceGUI.Cashe_1[guid].TimeStamp = time()
            InterfaceGUI.Cashe_1[guid].WaitResponse = false

            if InterfaceGUI.Cashe_1[guid].ShowProfile then
                InterfaceGUI.Cashe_1[guid].ShowProfile = false
                InterfaceGUI:ShowProfile(true, guid, false)
            end

            if InterfaceGUI.Cashe_1[guid].FromLadder then
                InterfaceGUI.Cashe_1[guid].FromLadder = false
                InterfaceGUI:ShowProfile(false, guid, true)
            end
        end
    end

    function InterfaceGUI:UIMSG_SCORE_DATA(data, guid)
        if data and #data > 0 then
            for i, arg in pairs(data) do
                InterfaceGUI.Cashe_1[guid]["UIMSG_SCORE_DATA"][i] = tonumber(arg)
            end
    
            WaitAllPackets(guid)
        end
    end

    function InterfaceGUI:UIMSG_BEST_RUN(data, guid)
        if data and #data > 0 then
            for i, arg in pairs(data) do
                InterfaceGUI.Cashe_1[guid]["UIMSG_BEST_RUN"][i] = tonumber(arg)
            end
    
            WaitAllPackets(guid)
        end
    end

    function InterfaceGUI:UIMSG_COMPLETED_RUNS(data, guid)
        if data and #data > 0 then
            for i, arg in pairs(data) do
                InterfaceGUI.Cashe_1[guid]["UIMSG_COMPLETED_RUNS"][i] = tonumber(arg)
            end
    
            WaitAllPackets(guid)
        end
    end

    function InterfaceGUI:UIMSG_BEST_RUNS(data, guid)
        if data and #data > 0 then
            for i, arg in pairs(data) do
                InterfaceGUI.Cashe_1[guid]["UIMSG_BEST_RUNS"][i] = tonumber(arg)
            end
    
            WaitAllPackets(guid)
        end
    end

    function InterfaceGUI:UIMSG_RANK_IN_LADDER(data, guid)
        if data and #data > 0 then
            for i, arg in pairs(data) do
                InterfaceGUI.Cashe_1[guid]["UIMSG_RANK_IN_LADDER"][i] = tonumber(arg)
            end
    
            WaitAllPackets(guid)
        end
    end

    function InterfaceGUI:UIMSG_M_PLUS_LADDER_DATA(data)
        if data and #data > 0 then
            for i, arg in pairs(data) do
                InterfaceGUI.Cashe_3["UIMSG_M_PLUS_LADDER_DATA"][i] = arg
            end

            InterfaceGUI.Cashe_3.TimeStamp = time()
            InterfaceGUI.Cashe_3.WaitResponse = false
        end
    end

    function InterfaceGUI:UIMSG_M_PLUS_MINI_PROFILE_DATA(data)
        if data and #data > 0 then
            local guid = tonumber(data[1])

            for i = 2, #data do
                InterfaceGUI.Cashe_2[guid][i-1] = tonumber(data[i])
            end

            InterfaceGUI.Cashe_2[guid].TimeStamp = time()
            InterfaceGUI.Cashe_2[guid].WaitResponse = false
        end
    end
end

-- Addon Windows
local SetAnchor
do
    local function IsFrame(widget)
		return type(widget) == "table" and type(widget.GetObjectType) == "function"
	end

    function SetAnchor(self, frame, frameStrata, x, y)
        if not x or not y then
            x = 0
            y = 0
        end

        frame = IsFrame(frame) and frame or FALLBACK_ANCHOR
        self:SetParent(frame or FALLBACK_ANCHOR)
        if self == InterfaceGUI.Profile then
		    self:SetOwner(frame, "ANCHOR_NONE")
        end
		self:ClearAllPoints()
		self:SetPoint("TOPLEFT", frame or FALLBACK_ANCHOR, "TOPRIGHT", x, y)
		self:SetFrameStrata(frameStrata or FALLBACK_ANCHOR_STRATA)
    end

    local function ShowButtons(fullReset, self)
        if not self then
            self = InterfaceGUI.Profile
        end
    
        local height, width = self:GetHeight(), self:GetWidth()
        local calcHeight, calcWidth = (height * -1), (width * -1) + 3
    
        local counter = 1
        for _, button in pairs(InterfaceGUI.Buttons) do
            if button then
                button:SetToplevel()
                button:SetParent(self)
                button:ClearAllPoints()
                if self == InterfaceGUI.Profile then
                    button:SetPoint("TOPLEFT", self, "TOPRIGHT", calcWidth, calcHeight + 18)
                else
                    button:SetPoint("TOPLEFT", InterfaceGUI.Ladder.DecorationLine_2, "TOPRIGHT", calcWidth-3, -7)
                end
    
                if fullReset then
                    button:SetAlpha(0.5)
                end
                button:SetSize(112, 40)
    
                if counter == 1 then
                    button.text:SetText(L.BTN_MY_PROFILE)
                    if fullReset then
                        button.text:SetTextColor(1, 0.8, 0)
                        button:SetEnabled(false)
                        button:SetAlpha(1.0)
                    end
                else
                    button.text:SetText(L.BTN_LADDER)
                    if fullReset then
                        button.text:SetTextColor(0.7, 0.7, 0.7)
                        button:SetEnabled(true)
                    end
                end
                button.text:SetPoint("CENTER", 0, -7)
    
                button:EnableMouse()
                button:SetScript('OnEnter', function() end)
                button:SetScript('OnLeave', function() end)
                button:SetShown(true)
    
                calcWidth = calcWidth + 114
                counter = counter + 1
            end
        end
    end

    function InterfaceGUI:ShowProfile(reset, guid, fromLadder)
        local var isHasChallengeInfo =
        {
            [197]   = false,
            [198]   = false,
            [199]   = false,
            [200]   = false,
            [206]   = false,
            [207]   = false,
            [208]   = false,
            [209]   = false,
            [210]   = false,
            [227]   = false,
            [233]   = false,
            [234]   = false,
            [239]   = false
        }

        if fromLadder then
            SetAnchor(InterfaceGUI.Profile, InterfaceGUI.Ladder.ScrollFrame, FALLBACK_ANCHOR_STRATA, 30, 20) 
        else
            SetAnchor(InterfaceGUI.Profile, FALLBACK_ANCHOR, FALLBACK_ANCHOR_STRATA)
        end

        InterfaceGUI.Profile:ClearLines()
        InterfaceGUI.Profile:AddLine(L.PROFILE, "", 0.85, 0, false)
    
        if InterfaceGUI.Cashe_1[guid]["UIMSG_SCORE_DATA"] and #InterfaceGUI.Cashe_1[guid]["UIMSG_SCORE_DATA"] > 0 then
            -- CURRENT_SCORE
            local scoreData = InterfaceGUI.Cashe_1[guid]["UIMSG_SCORE_DATA"]
            InterfaceGUI.Profile:AddDoubleLine(L.CURRENT_SCORE, MPR:GetRoleIcon(scoreData[2]) .. scoreData[1] .. " ", 1, 1, 1, MPR:GetScoreColor(scoreData[1], true))
    
            -- PREVIOUS_SCORE
            if scoreData[3] > 0 then
                InterfaceGUI.Profile:AddDoubleLine(L.PREVIOUS_SCORE, MPR:GetRoleIcon(scoreData[4]) .. scoreData[3] .. " ", 1, 1, 1, MPR:GetScoreColor(scoreData[3], true))
            end
    
            -- CURRENT_MAINS_SCORE
            if scoreData[5] > 0 then
                if scoreData[5] > scoreData[1] then
                    InterfaceGUI.Profile:AddDoubleLine(L.CURRENT_MAINS_SCORE, MPR:GetRoleIcon(scoreData[6]) .. scoreData[5] .. " ", 1, 1, 1, MPR:GetScoreColor(scoreData[5], true))
                end
            end
    
            -- HEAL_SCORE
            if scoreData[7] > 0 and (scoreData[8] > 0 or scoreData[9] > 0) then
                InterfaceGUI.Profile:AddDoubleLine(L.HEAL_SCORE, MPR:GetRoleIcon(2) .. scoreData[7] .. " ", 1, 1, 1, MPR:GetScoreColor(scoreData[7], true))
            end
            
            -- TANK_SCORE
            if scoreData[8] > 0 and (scoreData[7] > 0 or scoreData[9] > 0) then
                InterfaceGUI.Profile:AddDoubleLine(L.TANK_SCORE, MPR:GetRoleIcon(1) .. scoreData[8] .. " ", 1, 1, 1, MPR:GetScoreColor(scoreData[8], true))
            end
    
            -- DPS_SCORE
            if scoreData[9] > 0 and (scoreData[7] > 0 or scoreData[8] > 0) then
                InterfaceGUI.Profile:AddDoubleLine(L.DPS_SCORE, MPR:GetRoleIcon(4) .. scoreData[9] .. " ", 1, 1, 1, MPR:GetScoreColor(scoreData[9], true))
            end
        end
        
        if InterfaceGUI.Cashe_1[guid]["UIMSG_BEST_RUN"] and #InterfaceGUI.Cashe_1[guid]["UIMSG_BEST_RUN"] > 0 then
            local bestRun = InterfaceGUI.Cashe_1[guid]["UIMSG_BEST_RUN"]
            if bestRun[3] > 0 then
                InterfaceGUI.Profile:AddDoubleLine(L.BEST_RUN, MPR:StarValueToStringFormat(bestRun[1]) .. bestRun[2] .. " " .. MPR:GetChallengeName(bestRun[3], MPR.Config:Get("dungeonAbreviature")) .. " ", 1, 1, 1, 1, 1, 0)
            end
        end
    
        if InterfaceGUI.Cashe_1[guid]["UIMSG_COMPLETED_RUNS"] and #InterfaceGUI.Cashe_1[guid]["UIMSG_COMPLETED_RUNS"] > 0 then
            local totalRuns = 0
            local completedRuns = InterfaceGUI.Cashe_1[guid]["UIMSG_COMPLETED_RUNS"]
            
            if completedRuns[1] > 0 or completedRuns[1] > 0 or completedRuns[2] > 0 or completedRuns[3] > 0 or completedRuns[4] > 0 or completedRuns[5] > 0 or completedRuns[6] > 0 then
                InterfaceGUI.Profile:AddLine(" ")
            end

            -- Completed +5-9
            if completedRuns[1] > 0 then
                totalRuns = completedRuns[1]
                InterfaceGUI.Profile:AddDoubleLine(L.COMPLETED_5_RUNS, completedRuns[1] .. " ", 1, 1, 1, 1, 1, 1)
            end
    
            -- Completed +10-14
            if completedRuns[2] > 0 then
                totalRuns = totalRuns + completedRuns[2]
                InterfaceGUI.Profile:AddDoubleLine(L.COMPLETED_10_RUNS, completedRuns[2] .. " ", 1, 1, 1, 1, 1, 1)
            end
    
            -- Completed +15-19
            if completedRuns[3] > 0 then
                totalRuns = totalRuns + completedRuns[3]
                InterfaceGUI.Profile:AddDoubleLine(L.COMPLETED_15_RUNS, completedRuns[3] .. " ", 1, 1, 1, 1, 1, 1)
            end
    
            -- Completed +20-24
            if completedRuns[4] > 0 then
                totalRuns = totalRuns + completedRuns[4]
                InterfaceGUI.Profile:AddDoubleLine(L.COMPLETED_20_RUNS, completedRuns[4] .. " ", 1, 1, 1, 1, 1, 1)
            end
    
            -- Completed +25-29
            if completedRuns[5] > 0 then
                totalRuns = totalRuns + completedRuns[5]
                InterfaceGUI.Profile:AddDoubleLine(L.COMPLETED_25_RUNS, completedRuns[5] .. " ", 1, 1, 1, 1, 1, 1)
            end
    
            -- Completed +30-34
            if completedRuns[6] > 0 then
                totalRuns = totalRuns + completedRuns[6]
                InterfaceGUI.Profile:AddDoubleLine(L.COMPLETED_30_RUNS, completedRuns[6] .. " ", 1, 1, 1, 1, 1, 1)
            end

            -- Total
            if totalRuns > 0 then
                InterfaceGUI.Profile:AddDoubleLine(L.COMPLETED_TOTAL_RUNS, totalRuns .. " ", 1, 1, 1, 1, 1, 1)
            end
        end
    
        InterfaceGUI.Profile:AddLine(" ")
        InterfaceGUI.Profile:AddLine(L.BEST_RUNS, "", 0.85, 0, false)
    
        if InterfaceGUI.Cashe_1[guid]["UIMSG_BEST_RUNS"] and #InterfaceGUI.Cashe_1[guid]["UIMSG_BEST_RUNS"] > 0 then
            local bestRuns = InterfaceGUI.Cashe_1[guid]["UIMSG_BEST_RUNS"]
            for i = 1, #bestRuns, 5 do
                local challengeId = bestRuns[i]
                local roleMask = bestRuns[i+1]
                local stars = bestRuns[i+2]
                local keyLvl = bestRuns[i+3]
                local score = bestRuns[i+4]

                if challengeId and challengeId > 0 and roleMask and roleMask > 0 and keyLvl and keyLvl > 0 then
                    isHasChallengeInfo[challengeId] = true
                    if stars > 0 then
                        InterfaceGUI.Profile:AddDoubleLine(MPR:GetChallengeName(challengeId, MPR.Config:Get("dungeonAbreviature")), MPR:GetRoleIcon(roleMask) ..
                        MPR:StarValueToStringFormat(stars) .. "|cFFFFFFFF" .. keyLvl .. "|r " .. MPR:RGBToStringFormat(MPR:GetScoreColor(score, false)) .. score .. "|r ", 1, 1, 1)
                    else
                        InterfaceGUI.Profile:AddDoubleLine(MPR:GetChallengeName(challengeId, MPR.Config:Get("dungeonAbreviature")), MPR:GetRoleIcon(roleMask) ..
                        MPR:StarValueToStringFormat(stars) .. "|cFF9E9E9E" .. keyLvl .. "|r " .. MPR:RGBToStringFormat(MPR:GetScoreColor(score, false)) .. score .. "|r ", 0.62, 0.62, 0.62)
                    end
                end
            end
        end
    
        for i, v in pairs(isHasChallengeInfo) do
            if not v then
                InterfaceGUI.Profile:AddDoubleLine(MPR:GetChallengeName(i, MPR.Config:Get("dungeonAbreviature")), "- ", 0.62, 0.62, 0.62, 0.62, 0.62, 0.62)
            end
        end

        InterfaceGUI.Profile:AddLine(" ")
        if not reset and not fromLadder then
            InterfaceGUI.Ladder.ScrollFrame:SetShown(false)
        end
        InterfaceGUI.Profile:SetShown(true)
        if InterfaceGUI.Profile:GetWidth() < 230 then
            InterfaceGUI.Profile:SetWidth(230)
        end
        if not fromLadder then
            ShowButtons(reset)
        else
            ShowButtons(false, InterfaceGUI.Ladder.ScrollFrame)
        end
    end

    function InterfaceGUI:ShowLadder()
        local function Request()
            if not (InterfaceGUI.Cashe_3 and not InterfaceGUI.Cashe_3.WaitResponse) or (time() - InterfaceGUI.Cashe_3.TimeStamp >= 300) then
                MPR:SendPacket("UIMSG_M_PLUS_LADDER_DATA")
                InterfaceGUI.Cashe_3.WaitResponse = true
                return true
            elseif InterfaceGUI.Cashe_3 then
                return false
            end
        end

        local function SetLadderText(guid, position, name, realmId, classId, raceId, fractionId, roleMask, score)
            InterfaceGUI.Ladder.ScrollFrame.Lines[position].Button.PGuid = guid
            InterfaceGUI.Ladder.ScrollFrame.Lines[position].Button.PRealmId = realmId
            InterfaceGUI.Ladder.ScrollFrame.Lines[position].Button:SetEnabled(true)

            InterfaceGUI.Ladder.ScrollFrame.Lines[position].Number:SetText(tostring(position))
            InterfaceGUI.Ladder.ScrollFrame.Lines[position].Name:SetText(tostring(MPR:GetClassColor(classId) .. name .. "|r "))
            InterfaceGUI.Ladder.ScrollFrame.Lines[position].Server:SetText(tostring(MPR:GetRealmName(realmId)))
            InterfaceGUI.Ladder.ScrollFrame.Lines[position].MiscInfo:SetText(MPR:GetRoleIcon(roleMask))
            InterfaceGUI.Ladder.ScrollFrame.Lines[position].MiscInfo:SetPoint("LEFT", 270, 0)
            InterfaceGUI.Ladder.ScrollFrame.Lines[position].Score:SetText(tostring(score))
            InterfaceGUI.Ladder.ScrollFrame.Lines[position].Score:SetPoint("LEFT", 320, 0)
            InterfaceGUI.Ladder.ScrollFrame.Lines[position].Score:SetTextColor(MPR:GetScoreColor(score, true))

            if fractionId > 0 then
                if fractionId == 1 then     -- IsAliance
                    InterfaceGUI.Ladder.ScrollFrame.Lines[position].FractionHeader:SetGradientAlpha("VERTICAL", 0, 0, 1, 0.3, 0, 0, 1, 0.3)
                elseif fractionId == 2 then -- IsHorde
                    InterfaceGUI.Ladder.ScrollFrame.Lines[position].FractionHeader:SetGradientAlpha("VERTICAL", 1, 0, 0, 0.2, 1, 0, 0, 0.2)
                end

                InterfaceGUI.Ladder.ScrollFrame.Lines[position].FractionHeader:Show()
            end
        end

        local function EmptyRankInfo()
            InterfaceGUI.Ladder.DecorationLine_2.Text_2.Number:SetText(L.YOUR_RANK_UNK)
        end

        local function Show()
            if InterfaceGUI.Cashe_3["UIMSG_M_PLUS_LADDER_DATA"] and #InterfaceGUI.Cashe_3["UIMSG_M_PLUS_LADDER_DATA"] > 0 then
                local ladderData = InterfaceGUI.Cashe_3["UIMSG_M_PLUS_LADDER_DATA"]

                for i = 1, #ladderData, 9 do
                    local guid = tonumber(ladderData[i])
                    local position = tonumber(ladderData[i+1])
                    local name = tostring(ladderData[i+2])
                    local realmId = tonumber(ladderData[i+3])
                    local classId = tonumber(ladderData[i+4])
                    local raceId = tonumber(ladderData[i+5])
                    local fractionId = tonumber(ladderData[i+6])
                    local roleMask = tonumber(ladderData[i+7])
                    local score = tonumber(ladderData[i+8])

                    if guid and position and name and realmId and classId and raceId and fractionId and roleMask and score then
                        SetLadderText(guid, position, name, realmId, classId, raceId, fractionId, roleMask, score)
                    end
                end

                local guid = MPR:GetNumberGUID(UnitGUID("player"))
                if guid then
                    if InterfaceGUI.Cashe_1[guid]["UIMSG_BEST_RUNS"] and #InterfaceGUI.Cashe_1[guid]["UIMSG_BEST_RUNS"] > 0 then
                        if InterfaceGUI.Cashe_1[guid]["UIMSG_RANK_IN_LADDER"] and #InterfaceGUI.Cashe_1[guid]["UIMSG_RANK_IN_LADDER"] > 0 then
                            local rank = InterfaceGUI.Cashe_1[guid]["UIMSG_RANK_IN_LADDER"][1]
    
                            if rank and rank > 0 then
                                InterfaceGUI.Ladder.DecorationLine_2.Text_2.Number:SetText(L.YOUR_RANK)
                                InterfaceGUI.Ladder.DecorationLine_2.Text_2.Name:SetText(rank)
                            else
                                EmptyRankInfo()
                            end
                        else
                            EmptyRankInfo()
                        end
                    else
                        EmptyRankInfo()
                    end
                end

                InterfaceGUI.Profile:SetShown(false)
                InterfaceGUI.Ladder.ScrollFrame:SetShown(true)
                SetAnchor(InterfaceGUI.Ladder.ScrollFrame, FALLBACK_ANCHOR, FALLBACK_ANCHOR_STRATA)
                InterfaceGUI:SwitchButtonState(InterfaceGUI.Buttons.ShowOwnerProfile, false)
                InterfaceGUI:SwitchButtonState(InterfaceGUI.Buttons.ShowLadder, true)
                ShowButtons(false, InterfaceGUI.Ladder.ScrollFrame)
            end
        end

        if not Request() then
            Show()
        else
            C_Timer.After(0.1, Show)
        end
    end

    function InterfaceGUI:HideGUI()
        InterfaceGUI.Ladder.ScrollFrame:SetShown(false)
        InterfaceGUI.Profile:SetShown(false)

        for _, button in pairs(InterfaceGUI.Buttons) do
            if button and button:IsShown() then
                button:SetShown(false)
            end
        end
    end
end

-- Tooltips
do
    function InterfaceGUI:GetPlayerInfo(guid, realmName)
        if guid and MPR:IsNumber(guid) then
            if not (InterfaceGUI.Cashe_2[guid] and not InterfaceGUI.Cashe_2[guid].WaitResponse) or (time() - InterfaceGUI.Cashe_2[guid].TimeStamp >= 5) then
                if not InterfaceGUI.Cashe_2[guid] then
                    InterfaceGUI.Cashe_2[guid] = {}
                    InterfaceGUI.Cashe_2[guid].TimeStamp = time()
                end

                InterfaceGUI.Cashe_2[guid].WaitResponse = true
                MPR:SendPacket("UIMSG_M_PLUS_MINI_PROFILE_DATA", guid, realmName)
            else
                return InterfaceGUI.Cashe_2[guid]
            end
        end

        return nil
    end

    GameTooltip:HookScript("OnTooltipSetUnit", function(self)
        if self then
            if not MPR.Config:Get("enableUnitTooltip") then
                return
            end

            local _, unit = self:GetUnit()

            if unit and UnitIsPlayer(unit) then
                local guid = UnitGUID(unit)
                local _, realmName = UnitFullName(unit)

                if guid then
                    if not realmName then
                        local _, _realmName = UnitFullName("Player")
                        realmName = _realmName
                    end

                    if realmName then
                        local _guid = MPR:GetNumberGUID(guid)

                        if _guid then
                            local playerData = InterfaceGUI:GetPlayerInfo(_guid, realmName)

                            if playerData and #playerData > 0 then
                                local currentScore = playerData[1]
                                local previousScore = playerData[2]
                                local currentMainsScore = playerData[3]
                                local healScore = playerData[4]
                                local tankScore = playerData[5]
                                local dpsScore = playerData[6]

                                if currentScore > 0 or currentMainsScore > 0 then
                                    self:AddLine(" ")
                                    self:AddLine(MPR:RGBToStringFormat(1, 1, 1) .. L.PROFILE, "", 0.85, 0, false)
                                end

                                if currentScore > 0 then
                                    self:AddDoubleLine(L.CURRENT_SCORE, currentScore, 1, 1, 1, MPR:GetScoreColor(currentScore, true))
                                end

                                if previousScore > 0 then
                                    self:AddDoubleLine(L.PREVIOUS_SCORE, previousScore, 1, 1, 1, MPR:GetScoreColor(previousScore, true))
                                end

                                if currentMainsScore > 0 and (currentScore < currentMainsScore) then
                                    self:AddDoubleLine(L.CURRENT_MAINS_SCORE, currentMainsScore, 1, 1, 1, MPR:GetScoreColor(currentMainsScore, true))
                                end

                                if healScore > 0 and (tankScore > 0 or dpsScore > 0) then
                                    self:AddDoubleLine(L.HEAL_SCORE, healScore, 1, 1, 1, MPR:GetScoreColor(healScore, true))
                                end

                                if tankScore > 0 and (healScore > 0 or dpsScore > 0) then
                                    self:AddDoubleLine(L.TANK_SCORE, tankScore, 1, 1, 1, MPR:GetScoreColor(tankScore, true))
                                end

                                if dpsScore > 0 and (healScore > 0 or tankScore > 0) then
                                    self:AddDoubleLine(L.DPS_SCORE, dpsScore, 1, 1, 1, MPR:GetScoreColor(dpsScore, true))
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end

--[[
do
    local function Slash(msg)
        local playerGUID = nil

        if UnitIsPlayer("target") then
            playerGUID = UnitGUID("target")
            local _, realmName = UnitFullName("target")

            if playerGUID then
                if not realmName then
                    local _, _realmName = UnitFullName("Player")
                    realmName = _realmName
                end

                if realmName then
                    local _playerGUID = MPR:GetNumberGUID(playerGUID)

                    if _playerGUID then
                        InterfaceGUI:Request(false, false, _playerGUID, MPR:GetRealmID(realmName), true)
                    end
                end
            end
        else
            --//<
        end
    end

    SlashCmdList['MPR_CHECKMYTH'] = Slash
    SLASH_MPR_CHECKMYTH1 = '/checkMyth'
    SLASH_MPR_CHECKMYTH2 = '/ch'
end
]]

NS.INTERFACE_GUI = InterfaceGUI
