--[[
    https://uWow.biz/
    Author: Glazzer
]]

local _, NS = ...

if NS:IsSameLocale("ruRU") then
    local L = NS.L or NS:NewLocale()
    L.LOCALE_NAME = "ruRU"
    
    --> PROFILE
    L["PROFILE"] = "Профиль Mythic Plus Rating"

    L["CURRENT_SCORE"] = "Текущие очки"
    L["PREVIOUS_SCORE"] = "Очки предыдущего сезона"
    L["CURRENT_MAINS_SCORE"] = "Текущие очки мейна"
    L["HEAL_SCORE"] = "Очки целителя"
    L["TANK_SCORE"] = "Очки танка"
    L["DPS_SCORE"] = "Очки бойца"

    L["BEST_RUN"] = "Лучший проход"
    L["BEST_RUNS"] = "Лучшие прохождения"

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

    L["DUNGEON_NAME_EOA"] = "Око Азшары"
    L["DUNGEON_NAME_DHT"] = "Чаща Темного Сердца"
    L["DUNGEON_NAME_BRH"] = "Крепость Черной Ладьи"
    L["DUNGEON_NAME_HOV"] = "Чертоги Доблести"
    L["DUNGEON_NAME_NL"] = "Логово Нелтариона"
    L["DUNGEON_NAME_VOTW"] = "Казематы Стражей"
    L["DUNGEON_NAME_MOS"] = "Утроба душ"
    L["DUNGEON_NAME_ARC"] = "Катакомбы Сурамара"
    L["DUNGEON_NAME_COS"] = "Квартал Звезд"
    L["DUNGEON_NAME_LOWR"] = "Возвращение в Каражан: Нижний Ярус"
    L["DUNGEON_NAME_COEN"] = "Собор Вечной Ночи"
    L["DUNGEON_NAME_UPPR"] = "Возвращение в Каражан: Верхний Ярус"
    L["DUNGEON_NAME_SEAT"] = "Престол Триумвирата"

    L["COMPLETED_5_RUNS"] = "Пройдено 5-9"
    L["COMPLETED_10_RUNS"] = "Пройдено 10-14"
    L["COMPLETED_15_RUNS"] = "Пройдено 15-19"
    L["COMPLETED_20_RUNS"] = "Пройдено 20-24"
    L["COMPLETED_25_RUNS"] = "Пройдено 25-29"
    L["COMPLETED_30_RUNS"] = "Пройдено 30-34"
    L["COMPLETED_TOTAL_RUNS"] = "Всего"
    --< PROFILE

    --> LADDER
    L["RANK"] = "Ранг"
    L["PLAYER_NAME"] = "Имя игрока"
    L["SERVER_NAME"] = "Сервер"
    L["SCORE_COUNT"] = "Колличество очков"
    L["YOUR_RANK"] = "Ваш ранг"
    L["YOUR_RANK_UNK"] = "Чтобы попасть в ладдер Вам необходимо пройти любой ключ"
    --< LADDER

    --> BUTTONS
    L["BTN_MY_PROFILE"] = "Мой профиль"
    L["BTN_LADDER"] = "Ладдер"
    --< BUTTONS

    NS.L = L
end
