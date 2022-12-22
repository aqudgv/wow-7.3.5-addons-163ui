--[[
    https://uWow.biz/
    Author: Glazzer
]]

local _, NS = ...

if NS:IsSameLocale("zhCN") then
    local L = NS.L or NS:NewLocale()
    L.LOCALE_NAME = "zhCN"
    
    --> PROFILE
    L["PROFILE"] = "Profile Mythic Plus Rating"

    L["CURRENT_SCORE"] = "Current M+ Score"
    L["PREVIOUS_SCORE"] = "Previous M+ Score"
    L["CURRENT_MAINS_SCORE"] = "Main's Current M+ Score"
    L["HEAL_SCORE"] = "Healer Score"
    L["TANK_SCORE"] = "Tank Score"
    L["DPS_SCORE"] = "DPS Score"

    L["BEST_RUN"] = "Best Run"
    L["BEST_RUNS"] = "Best Runs by Dungeon"

    L["DUNGEON_SHORT_NAME_EOA"] = "EOA"
    L["DUNGEON_SHORT_NAME_DHT"] = "DHT"
    L["DUNGEON_SHORT_NAME_BRH"] = "BRH"
    L["DUNGEON_SHORT_NAME_HOV"] = "HOV"
    L["DUNGEON_SHORT_NAME_NL"] = "NL"
    L["DUNGEON_SHORT_NAME_VOTW"] = "VOTW"
    L["DUNGEON_SHORT_NAME_MOS"] = "MOS"
    L["DUNGEON_SHORT_NAME_ARC"] = "ARC"
    L["DUNGEON_SHORT_NAME_COS"] = "COS"
    L["DUNGEON_SHORT_NAME_LOWR"] = "LOWR"
    L["DUNGEON_SHORT_NAME_COEN"] = "COEN"
    L["DUNGEON_SHORT_NAME_UPPR"] = "UPPR"
    L["DUNGEON_SHORT_NAME_SEAT"] = "SEAT"

    L["DUNGEON_NAME_EOA"] = "Eye of Azshara"
    L["DUNGEON_NAME_DHT"] = "Darkheart Thicket"
    L["DUNGEON_NAME_BRH"] = "Black Rook Hold"
    L["DUNGEON_NAME_HOV"] = "Halls of Valor"
    L["DUNGEON_NAME_NL"] = "Neltharion's Lair"
    L["DUNGEON_NAME_VOTW"] = "Vault of the Wardens"
    L["DUNGEON_NAME_MOS"] = "Maw of Souls"
    L["DUNGEON_NAME_ARC"] = "The Arcway"
    L["DUNGEON_NAME_COS"] = "Court of Stars"
    L["DUNGEON_NAME_LOWR"] = "Return to Karazhan: Lower"
    L["DUNGEON_NAME_COEN"] = "Cathedral of Eternal Night"
    L["DUNGEON_NAME_UPPR"] = "Return to Karazhan: Upper"
    L["DUNGEON_NAME_SEAT"] = "Seat of the Triumvirate"

    L["COMPLETED_5_RUNS"] = "Completed 5-9"
    L["COMPLETED_10_RUNS"] = "Completed 10-14"
    L["COMPLETED_15_RUNS"] = "Completed 15-19"
    L["COMPLETED_20_RUNS"] = "Completed 20-24"
    L["COMPLETED_25_RUNS"] = "Completed 25-29"
    L["COMPLETED_30_RUNS"] = "Completed 30-34"
    L["COMPLETED_TOTAL_RUNS"] = "Total Challenges Completed"
    --< PROFILE

    --> LADDER
    L["RANK"] = "Rank"
    L["PLAYER_NAME"] = "Player"
    L["SERVER_NAME"] = "Realm Name"
    L["SCORE_COUNT"] = "Number of Score"
    L["YOUR_RANK"] = "Your Rank"
    L["YOUR_RANK_UNK"] = "To get into the ladder you need to completed any key"
    --< LADDER

    --> BUTTONS
    L["BTN_MY_PROFILE"] = "My Profile"
    L["BTN_LADDER"] = "Ladder"
    --< BUTTONS
    
    NS.L = L
end
