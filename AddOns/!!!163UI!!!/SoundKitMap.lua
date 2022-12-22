local map
function PlaySound163(file, ...)
    if not SOUNDKIT then
        PlaySound(file, ...)
    elseif file then
        local id = map[file:lower()]
        if id then
            PlaySound(id, ...)
        end
    end
end
map = {
  ["lootwindowcoinsound"] = 120, --LOOT_WINDOW_COIN_SOUND
  ["interfacesound_losttargetunit"] = 684, --INTERFACE_SOUND_LOST_TARGET_UNIT
  ["gstitleoptions"] = 778, --GS_TITLE_OPTIONS
  ["gstitlecredits"] = 790, --GS_TITLE_CREDITS
  ["gstitleoptionok"] = 798, --GS_TITLE_OPTION_OK
  ["gstitleoptionexit"] = 799, --GS_TITLE_OPTION_EXIT
  ["gslogin"] = 800, --GS_LOGIN
  ["gsloginnewaccount"] = 801, --GS_LOGIN_NEW_ACCOUNT
  ["gsloginchangerealmok"] = 805, --GS_LOGIN_CHANGE_REALM_OK
  ["gsloginchangerealmcancel"] = 807, --GS_LOGIN_CHANGE_REALM_CANCEL
  ["gscharacterselectionenterworld"] = 809, --GS_CHARACTER_SELECTION_ENTER_WORLD
  ["gscharacterselectiondelcharacter"] = 810, --GS_CHARACTER_SELECTION_DEL_CHARACTER
  ["gscharacterselectionacctoptions"] = 811, --GS_CHARACTER_SELECTION_ACCT_OPTIONS
  ["gscharacterselectionexit"] = 812, --GS_CHARACTER_SELECTION_EXIT
  ["gscharacterselectioncreatenew"] = 813, --GS_CHARACTER_SELECTION_CREATE_NEW
  ["gscharactercreationclass"] = 814, --GS_CHARACTER_CREATION_CLASS
  ["gscharactercreationlook"] = 817, --GS_CHARACTER_CREATION_LOOK
  ["gscharactercreationcreatechar"] = 818, --GS_CHARACTER_CREATION_CREATE_CHAR
  ["gscharactercreationcancel"] = 819, --GS_CHARACTER_CREATION_CANCEL
  ["igminimapopen"] = 821, --IG_MINIMAP_OPEN
  ["igminimapclose"] = 822, --IG_MINIMAP_CLOSE
  ["igminimapzoomin"] = 823, --IG_MINIMAP_ZOOM_IN
  ["igminimapzoomout"] = 824, --IG_MINIMAP_ZOOM_OUT
  ["igchatemotebutton"] = 825, --IG_CHAT_EMOTE_BUTTON
  ["igchatscrollup"] = 826, --IG_CHAT_SCROLL_UP
  ["igchatscrolldown"] = 827, --IG_CHAT_SCROLL_DOWN
  ["igchatbottom"] = 828, --IG_CHAT_BOTTOM
  ["igspellbookopen"] = 829, --IG_SPELLBOOK_OPEN
  ["igspellbookclose"] = 830, --IG_SPELLBOOK_CLOSE
  ["igabilityopen"] = 834, --IG_ABILITY_OPEN
  ["igabilityclose"] = 835, --IG_ABILITY_CLOSE
  ["igabiliitypageturn"] = 836, --IG_ABILITY_PAGE_TURN
  ["igabilityicondrop"] = 838, --IG_ABILITY_ICON_DROP
  ["igcharacterinfoopen"] = 839, --IG_CHARACTER_INFO_OPEN
  ["igcharacterinfoclose"] = 840, --IG_CHARACTER_INFO_CLOSE
  ["igcharacterinfotab"] = 841, --IG_CHARACTER_INFO_TAB
  ["igquestlogopen"] = 844, --IG_QUEST_LOG_OPEN
  ["igquestlogclose"] = 845, --IG_QUEST_LOG_CLOSE
  ["igquestlogabandonquest"] = 846, --IG_QUEST_LOG_ABANDON_QUEST
  ["igmainmenuopen"] = 850, --IG_MAINMENU_OPEN
  ["igmainmenuclose"] = 851, --IG_MAINMENU_CLOSE
  ["igmainmenuoption"] = 852, --IG_MAINMENU_OPTION
  ["igmainmenulogout"] = 853, --IG_MAINMENU_LOGOUT
  ["igmainmenuquit"] = 854, --IG_MAINMENU_QUIT
  ["igmainmenucontinue"] = 855, --IG_MAINMENU_CONTINUE
  ["igmainmenuoptioncheckboxon"] = 856, --IG_MAINMENU_OPTION_CHECKBOX_ON
  ["igmainmenuoptioncheckboxoff"] = 857, --IG_MAINMENU_OPTION_CHECKBOX_OFF
  ["igmainmenuoptionfaertab"] = 858, --IG_MAINMENU_OPTION_FAER_TAB
  ["iginventoryrotatecharacter"] = 861, --IG_INVENTORY_ROTATE_CHARACTER
  ["igbackpackopen"] = 862, --IG_BACKPACK_OPEN
  ["igbackpackclose"] = 863, --IG_BACKPACK_CLOSE
  ["igbackpackcoinselect"] = 864, --IG_BACKPACK_COIN_SELECT
  ["igbackpackcoinok"] = 865, --IG_BACKPACK_COIN_OK
  ["igbackpackcoincancel"] = 866, --IG_BACKPACK_COIN_CANCEL
  ["igcharacternpcselect"] = 867, --IG_CHARACTER_NPC_SELECT
  ["igcreatureneutralselect"] = 871, --IG_CREATURE_NEUTRAL_SELECT
  ["igcreatureaggroselect"] = 873, --IG_CREATURE_AGGRO_SELECT
  ["igquestlistopen"] = 875, --IG_QUEST_LIST_OPEN
  ["igquestlistclose"] = 876, --IG_QUEST_LIST_CLOSE
  ["igquestlistselect"] = 877, --IG_QUEST_LIST_SELECT
  ["igquestlistcomplete"] = 878, --IG_QUEST_LIST_COMPLETE
  ["igquestcancel"] = 879, --IG_QUEST_CANCEL
  ["igplayerinvite"] = 880, --IG_PLAYER_INVITE
  ["moneyframeopen"] = 891, --MONEY_FRAME_OPEN
  ["moneyframeclose"] = 892, --MONEY_FRAME_CLOSE
  ["uchatscrollbutton"] = 1115, --U_CHAT_SCROLL_BUTTON
  ["putdowngems"] = 1204, --PUT_DOWN_GEMS
  ["putdownsmallchain"] = 1212, --PUT_DOWN_SMALL_CHAIN
  ["pickupgems"] = 1221, --PICK_UP_GEMS
  ["lootwindowopenempty"] = 1264, --LOOT_WINDOW_OPEN_EMPTY
  ["tellmessage"] = 3081, --TELL_MESSAGE
  ["mapping"] = 3175, --MAP_PING
  ["fishing reel in"] = 3407, --FISHING_REEL_IN
  ["igpvpupdate"] = 4574, --IG_PVP_UPDATE
  ["auctionwindowopen"] = 5274, --AUCTION_WINDOW_OPEN
  ["auctionwindowclose"] = 5275, --AUCTION_WINDOW_CLOSE
  ["tutorialpopup"] = 7355, --TUTORIAL_POPUP
  ["item_repair"] = 7994, --ITEM_REPAIR
  ["pvpenterqueue"] = 8458, --PVP_ENTER_QUEUE
  ["pvpthroughqueue"] = 8459, --PVP_THROUGH_QUEUE
  ["keyringopen"] = 8938, --KEY_RING_OPEN
  ["keyringclose"] = 8939, --KEY_RING_CLOSE
  ["raidwarning"] = 8959, --RAID_WARNING
  ["readycheck"] = 8960, --READY_CHECK
  ["gluescreenintro"] = 9902, --GLUESCREEN_INTRO
  ["amb_gluescreen_human"] = 9903, --AMB_GLUESCREEN_HUMAN
  ["amb_gluescreen_orc"] = 9905, --AMB_GLUESCREEN_ORC
  ["amb_gluescreen_tauren"] = 9906, --AMB_GLUESCREEN_TAUREN
  ["amb_gluescreen_dwarf"] = 9907, --AMB_GLUESCREEN_DWARF
  ["amb_gluescreen_nightelf"] = 9908, --AMB_GLUESCREEN_NIGHTELF
  ["amb_gluescreen_undead"] = 9909, --AMB_GLUESCREEN_UNDEAD
  ["amb_gluescreen_bloodelf"] = 9910, --AMB_GLUESCREEN_BLOODELF
  ["amb_gluescreen_draenei"] = 9911, --AMB_GLUESCREEN_DRAENEI
  ["jewelcraftingfinalize"] = 10590, --JEWEL_CRAFTING_FINALIZE
  ["menu-credits01"] = 10763, --MENU_CREDITS01
  ["menu-credits02"] = 10804, --MENU_CREDITS02
  ["guildvaultopen"] = 12188, --GUILD_VAULT_OPEN
  ["guildvaultclose"] = 12189, --GUILD_VAULT_CLOSE
  ["raidbossemotewarning"] = 12197, --RAID_BOSS_EMOTE_WARNING
  ["guildbankopenbag"] = 12206, --GUILD_BANK_OPEN_BAG
  ["gs_lichking"] = 12765, --GS_LICH_KING
  ["alarmclockwarning2"] = 12867, --ALARM_CLOCK_WARNING_2
  ["alarmclockwarning3"] = 12889, --ALARM_CLOCK_WARNING_3
  ["menu-credits03"] = 13822, --MENU_CREDITS03
  ["achievementmenuopen"] = 13832, --ACHIEVEMENT_MENU_OPEN
  ["achievementmenuclose"] = 13833, --ACHIEVEMENT_MENU_CLOSE
  ["barbershop_haircut"] = 13873, --BARBERSHOP_HAIRCUT
  ["barbershop_sit"] = 14148, --BARBERSHOP_SIT
  ["gm_chatwarning"] = 15273, --GM_CHAT_WARNING
  ["lfg_rewards"] = 17316, --LFG_REWARDS
  ["lfg_rolecheck"] = 17317, --LFG_ROLE_CHECK
  ["lfg_denied"] = 17341, --LFG_DENIED
  ["ui_bnettoast"] = 18019, --UI_BNET_TOAST
  ["alarmclockwarning1"] = 18871, --ALARM_CLOCK_WARNING_1
  ["amb_gluescreen_worgen"] = 20169, --AMB_GLUESCREEN_WORGEN
  ["amb_gluescreen_goblin"] = 20170, --AMB_GLUESCREEN_GOBLIN
  ["amb_gluescreen_troll"] = 21136, --AMB_GLUESCREEN_TROLL
  ["amb_gluescreen_gnome"] = 21137, --AMB_GLUESCREEN_GNOME
  ["ui_poweraura_generic"] = 23287, --UI_POWER_AURA_GENERIC
  ["ui_reforging_reforge"] = 23291, --UI_REFORGING_REFORGE
  ["ui_autoquestcomplete"] = 23404, --UI_AUTO_QUEST_COMPLETE
  ["gs_cataclysm"] = 23640, --GS_CATACLYSM
  ["menu-credits04"] = 23812, --MENU_CREDITS04
  ["ui_battlegroundcountdown_timer"] = 25477, --UI_BATTLEGROUND_COUNTDOWN_TIMER
  ["ui_battlegroundcountdown_finished"] = 25478, --UI_BATTLEGROUND_COUNTDOWN_FINISHED
  ["ui_voidstorage_unlock"] = 25711, --UI_VOID_STORAGE_UNLOCK
  ["ui_voidstorage_deposit"] = 25712, --UI_VOID_STORAGE_DEPOSIT
  ["ui_voidstorage_withdraw"] = 25713, --UI_VOID_STORAGE_WITHDRAW
  ["ui_transmogrify_undo"] = 25715, --UI_TRANSMOGRIFY_UNDO
  ["ui_etherealwindow_open"] = 25716, --UI_ETHEREAL_WINDOW_OPEN
  ["ui_etherealwindow_close"] = 25717, --UI_ETHEREAL_WINDOW_CLOSE
  ["ui_transmogrify_redo"] = 25738, --UI_TRANSMOGRIFY_REDO
  ["ui_voidstorage_both"] = 25744, --UI_VOID_STORAGE_BOTH
  ["amb_gluescreen_pandaren"] = 25848, --AMB_GLUESCREEN_PANDAREN
  ["mus_50_heartofpandaria_maintitle"] = 28509, --MUS_50_HEART_OF_PANDARIA_MAINTITLE
  ["ui_petbattles_trap_ready"] = 28814, --UI_PET_BATTLES_TRAP_READY
  ["ui_epicloot_toast"] = 31578, --UI_EPICLOOT_TOAST
  ["ui_bonuslootroll_start"] = 31579, --UI_BONUS_LOOT_ROLL_START
  ["ui_bonuslootroll_loop"] = 31580, --UI_BONUS_LOOT_ROLL_LOOP
  ["ui_bonuslootroll_end"] = 31581, --UI_BONUS_LOOT_ROLL_END
  ["ui_petbattle_start"] = 31584, --UI_PET_BATTLE_START
  ["ui_scenario_ending"] = 31754, --UI_SCENARIO_ENDING
  ["ui_scenario_stage_end"] = 31757, --UI_SCENARIO_STAGE_END
  ["menu-credits05"] = 32015, --MENU_CREDITS05
  ["ui_petbattle_camera_move_in"] = 32047, --UI_PET_BATTLE_CAMERA_MOVE_IN
  ["ui_petbattle_camera_move_out"] = 32052, --UI_PET_BATTLE_CAMERA_MOVE_OUT
  ["amb_50_gluescreen_alliance"] = 32412, --AMB_50_GLUESCREEN_ALLIANCE
  ["amb_50_gluescreen_horde"] = 32413, --AMB_50_GLUESCREEN_HORDE
  ["amb_50_gluescreen_pandaren_neutral"] = 32414, --AMB_50_GLUESCREEN_PANDAREN_NEUTRAL
  ["ui_challenges_newrecord"] = 33338, --UI_CHALLENGES_NEW_RECORD
  ["menu-credits06"] = 34020, --MENU_CREDITS06
  ["ui_lossofcontrol_start"] = 34468, --UI_LOSS_OF_CONTROL_START
  ["ui_petbattles_pvp_throughqueue"] = 36609, --UI_PET_BATTLES_PVP_THROUGH_QUEUE
  ["amb_gluescreen_deathknight"] = 37056, --AMB_GLUESCREEN_DEATHKNIGHT
  ["ui_raidbosswhisperwarning"] = 37666, --UI_RAID_BOSS_WHISPER_WARNING
  ["ui_digsitecompletion_toast"] = 38326, --UI_DIG_SITE_COMPLETION_TOAST
  ["ui_igstore_pagenav_button"] = 39511, --UI_IG_STORE_PAGE_NAV_BUTTON
  ["ui_igstore_windowopen_button"] = 39512, --UI_IG_STORE_WINDOW_OPEN_BUTTON
  ["ui_igstore_windowclose_button"] = 39513, --UI_IG_STORE_WINDOW_CLOSE_BUTTON
  ["ui_igstore_cancel_button"] = 39514, --UI_IG_STORE_CANCEL_BUTTON
  ["ui_igstore_buy_button"] = 39515, --UI_IG_STORE_BUY_BUTTON
  ["ui_igstore_confirmpurchase_button"] = 39516, --UI_IG_STORE_CONFIRM_PURCHASE_BUTTON
  ["ui_igstore_purchasedelivered_toast_01"] = 39517, --UI_IG_STORE_PURCHASE_DELIVERED_TOAST_01
  ["mus_60_maintitle"] = 40169, --MUS_60_MAIN_TITLE
  ["ui_garrison_mission_complete_encounter_fail"] = 43501, --UI_GARRISON_MISSION_COMPLETE_ENCOUNTER_FAIL
  ["ui_garrison_mission_complete_mission_success"] = 43502, --UI_GARRISON_MISSION_COMPLETE_MISSION_SUCCESS
  ["ui_garrison_mission_complete_missionfail_stinger"] = 43503, --UI_GARRISON_MISSION_COMPLETE_MISSION_FAIL_STINGER
  ["ui_garrison_mission_threat_countered"] = 43505, --UI_GARRISON_MISSION_THREAT_COUNTERED
  ["ui_garrison_mission_100_percent_chance_reached_not used"] = 43507, --UI_GARRISON_MISSION_100_PERCENT_CHANCE_REACHED_NOT_USED
  ["ui_questrollingforward_01"] = 43936, --UI_QUEST_ROLLING_FORWARD_01
  ["ui_bagsorting_01"] = 43937, --UI_BAG_SORTING_01
  ["ui_toybox_tabs"] = 43938, --UI_TOYBOX_TABS
  ["ui_garrison_toast_invasionalert"] = 44292, --UI_GARRISON_TOAST_INVASION_ALERT
  ["ui_garrison_toast_missioncomplete"] = 44294, --UI_GARRISON_TOAST_MISSION_COMPLETE
  ["ui_garrison_toast_buildingcomplete"] = 44295, --UI_GARRISON_TOAST_BUILDING_COMPLETE
  ["ui_garrison_toast_followergained"] = 44296, --UI_GARRISON_TOAST_FOLLOWER_GAINED
  ["ui_garrison_nav_tabs"] = 44297, --UI_GARRISON_NAV_TABS
  ["ui_garrison_garrisonreport_open"] = 44298, --UI_GARRISON_GARRISON_REPORT_OPEN
  ["ui_garrison_garrisonreport_close"] = 44299, --UI_GARRISON_GARRISON_REPORT_CLOSE
  ["ui_garrison_architecttable_open"] = 44300, --UI_GARRISON_ARCHITECT_TABLE_OPEN
  ["ui_garrison_architecttable_close"] = 44301, --UI_GARRISON_ARCHITECT_TABLE_CLOSE
  ["ui_garrison_architecttable_upgrade"] = 44302, --UI_GARRISON_ARCHITECT_TABLE_UPGRADE
  ["ui_garrison_architecttable_upgradecancel"] = 44304, --UI_GARRISON_ARCHITECT_TABLE_UPGRADE_CANCEL
  ["ui_garrison_architecttable_upgradestart"] = 44305, --UI_GARRISON_ARCHITECT_TABLE_UPGRADE_START
  ["ui_garrison_architecttable_plotselect"] = 44306, --UI_GARRISON_ARCHITECT_TABLE_PLOT_SELECT
  ["ui_garrison_architecttable_buildingselect"] = 44307, --UI_GARRISON_ARCHITECT_TABLE_BUILDING_SELECT
  ["ui_garrison_architecttable_buildingplacement"] = 44308, --UI_GARRISON_ARCHITECT_TABLE_BUILDING_PLACEMENT
  ["ui_garrison_commandtable_open"] = 44311, --UI_GARRISON_COMMAND_TABLE_OPEN
  ["ui_garrison_commandtable_close"] = 44312, --UI_GARRISON_COMMAND_TABLE_CLOSE
  ["ui_garrison_commandtable_missionclose"] = 44313, --UI_GARRISON_COMMAND_TABLE_MISSION_CLOSE
  ["ui_garrison_commandtable_nav_next"] = 44314, --UI_GARRISON_COMMAND_TABLE_NAV_NEXT
  ["ui_garrison_commandtable_selectmission"] = 44315, --UI_GARRISON_COMMAND_TABLE_SELECT_MISSION
  ["ui_garrison_commandtable_selectfollower"] = 44316, --UI_GARRISON_COMMAND_TABLE_SELECT_FOLLOWER
  ["ui_garrison_commandtable_followerabilityopen"] = 44317, --UI_GARRISON_COMMAND_TABLE_FOLLOWER_ABILITY_OPEN
  ["ui_garrison_commandtable_followerabilityclose"] = 44318, --UI_GARRISON_COMMAND_TABLE_FOLLOWER_ABILITY_CLOSE
  ["ui_garrison_commandtable_assignfollower"] = 44319, --UI_GARRISON_COMMAND_TABLE_ASSIGN_FOLLOWER
  ["ui_garrison_commandtable_unassignfollower"] = 44320, --UI_GARRISON_COMMAND_TABLE_UNASSIGN_FOLLOWER
  ["ui_garrison_commandtable_reducedsuccesschance"] = 44321, --UI_GARRISON_COMMAND_TABLE_REDUCED_SUCCESS_CHANCE
  ["ui_garrison_commandtable_100success"] = 44322, --UI_GARRISON_COMMAND_TABLE_100_SUCCESS
  ["ui_garrison_commandtable_missionstart"] = 44323, --UI_GARRISON_COMMAND_TABLE_MISSION_START
  ["ui_garrison_commandtable_viewmissionreport"] = 44324, --UI_GARRISON_COMMAND_TABLE_VIEW_MISSION_REPORT
  ["ui_garrison_commandtable_missionsuccess_stinger"] = 44330, --UI_GARRISON_COMMAND_TABLE_MISSION_SUCCESS_STINGER
  ["ui_garrison_commandtable_chestunlock"] = 44331, --UI_GARRISON_COMMAND_TABLE_CHEST_UNLOCK
  ["ui_garrison_commandtable_chestunlock_gold_success"] = 44332, --UI_GARRISON_COMMAND_TABLE_CHEST_UNLOCK_GOLD_SUCCESS
  ["ui_garrison_monuments_open"] = 44344, --UI_GARRISON_MONUMENTS_OPEN
  ["ui_bonuseventsystemvignettes"] = 45142, --UI_BONUS_EVENT_SYSTEM_VIGNETTES
  ["ui_garrison_commandtable_follower_levelup"] = 46893, --UI_GARRISON_COMMAND_TABLE_FOLLOWER_LEVEL_UP
  ["ui_garrison_architecttable_buildingplacementerror"] = 47355, --UI_GARRISON_ARCHITECT_TABLE_BUILDING_PLACEMENT_ERROR
  ["ui_garrison_monuments_close"] = 47373, --UI_GARRISON_MONUMENTS_CLOSE
  ["amb_gluescreen_warlordsofdraenor"] = 47544, --AMB_GLUESCREEN_WARLORDS_OF_DRAENOR
  ["mus_1.0_maintitle_original"] = 47598, --MUS_1_0_MAINTITLE_ORIGINAL
  ["ui_groupfinderreceiveapplication"] = 47615, --UI_GROUP_FINDER_RECEIVE_APPLICATION
  ["ui_garrison_missionencounter_animation_generic"] = 47704, --UI_GARRISON_MISSION_ENCOUNTER_ANIMATION_GENERIC
  ["ui_garrison_start_work_order"] = 47972, --UI_GARRISON_START_WORK_ORDER
  ["ui_garrison_shipments_window_open"] = 48191, --UI_GARRISON_SHIPMENTS_WINDOW_OPEN
  ["ui_garrison_shipments_window_close"] = 48192, --UI_GARRISON_SHIPMENTS_WINDOW_CLOSE
  ["ui_garrison_monuments_nav"] = 48942, --UI_GARRISON_MONUMENTS_NAV
  ["ui_raid_boss_defeated"] = 50111, --UI_RAID_BOSS_DEFEATED
  ["ui_personal_loot_banner"] = 50893, --UI_PERSONAL_LOOT_BANNER
  ["ui_garrison_follower_learn_trait"] = 51324, --UI_GARRISON_FOLLOWER_LEARN_TRAIT
  ["ui_garrison_shipyard_place_carrier"] = 51385, --UI_GARRISON_SHIPYARD_PLACE_CARRIER
  ["ui_garrison_shipyard_place_galleon"] = 51387, --UI_GARRISON_SHIPYARD_PLACE_GALLEON
  ["ui_garrison_shipyard_place_dreadnought"] = 51388, --UI_GARRISON_SHIPYARD_PLACE_DREADNOUGHT
  ["ui_garrison_shipyard_place_submarine"] = 51389, --UI_GARRISON_SHIPYARD_PLACE_SUBMARINE
  ["ui_garrison_shipyard_place_landingcraft"] = 51390, --UI_GARRISON_SHIPYARD_PLACE_LANDING_CRAFT
  ["ui_garrison_shipyard_start_mission"] = 51401, --UI_GARRISON_SHIPYARD_START_MISSION
  ["ui_raid_loot_toast_lesser_item_won"] = 51402, --UI_RAID_LOOT_TOAST_LESSER_ITEM_WON
  ["ui_warforged_item_loot_toast"] = 51561, --UI_WARFORGED_ITEM_LOOT_TOAST
  ["ui_garrison_commandtable_increasedsuccesschance"] = 51570, --UI_GARRISON_COMMAND_TABLE_INCREASED_SUCCESS_CHANCE
  ["ui_garrison_shipyard_decomission_ship"] = 51871, --UI_GARRISON_SHIPYARD_DECOMISSION_SHIP
  ["ui_70_artifact_forge_trait_goldtrait"] = 54125, --UI_70_ARTIFACT_FORGE_TRAIT_GOLD_TRAIT
  ["ui_70_artifact_forge_trait_firsttrait"] = 54126, --UI_70_ARTIFACT_FORGE_TRAIT_FIRST_TRAIT
  ["ui_70_artifact_forge_trait_finalrank"] = 54127, --UI_70_ARTIFACT_FORGE_TRAIT_FINALRANK
  ["ui_70_artifact_forge_relic_place"] = 54128, --UI_70_ARTIFACT_FORGE_RELIC_PLACE
  ["ui_70_artifact_forge_trait_rankup"] = 54129, --UI_70_ARTIFACT_FORGE_TRAIT_RANKUP
  ["ui_70_artifact_forge_appearance_colorselect"] = 54130, --UI_70_ARTIFACT_FORGE_APPEARANCE_COLOR_SELECT
  ["ui_70_artifact_forge_appearance_locked"] = 54131, --UI_70_ARTIFACT_FORGE_APPEARANCE_LOCKED
  ["ui_70_artifact_forge_appearance_apperancechange"] = 54132, --UI_70_ARTIFACT_FORGE_APPEARANCE_APPEARANCE_CHANGE
  ["ui_70_artifact_forge_toast_traitavailable"] = 54133, --UI_70_ARTIFACT_FORGE_TOAST_TRAIT_AVAILABLE
  ["ui_70_artifact_forge_appearance_apperanceunlock"] = 54139, --UI_70_ARTIFACT_FORGE_APPEARANCE_APPEARANCE_UNLOCK
  ["amb_gluescreen_demonhunter"] = 56352, --AMB_GLUESCREEN_DEMONHUNTER
  ["mus_70_maintitle"] = 56353, --MUS_70_MAIN_TITLE
  ["menu-credits07"] = 56354, --MENU_CREDITS07
  ["ui_transmog_itemclick"] = 62538, --UI_TRANSMOG_ITEM_CLICK
  ["ui_transmog_pageturn"] = 62539, --UI_TRANSMOG_PAGE_TURN
  ["ui_transmog_gearslotclick"] = 62540, --UI_TRANSMOG_GEAR_SLOT_CLICK
  ["ui_transmog_revertinggearslot"] = 62541, --UI_TRANSMOG_REVERTING_GEAR_SLOT
  ["ui_transmog_apply"] = 62542, --UI_TRANSMOG_APPLY
  ["ui_transmog_closewindow"] = 62543, --UI_TRANSMOG_CLOSE_WINDOW
  ["ui_transmog_openwindow"] = 62544, --UI_TRANSMOG_OPEN_WINDOW
  ["ui_legendaryloot_toast"] = 63971, --UI_LEGENDARY_LOOT_TOAST
  ["ui_store_unwrap"] = 64329, --UI_STORE_UNWRAP
  ["amb_gluescreen_legion"] = 71535, --AMB_GLUESCREEN_LEGION
  ["ui_mission_slotchampion"] = 72546, --UI_GARRISON_COMMAND_TABLE_SLOT_CHAMPION
  ["ui_mission_slottroop"] = 72547, --UI_GARRISON_COMMAND_TABLE_SLOT_TROOP
  ["ui_mission_200percent"] = 72548, --UI_MISSION_200_PERCENT
  ["ui_mission_map_zoom"] = 72549, --UI_MISSION_MAP_ZOOM
  ["ui_70_boost_thanksforplaying"] = 72977, --UI_70_BOOST_THANKSFORPLAYING
  ["ui_70_boost_thanksforplaying_smaller"] = 72978, --UI_70_BOOST_THANKSFORPLAYING_SMALLER
  ["ui_worldquest_start"] = 73275, --UI_WORLDQUEST_START
  ["ui_worldquest_map_select"] = 73276, --UI_WORLDQUEST_MAP_SELECT
  ["ui_worldquest_complete"] = 73277, --UI_WORLDQUEST_COMPLETE
  ["ui_orderhall_talent_select"] = 73279, --UI_ORDERHALL_TALENT_SELECT
  ["ui_orderhall_talent_ready_toast"] = 73280, --UI_ORDERHALL_TALENT_READY_TOAST
  ["ui_orderhall_talent_ready_check"] = 73281, --UI_ORDERHALL_TALENT_READY_CHECK
  ["ui_orderhall_talent_nukefromorbit"] = 73282, --UI_ORDERHALL_TALENT_NUKE_FROM_ORBIT
  ["ui_orderhall_talentwindow_open"] = 73914, --UI_ORDERHALL_TALENT_WINDOW_OPEN
  ["ui_orderhall_talentwindow_close"] = 73915, --UI_ORDERHALL_TALENT_WINDOW_CLOSE
  ["ui_professionswindow_open"] = 73917, --UI_PROFESSIONS_WINDOW_OPEN
  ["ui_professionswindow_close"] = 73918, --UI_PROFESSIONS_WINDOW_CLOSE
  ["ui_professions_newrecipelearned_toast"] = 73919, --UI_PROFESSIONS_NEW_RECIPE_LEARNED_TOAST
  ["ui_70_challengemode_socketpage_open"] = 74421, --UI_70_CHALLENGE_MODE_SOCKET_PAGE_OPEN
  ["ui_70_challengemode_socketpage_close"] = 74423, --UI_70_CHALLENGE_MODE_SOCKET_PAGE_CLOSE
  ["ui_70_challengemode_socketpage_socket"] = 74431, --UI_70_CHALLENGE_MODE_SOCKET_PAGE_SOCKET
  ["ui_70_challengemode_socketpage_activatebutton"] = 74432, --UI_70_CHALLENGE_MODE_SOCKET_PAGE_ACTIVATE_BUTTON
  ["ui_70_challengemode_keystoneupgrade"] = 74437, --UI_70_CHALLENGE_MODE_KEYSTONE_UPGRADE
  ["ui_70_challengemode_newrecord"] = 74438, --UI_70_CHALLENGE_MODE_NEW_RECORD
  ["ui_70_challengemode_socketpage_removekeystone"] = 74525, --UI_70_CHALLENGE_MODE_SOCKET_PAGE_REMOVE_KEYSTONE
  ["ui_70_challengemode_complete_noupgrade"] = 74526, --UI_70_CHALLENGE_MODE_COMPLETE_NO_UPGRADE
  ["ui_mission_success_cheers"] = 74702, --UI_MISSION_SUCCESS_CHEERS
  ["ui_pvp_honor_prestige_openwindow"] = 76995, --UI_PVP_HONOR_PRESTIGE_OPEN_WINDOW
  ["ui_pvp_honor_prestige_windowclose"] = 77002, --UI_PVP_HONOR_PRESTIGE_WINDOW_CLOSE
  ["ui_pvp_honor_prestige_rankup"] = 77003, --UI_PVP_HONOR_PRESTIGE_RANK_UP
  ["ui_71_social_queueing_toast"] = 79739, --UI_71_SOCIAL_QUEUEING_TOAST
  ["ui_72_artifact_forge_activate_final_tier"] = 83681, --UI_72_ARTIFACT_FORGE_ACTIVATE_FINAL_TIER
  ["ui_72_artifact_forge_final_trait_unlocked"] = 83682, --UI_72_ARTIFACT_FORGE_FINAL_TRAIT_UNLOCKED
  ["ui_72_artifact_forge_final_trait_refund_start"] = 83684, --UI_72_ARTIFACT_FORGE_FINAL_TRAIT_REFUND_START
  ["ui_72_artifact_forge_final_trait_refund_loop"] = 83685, --UI_72_ARTIFACT_FORGE_FINAL_TRAIT_REFUND_LOOP
  ["ui_72_buildings_contribute_power_menu_click"] = 84240, --UI_72_BUILDINGS_CONTRIBUTE_POWER_MENU_CLICK
  ["ui_72_building_contribution_table_open"] = 84368, --UI_72_BUILDING_CONTRIBUTION_TABLE_OPEN
  ["ui_72_buildings_contribution_table_close"] = 84369, --UI_72_BUILDINGS_CONTRIBUTION_TABLE_CLOSE
  ["ui_72_buildings_contribute_resources"] = 84378, --UI_72_BUILDINGS_CONTRIBUTE_RESOURCES
  ["ui_73_artifact_relics_trait_selectandreveal"] = 89685, --UI_73_ARTIFACT_RELICS_TRAIT_SELECT_AND_REVEAL
  ["ui_73_artifact_relics_trait_selectonly"] = 89686, --UI_73_ARTIFACT_RELICS_TRAIT_SELECT_ONLY
  ["ui_73_artifact_relics_trait_revealonly"] = 90080, --UI_73_ARTIFACT_RELICS_TRAIT_REVEAL_ONLY
}
