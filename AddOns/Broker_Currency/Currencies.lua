-- ----------------------------------------------------------------------------
-- Localized globals
-- ----------------------------------------------------------------------------
local pairs = _G.pairs

-- ----------------------------------------------------------------------------
-- AddOn namespace
-- ----------------------------------------------------------------------------
local FOLDER_NAME, private = ...

-- ----------------------------------------------------------------------------
-- If you want to send id numbers for currencies which are missing, run this
-- while in-game.
-- ----------------------------------------------------------------------------
-- /script for id = 1, 10000 do local name = GetCurrencyInfo(id); if name and name ~= "" then print(("%d - %s"):format(id, name)) end end

-- ----------------------------------------------------------------------------
-- Currencies
-- ----------------------------------------------------------------------------
local CURRENCY_IDS_BY_NAME = {
	DALARAN_JEWELCRAFTERS_TOKEN = 61,
	EPICUREANS_AWARD = 81,
	CHAMPIONS_SEAL = 241,
	ILLUSTRIOUS_JEWELCRAFTERS_TOKEN = 361,
	DWARF_ARCHAEOLOGY_FRAGMENT = 384,
	TROLL_ARCHAEOLOGY_FRAGMENT = 385,
	TOL_BARAD_COMMENDATION = 391,
	FOSSIL_ARCHAEOLOGY_FRAGMENT = 393,
	NIGHTELF_ARCHAEOLOGY_FRAGMENT = 394,
	ORC_ARCHAEOLOGY_FRAGMENT = 397,
	DRAENEI_ARCHAEOLOGY_FRAGMENT = 398,
	VRYKUL_ARCHAEOLOGY_FRAGMENT = 399,
	NERUBIAN_ARCHAEOLOGY_FRAGMENT = 400,
	TOLVIR_ARCHAEOLOGY_FRAGMENT = 401,
	IRONPAW_TOKEN = 402,
	MARK_OF_THE_WORLD_TREE = 416,
	DARKMOON_PRIZE_TICKET = 515,
	MOTE_OF_DARKNESS = 614,
	ESSENCE_DEATHWING = 615,
	PANDAREN_ARCHAEOLOGY_FRAGMENT = 676,
	MOGU_ARCHAEOLOGY_FRAGMENT = 677,
	ELDER_CHARM_OF_GOOD_FORTUNE = 697,
	LESSER_CHARM_OF_GOOD_FORTUNE = 738,
	MOGU_RUNE_OF_FATE = 752,
	MANTID_ARCHAEOLOGY_FRAGMENT = 754,
	WARFORGED_SEAL = 776,
	TIMELESS_COIN = 777,
	BLOODY_COIN = 789,
	DRAENOR_CLANS_ARCHAEOLOGY_FRAGMENT = 821,
	APEXIS_CRYSTAL = 823,
	GARRISON_RESOURCES = 824,
	OGRE_ARCHAEOOGY_FRAGMENT = 828,
	ARAKKOA_ARCHAELOGOY_FRAGMENT = 829,
	SECRET_OF_DRAENOR_ALCHEMY = 910,
	ARTIFACT_FRAGMENT = 944,
	DINGY_IRON_COINS = 980,
	SEAL_OF_TEMPERED_FATE = 994,
	SECRET_OF_DRAENOR_TAILORING = 999,
	SECRET_OF_DRAENOR_JEWELCRAFTING = 1008,
	SECRET_OF_DRAENOR_LEATHERWORKING = 1017,
	SECRET_OF_DRAENOR_BLACKSMITHING = 1020,
	OIL = 1101,
	SEAL_OF_INEVITABLE_FATE = 1129,
	SIGHTLESS_EYE = 1149,
	ANCIENT_MANA = 1155,
	TIMEWARPED_BADGE = 1166,
	HIGHBORNE_ARCHAEOLOGY_FRAGMENT = 1172,
	HIGHMOUNTAIN_TAUREN_ARCHAEOLOGY_FRAGMENT = 1173,
	DEMONIC_ARCHAEOLOGY_FRAGMENT = 1174,
	VALOR = 1191,
	ORDER_RESOURCES = 1220,
	NETHERSHARD = 1226,
	TIMEWORN_ARTIFACT = 1268,
	SEAL_OF_BROKEN_FATE = 1273,
	CURIOUS_COIN = 1275,
	LINGERING_SOUL_FRAGMENT = 1314,
	LEGIONFALL_WAR_SUPPLIES = 1342,
	ECHOES_OF_BATTLE = 1356,
	ECHOES_OF_DOMINATION = 1357,
	TRIAL_OF_STYLE_TOKEN = 1379,
	COINS_OF_AIR = 1416,
	VEILED_ARGUNITE = 1508,
	WAKENING_ESSENCE = 1533,
}

private.CURRENCY_IDS_BY_NAME = CURRENCY_IDS_BY_NAME

local ITEM_CURRENCY_IDS_BY_NAME = {
	APEXIS_CRYSTAL = 32572,
	APEXIS_SHARD = 32569,
	BLACKFANG_CLAW = 124099,
	BLOOD_OF_SARGERAS = 124124,
	BREWFEST_PRIZE_TOKEN = 37829,
	COIN_OF_ANCESTRY = 21100,
	DOMINATION_POINT_COMMISSION = 91877,
	DRAENIC_SEEDS = 116053,
	HALAA_BATTLE_TOKEN = 26045,
	HALAA_RESEARCH_TOKEN = 26044,
	LIONS_LANDING_COMMISSION = 91838,
	LOVE_TOKEN = 49927,
	MARK_OF_HONOR = 137642,
	NATS_LUCKY_COIN = 117397,
	PET_CHARM = 116415,
	PRIMAL_SARGERITE = 151568,
	PRIMAL_SPIRIT = 120945,
	SPIRIT_SHARD = 28558,
}

local ITEM_CURRENCY_NAMES_BY_ID = {}
for name, ID in pairs(ITEM_CURRENCY_IDS_BY_NAME) do
	ITEM_CURRENCY_NAMES_BY_ID[ID] = name
end

private.ITEM_CURRENCY_NAMES_BY_ID = ITEM_CURRENCY_NAMES_BY_ID

local PVP_CURRENCY_IDS = {
	CURRENCY_IDS_BY_NAME.ARTIFACT_FRAGMENT,
	CURRENCY_IDS_BY_NAME.BLOODY_COIN,
	CURRENCY_IDS_BY_NAME.ECHOES_OF_BATTLE,
	CURRENCY_IDS_BY_NAME.ECHOES_OF_DOMINATION,
	CURRENCY_IDS_BY_NAME.SIGHTLESS_EYE,
	CURRENCY_IDS_BY_NAME.TOL_BARAD_COMMENDATION,
}

local BONUS_ROLL_CURRENCY_IDS = {
	CURRENCY_IDS_BY_NAME.ELDER_CHARM_OF_GOOD_FORTUNE,
	CURRENCY_IDS_BY_NAME.LESSER_CHARM_OF_GOOD_FORTUNE,
	CURRENCY_IDS_BY_NAME.MOGU_RUNE_OF_FATE,
	CURRENCY_IDS_BY_NAME.SEAL_OF_BROKEN_FATE,
	CURRENCY_IDS_BY_NAME.SEAL_OF_INEVITABLE_FATE,
	CURRENCY_IDS_BY_NAME.SEAL_OF_TEMPERED_FATE,
	CURRENCY_IDS_BY_NAME.WARFORGED_SEAL,
}

local MISCELLANEOUS_CURRENCY_IDS = {
	CURRENCY_IDS_BY_NAME.ANCIENT_MANA,
	CURRENCY_IDS_BY_NAME.DINGY_IRON_COINS,
	CURRENCY_IDS_BY_NAME.GARRISON_RESOURCES,
	CURRENCY_IDS_BY_NAME.NETHERSHARD,
	CURRENCY_IDS_BY_NAME.OIL,
	CURRENCY_IDS_BY_NAME.ORDER_RESOURCES,
	CURRENCY_IDS_BY_NAME.TIMELESS_COIN,
	CURRENCY_IDS_BY_NAME.TRIAL_OF_STYLE_TOKEN,
	CURRENCY_IDS_BY_NAME.VEILED_ARGUNITE,
	CURRENCY_IDS_BY_NAME.WAKENING_ESSENCE,
}

local PROFESSION_CURRENCY_IDS = {
	CURRENCY_IDS_BY_NAME.DALARAN_JEWELCRAFTERS_TOKEN,
	CURRENCY_IDS_BY_NAME.EPICUREANS_AWARD,
	CURRENCY_IDS_BY_NAME.ILLUSTRIOUS_JEWELCRAFTERS_TOKEN,
	CURRENCY_IDS_BY_NAME.IRONPAW_TOKEN,
	CURRENCY_IDS_BY_NAME.SECRET_OF_DRAENOR_ALCHEMY,
	CURRENCY_IDS_BY_NAME.SECRET_OF_DRAENOR_BLACKSMITHING,
	CURRENCY_IDS_BY_NAME.SECRET_OF_DRAENOR_JEWELCRAFTING,
	CURRENCY_IDS_BY_NAME.SECRET_OF_DRAENOR_LEATHERWORKING,
	CURRENCY_IDS_BY_NAME.SECRET_OF_DRAENOR_TAILORING,
}

local ARCHAEOLOGY_CURRENCY_IDS = {
	CURRENCY_IDS_BY_NAME.ARAKKOA_ARCHAELOGOY_FRAGMENT,
	CURRENCY_IDS_BY_NAME.DEMONIC_ARCHAEOLOGY_FRAGMENT,
	CURRENCY_IDS_BY_NAME.DRAENEI_ARCHAEOLOGY_FRAGMENT,
	CURRENCY_IDS_BY_NAME.DRAENOR_CLANS_ARCHAEOLOGY_FRAGMENT,
	CURRENCY_IDS_BY_NAME.DWARF_ARCHAEOLOGY_FRAGMENT,
	CURRENCY_IDS_BY_NAME.FOSSIL_ARCHAEOLOGY_FRAGMENT,
	CURRENCY_IDS_BY_NAME.HIGHBORNE_ARCHAEOLOGY_FRAGMENT,
	CURRENCY_IDS_BY_NAME.HIGHMOUNTAIN_TAUREN_ARCHAEOLOGY_FRAGMENT,
	CURRENCY_IDS_BY_NAME.MANTID_ARCHAEOLOGY_FRAGMENT,
	CURRENCY_IDS_BY_NAME.MOGU_ARCHAEOLOGY_FRAGMENT,
	CURRENCY_IDS_BY_NAME.NERUBIAN_ARCHAEOLOGY_FRAGMENT,
	CURRENCY_IDS_BY_NAME.NIGHTELF_ARCHAEOLOGY_FRAGMENT,
	CURRENCY_IDS_BY_NAME.OGRE_ARCHAEOOGY_FRAGMENT,
	CURRENCY_IDS_BY_NAME.ORC_ARCHAEOLOGY_FRAGMENT,
	CURRENCY_IDS_BY_NAME.PANDAREN_ARCHAEOLOGY_FRAGMENT,
	CURRENCY_IDS_BY_NAME.TOLVIR_ARCHAEOLOGY_FRAGMENT,
	CURRENCY_IDS_BY_NAME.TROLL_ARCHAEOLOGY_FRAGMENT,
	CURRENCY_IDS_BY_NAME.VRYKUL_ARCHAEOLOGY_FRAGMENT,
}

local ITEM_CURRENCY_IDS = {
	ITEM_CURRENCY_IDS_BY_NAME.APEXIS_CRYSTAL,
	ITEM_CURRENCY_IDS_BY_NAME.APEXIS_SHARD,
	ITEM_CURRENCY_IDS_BY_NAME.BLACKFANG_CLAW,
	ITEM_CURRENCY_IDS_BY_NAME.BLOOD_OF_SARGERAS,
	ITEM_CURRENCY_IDS_BY_NAME.BREWFEST_PRIZE_TOKEN,
	ITEM_CURRENCY_IDS_BY_NAME.COIN_OF_ANCESTRY,
	ITEM_CURRENCY_IDS_BY_NAME.DOMINATION_POINT_COMMISSION,
	ITEM_CURRENCY_IDS_BY_NAME.DRAENIC_SEEDS,
	ITEM_CURRENCY_IDS_BY_NAME.HALAA_BATTLE_TOKEN,
	ITEM_CURRENCY_IDS_BY_NAME.HALAA_RESEARCH_TOKEN,
	ITEM_CURRENCY_IDS_BY_NAME.LIONS_LANDING_COMMISSION,
	ITEM_CURRENCY_IDS_BY_NAME.LOVE_TOKEN,
	ITEM_CURRENCY_IDS_BY_NAME.MARK_OF_HONOR,
	ITEM_CURRENCY_IDS_BY_NAME.NATS_LUCKY_COIN,
	ITEM_CURRENCY_IDS_BY_NAME.PET_CHARM,
	ITEM_CURRENCY_IDS_BY_NAME.PRIMAL_SARGERITE,
	ITEM_CURRENCY_IDS_BY_NAME.PRIMAL_SPIRIT,
	ITEM_CURRENCY_IDS_BY_NAME.SPIRIT_SHARD,
}

local DUNGEONS_CURRENCY_IDS = {
	CURRENCY_IDS_BY_NAME.ESSENCE_DEATHWING,
	CURRENCY_IDS_BY_NAME.MOTE_OF_DARKNESS,
	CURRENCY_IDS_BY_NAME.TIMEWARPED_BADGE,
	CURRENCY_IDS_BY_NAME.VALOR,
}

local QUEST_OBJECTIVES_CURRENCY_IDS = {
	CURRENCY_IDS_BY_NAME.APEXIS_CRYSTAL,
	CURRENCY_IDS_BY_NAME.CHAMPIONS_SEAL,
	CURRENCY_IDS_BY_NAME.COINS_OF_AIR,
	CURRENCY_IDS_BY_NAME.CURIOUS_COIN,
	CURRENCY_IDS_BY_NAME.DARKMOON_PRIZE_TICKET,
	CURRENCY_IDS_BY_NAME.LEGIONFALL_WAR_SUPPLIES,
	CURRENCY_IDS_BY_NAME.LINGERING_SOUL_FRAGMENT,
	CURRENCY_IDS_BY_NAME.MARK_OF_THE_WORLD_TREE,
	CURRENCY_IDS_BY_NAME.TIMEWORN_ARTIFACT,
}

local ORDERED_CURRENCY_GROUPS = {
	ARCHAEOLOGY_CURRENCY_IDS,
	BONUS_ROLL_CURRENCY_IDS,
	DUNGEONS_CURRENCY_IDS,
	ITEM_CURRENCY_IDS,
	MISCELLANEOUS_CURRENCY_IDS,
	PROFESSION_CURRENCY_IDS,
	PVP_CURRENCY_IDS,
	QUEST_OBJECTIVES_CURRENCY_IDS,
}

private.ORDERED_CURRENCY_GROUPS = ORDERED_CURRENCY_GROUPS

local CURRENCY_GROUP_LABELS = {
	_G.PROFESSIONS_ARCHAEOLOGY,
	_G.BONUS_ROLL_TOOLTIP_TITLE,
	_G.DUNGEONS,
	_G.ITEMS,
	_G.MISCELLANEOUS,
	_G.TRADE_SKILLS,
	_G.PVP,
	_G.QUEST_OBJECTIVES,
}

private.CURRENCY_GROUP_LABELS = CURRENCY_GROUP_LABELS

local ORDERED_CURRENCY_IDS = {}
for groupIndex = 1, #ORDERED_CURRENCY_GROUPS do
	local group = ORDERED_CURRENCY_GROUPS[groupIndex]
	for idIndex = 1, #group do
		ORDERED_CURRENCY_IDS[#ORDERED_CURRENCY_IDS + 1] = group[idIndex]
	end
end

private.ORDERED_CURRENCY_IDS = ORDERED_CURRENCY_IDS
