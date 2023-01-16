--[[
    https://uWow.biz/
    Author: Glazzer
]]

local _, NS = ...

if NS:IsSameLocale("deDE") then
    local L = NS.L or NS:NewLocale()
    L.LOCALE_NAME = "deDE"
    
    --> PROFILE
    L["PROFILE"] = "Profile Mythic Plus Rating"

    L["CURRENT_SCORE"] = "Aktuelle M+ Punkte"
    L["PREVIOUS_SCORE"] = "Vorherige M+ Wertung"
    L["CURRENT_MAINS_SCORE"] = "Main's aktuelle M+ Wertung"
    L["HEAL_SCORE"] = "Heiler Wertung"
    L["TANK_SCORE"] = "Tank Wertung"
    L["DPS_SCORE"] = "DPS Wertung"

    L["BEST_RUN"] = "Beste Mythic+"
    L["BEST_RUNS"] = "Beste Mythic+ per Dungeon"

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

    L["DUNGEON_NAME_EOA"] = "Das Auge Azsharas"
    L["DUNGEON_NAME_DHT"] = "Das Finsterherzdickicht"
    L["DUNGEON_NAME_BRH"] = "Die Rabenwehr"
    L["DUNGEON_NAME_HOV"] = "Die Hallen der Tapferkeit"
    L["DUNGEON_NAME_NL"] = "Neltharions Hort"
    L["DUNGEON_NAME_VOTW"] = "Das Verlies der Wächterinnen"
    L["DUNGEON_NAME_MOS"] = "Der Seelenschlund"
    L["DUNGEON_NAME_ARC"] = "Der Arkus"
    L["DUNGEON_NAME_COS"] = "Der Hof der Sterne"
    L["DUNGEON_NAME_LOWR"] = "Rückkehr nach Karazhan: Unterer"
    L["DUNGEON_NAME_COEN"] = "Kathedrale der Ewigen Nacht"
    L["DUNGEON_NAME_UPPR"] = "Rückkehr nach Karazhan: Oberer"
    L["DUNGEON_NAME_SEAT"] = "Sitz des Triumvirats"

    L["COMPLETED_5_RUNS"] = "Abgeschlossen 5-9"
    L["COMPLETED_10_RUNS"] = "Abgeschlossen 10-14"
    L["COMPLETED_15_RUNS"] = "Abgeschlossen 15-19"
    L["COMPLETED_20_RUNS"] = "Abgeschlossen 20-24"
    L["COMPLETED_25_RUNS"] = "Abgeschlossen 25-29"
    L["COMPLETED_30_RUNS"] = "Abgeschlossen 30-34"
    L["COMPLETED_TOTAL_RUNS"] = "Insgesamt abgeschlossene Herausforderungen"
    --< PROFILE

    --> LADDER
    L["RANK"] = "Rang"
    L["PLAYER_NAME"] = "Spieler"
    L["SERVER_NAME"] = "Realm Name"
    L["SCORE_COUNT"] = "Wertung"
    L["YOUR_RANK"] = "Dein Rang"
    L["YOUR_RANK_UNK"] = "Um in die Rangliste zu gelangen, müssen Sie einen beliebigen Schlüssel abschließen"
    --< LADDER

    --> BUTTONS
    L["BTN_MY_PROFILE"] = "Mein Profil"
    L["BTN_LADDER"] = "Rangliste"
    --< BUTTONS
    
    NS.L = L
end
