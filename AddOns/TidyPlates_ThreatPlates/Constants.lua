local ADDON_NAME, Addon = ...
local ThreatPlates = Addon.ThreatPlates

---------------------------------------------------------------------------------------------------
-- Stuff for handling the configuration of Threat Plates - ThreatPlatesDB
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- Imported functions and constants
---------------------------------------------------------------------------------------------------
local L = ThreatPlates.L
local RGB = ThreatPlates.RGB
local RGB_P = ThreatPlates.RGB_P
local HEX2RGB = ThreatPlates.HEX2RGB

---------------------------------------------------------------------------------------------------
-- Color and font definitions
---------------------------------------------------------------------------------------------------
local DEFAULT_FONT = "Cabin"
local DEFAUL_SMALL_FONT = "Arial Narrow"

local locale = GetLocale()
local MAP_FONT = {
  koKR = { -- Korrean
    DefaultFont = "기본 글꼴",      -- "2002"
    DefaultSmallFont = "기본 글꼴", -- "2002"
  },
  zhCN = { -- Simplified Chinese
    DefaultFont = "默认",      -- "AR ZhongkaiGBK Medium"
    DefaultSmallFont = "默认", -- "AR ZhongkaiGBK Medium"
  },
  zhTW = { -- Traditional Chinese
    DefaultFont = "預設",       -- "AR Kaiti Medium B5"
    DefaultSmallFont = "預設",  -- "AR Kaiti Medium B5"
  },
  ruRU = { -- Russian
    DefaultFont = "Friz Quadrata TT", -- "FrizQuadrataCTT"
    DefaultSmallFont = "Arial Narrow",
  }
}

if MAP_FONT[locale] then
  DEFAULT_FONT = MAP_FONT[locale].DefaultFont
  DEFAUL_SMALL_FONT = MAP_FONT[locale].DefaultSmallFont
end

---------------------------------------------------------------------------------------------------
-- Global contstants for various stuff
---------------------------------------------------------------------------------------------------
Addon.UIScale = 1

Addon.TotemInformation = {} -- basic totem information
Addon.TOTEMS = {} -- mapping table for fast access to totem settings

ThreatPlates.ADDON_NAME = L["Threat Plates"]
ThreatPlates.THEME_NAME = L["Threat Plates"]

ThreatPlates.ANCHOR_POINT = {
  TOPLEFT = L["Top Left"],
  TOP = L["Top"],
  TOPRIGHT = L["Top Right"],
  LEFT = L["Left"],
  CENTER = L["Center"],
  RIGHT = L["Right"],
  BOTTOMLEFT = L["Bottom Left"],
  BOTTOM = L["Bottom "],
  BOTTOMRIGHT = L["Bottom Right"]
}

ThreatPlates.ANCHOR_POINT_SETPOINT = {
  TOPLEFT = {"TOPLEFT", "BOTTOMLEFT"},
  TOP = {"TOP", "BOTTOM"},
  TOPRIGHT = {"TOPRIGHT", "BOTTOMRIGHT"},
  LEFT = {"LEFT", "RIGHT"},
  CENTER = {"CENTER", "CENTER"},
  RIGHT = {"RIGHT", "LEFT"},
  BOTTOMLEFT = {"BOTTOMLEFT", "TOPLEFT"},
  BOTTOM = {"BOTTOM", "TOP"},
  BOTTOMRIGHT = {"BOTTOMRIGHT", "TOPRIGHT"}
}

-- only used by DebuffWidget (old Auras)
ThreatPlates.FullAlign = {TOPLEFT = "TOPLEFT",TOP = "TOP",TOPRIGHT = "TOPRIGHT",LEFT = "LEFT",CENTER = "CENTER",RIGHT = "RIGHT",BOTTOMLEFT = "BOTTOMLEFT",BOTTOM = "BOTTOM",BOTTOMRIGHT = "BOTTOMRIGHT"}

ThreatPlates.AlignH = {LEFT = "LEFT", CENTER = "CENTER", RIGHT = "RIGHT"}
ThreatPlates.AlignV = {BOTTOM = "BOTTOM", CENTER = "CENTER", TOP = "TOP"}

ThreatPlates.AUTOMATION = {
  NONE = L["No Automation"],
  SHOW_COMBAT = L["Show during Combat, Hide when Combat ends"],
  HIDE_COMBAT = L["Hide when Combat starts, Show when Combat ends"],
}

----------------------------------------------------------------------------------------------------
-- Paths
---------------------------------------------------------------------------------------------------

ThreatPlates.Widgets = "Interface\\Addons\\TidyPlates_ThreatPlates\\Artwork\\Widgets\\"

---------------------------------------------------------------------------------------------------
-- Global contstants for options dialog
---------------------------------------------------------------------------------------------------

ThreatPlates.DebuffMode = {
  ["whitelist"] = L["White List"],
  ["blacklist"] = L["Black List"],
  ["whitelistMine"] = L["White List (Mine)"],
  ["blacklistMine"] = L["Black List (Mine)"],
  ["all"] = L["All Auras"],
  ["allMine"] = L["All Auras (Mine)"],
  ["BLIZZARD"] = L["Blizzard"]
}

ThreatPlates.SPEC_ROLES = {
  DEATHKNIGHT = { true, false, false },
  DEMONHUNTER = { false, true },
  DRUID 			= { false, false, true, false },
  HUNTER			= { false, false, false },
  MAGE				= { false, false, false },
  MONK 				= { true, false, false },
  PALADIN 		= { false, true, false },
  PRIEST			= { false, false, false },
  ROGUE				= { false, false, false },
  SHAMAN			= { false, false, false },
  WARLOCK			= { false, false, false },
  WARRIOR			= { false, false, true },
}

ThreatPlates.FontStyle = {
  NONE = L["None"],
  OUTLINE = L["Outline"],
  THICKOUTLINE = L["Thick Outline"],
  ["NONE, MONOCHROME"] = L["No Outline, Monochrome"],
  ["OUTLINE, MONOCHROME"] = L["Outline, Monochrome"],
  ["THICKOUTLINE, MONOCHROME"] = L["Thick Outline, Monochrome"]
}

-- "By Threat", "By Level Color", "By Normal/Elite/Boss"
ThreatPlates.ENEMY_TEXT_COLOR = {
  CLASS = L["By Class"],
  CUSTOM = L["By Custom Color"],
  REACTION = L["By Reaction"],
  HEALTH = L["By Health"],
}

ThreatPlates.FRIENDLY_TEXT_COLOR = {
  CLASS = L["By Class"],
  CUSTOM = L["By Custom Color"],
  REACTION = L["By Reaction"],
  HEALTH = L["By Health"],
}

-- NPC Role, Guild, or Quest", "Quest",
ThreatPlates.ENEMY_SUBTEXT = {
  NONE = L["None"],
  HEALTH = L["Health"],
  ROLE = L["NPC Role"],
  ROLE_GUILD = L["NPC Role, Guild"],
  ROLE_GUILD_LEVEL = L["NPC Role, Guild, or Level"],
  LEVEL = L["Level"],
  ALL = L["Everything"],
}

-- "NPC Role, Guild, or Quest", "Quest"
ThreatPlates.FRIENDLY_SUBTEXT = {
  NONE = L["None"],
  HEALTH = L["Health"],
  ROLE = L["NPC Role"],
  ROLE_GUILD = L["NPC Role, Guild"],
  ROLE_GUILD_LEVEL = L["NPC Role, Guild, or Level"],
  LEVEL = L["Level"],
  ALL = L["Everything"],
}

-------------------------------------------------------------------------------
-- Totem data - define it one time for the whole addon
-------------------------------------------------------------------------------

local TOTEM_DATA = {
  -- Totems from Totem Mastery
  [1]  = { SpellID = 202188, ID = "M1", GroupColor = "b8d1ff"}, 	-- Resonance Totem
  [2]  = { SpellID = 210651, ID = "M2",	GroupColor = "b8d1ff"},		-- Storm Totem
  [3]  = { SpellID = 210657, ID = "M3", GroupColor = "b8d1ff"},		-- Ember Totem
  [4]  = { SpellID = 210660, ID = "M4", GroupColor = "b8d1ff"},		-- Tailwind Totem

  -- Totems from spezialization
  [5]  = { SpellID = 98008,  ID = "S1", GroupColor = "ffb31f"},		-- Spirit Link Totem
  [6]  = { SpellID = 5394,	 ID = "S2", GroupColor = "ffb31f"},		-- Healing Stream Totem
  [7]  = { SpellID = 108280, ID = "S3", GroupColor = "ffb31f"},		-- Healing Tide Totem
  [8]  = { SpellID = 160161, ID = "S4", GroupColor = "ffb31f"}, 	-- Earthquake Totem
  [9]  = { SpellID = 2484, 	 ID = "S5",	GroupColor = "ffb31f"},  	-- Earthbind Totem (added patch 7.2, TP v8.4.0)

  -- Lonely fire totem
  [10] = { SpellID = 192222, ID = "F1", GroupColor = "ff8f8f"}, 	-- Liquid Magma Totem

  -- Totems from talents
  [11] = { SpellID = 157153, ID = "N1", GroupColor = "4c9900"},		-- Cloudburst Totem
  [12] = { SpellID = 51485,  ID = "N2", GroupColor = "4c9900"},		-- Earthgrab Totem
  [13] = { SpellID = 192058, ID = "N3", GroupColor = "4c9900"},		-- Lightning  Surge Totem
  [14] = { SpellID = 207399, ID = "N4", GroupColor = "4c9900"},		-- Ancestral Protection Totem
  [15] = { SpellID = 192077, ID = "N5", GroupColor = "4c9900"},		-- Wind Rush Totem
  [16] = { SpellID = 196932, ID = "N6", GroupColor = "4c9900"},		-- Voodoo Totem
  [17] = { SpellID = 198838, ID = "N7", GroupColor = "4c9900"},		-- Earthen Shield Totem

  -- Totems from PVP talents
  [18] = { SpellID = 204331, ID = "P1", GroupColor = "2b76ff"},	-- Counterstrike Totem
  [19] = { SpellID = 204330, ID = "P2", GroupColor = "2b76ff"},	-- Skyfury Totem
  [20] = { SpellID = 204332, ID = "P3", GroupColor = "2b76ff"},	-- Windfury Totem
  [21] = { SpellID = 204336, ID = "P4", GroupColor = "2b76ff"},	-- Grounding Totem
}

function Addon:InitializeTotemInformation()
  for i, totem_data in ipairs(TOTEM_DATA) do
    local name, _ = GetSpellInfo(totem_data.SpellID) or UNKNOWNOBJECT, nil

    totem_data.Name = name
    totem_data.Color = RGB(HEX2RGB(totem_data.GroupColor))
    totem_data.SortKey = totem_data.ID:sub(1, 1) .. name
    totem_data.Style = "normal"
    totem_data.ShowNameplate = true
    totem_data.ShowHPColor = true
    totem_data.ShowIcon = true

    Addon.TotemInformation[name] = totem_data
    Addon.TOTEMS[name] = totem_data.ID
  end

--  local test_name = "Hochexarch Turalyon"
--  local id = "P4"
--  Addon.TotemInformation[test_name] = {
--    Name = test_name,
--    SpellID = 204336,
--    Icon = id,
--    ID = id,
--    SortKey = id:sub(1, 1) .. test_name,
--    Style = "normal",
--    Color = RGB(HEX2RGB("2b76ff")),
--    GroupColor = "2b76ff",
--    ShowNameplate = true,
--    ShowHPColor = true,
--    ShowIcon = true,
--  }
--  Addon.TOTEMS[test_name] = id
end

local function GetDefaultTotemSettings()
  Addon:InitializeTotemInformation()

  local settings = {
    hideHealthbar = false
  }

  for _, data in pairs(Addon.TotemInformation) do
    settings[data.ID] = data
  end

  return settings
end

---------------------------------------------------------------------------------------------------
-- Default settings for ThreatPlates
---------------------------------------------------------------------------------------------------

ThreatPlates.DEFAULT_SETTINGS = {
  global = {
    version = "",
    CheckNewLookAndFeel = false,
    DefaultsVersion = "SMOOTH",
  },
  char = {
    welcome = false,
    specInfo = {
      [1] = {
        name = "",
        role = "",
      },
      [2] = {
        name = "",
        role = "",
      },
    },
    spec = {
      [1] = false,
      [2] = false,
    },
  },
  profile = {
    cache = {},
    -- OldSetting = true, - removed in 8.7.0
    verbose = false,
    -- blizzFadeA = { -- removed in 8.5.1
    --   toggle  = true,
    --   amount = 0.7
    -- },
    blizzFadeS = {
      toggle  = true,
      amount = -0.3
    },
    tidyplatesFade = false,
    healthColorChange = false,
    customColor =  false,
    allowClass = true, -- old default: false,
    friendlyClass = true, -- old default: false,
    friendlyClassIcon = false,
    HostileClassIcon = true,
    cacheClass = false,
    optionRoleDetectionAutomatic = true, -- old default: false,
    ShowThreatGlowOnAttackedUnitsOnly = true,
    ShowThreatGlowOffTank = true,
    NamePlateEnemyClickThrough = false,
    NamePlateFriendlyClickThrough = true,
    ShowFriendlyBlizzardNameplates = false,
    Automation = {
      FriendlyUnits = "NONE",
      EnemyUnits = "NONE",
      SmallPlatesInInstances = false,
      HideFriendlyUnitsInInstances = false,
    },
    Scale = {
      IgnoreUIScale = true,
      PixelPerfectUI = false,
    },
    HeadlineView = {
      ON = true,
      name = {
        size = 12,
        -- width = 140, -- same as for healthbar view -- old default: 116,
        -- height = 14, -- same as for healthbar view
        x = 0,
        y = 4,
        align = "CENTER",
        vertical = "CENTER",
      },
      customtext = {
        size = 8,
        -- shadow = true,  -- never used
        -- flags = "NONE", -- never used
        -- width = 140,    -- never used, same as for healthbar view
        -- height = 14,    -- never used, same as for healthbar view
        x = 0,
        y = -7,
        align = "CENTER",
        vertical = "CENTER",
      },
      useAlpha = true,
      -- blizzFading = true, -- removed in 8.5.1
      -- blizzFadingAlpha = 1, -- removed in 8.5.1
      useScaling = true,
      ShowTargetHighlight = true,
      ShowMouseoverHighlight = true,
      ForceHealthbarOnTarget = false,
      ForceOutOfCombat = true,
      ForceNonAttackableUnits = true,
      ForceFriendlyInCombat = true,
      --
      EnemyTextColorMode = "CLASS",
      EnemyTextColor = RGB(0, 255, 0),
      FriendlyTextColorMode = "CLASS",
      FriendlyTextColor = RGB(0, 255, 0),
      UseRaidMarkColoring = false,
      SubtextColorUseHeadline = false,
      SubtextColorUseSpecific = true,
      SubtextColor =  RGB(255, 255, 255, 1),
      --
      EnemySubtext = "ROLE_GUILD_LEVEL",
      FriendlySubtext = "ROLE_GUILD",
    },
    Visibility = {
      --				showNameplates = true,
      --				showHostileUnits = true,
      --				showFriendlyUnits = false,
      FriendlyPlayer = { Show = true, UseHeadlineView = true },
      FriendlyNPC = { Show = true, UseHeadlineView = true },
      FriendlyTotem = { Show = "nameplateShowFriendlyTotems", UseHeadlineView = true },
      FriendlyGuardian = { Show = "nameplateShowFriendlyGuardians", UseHeadlineView = true },
      FriendlyPet = { Show = "nameplateShowFriendlyPets", UseHeadlineView = true },
      FriendlyMinus = { Show = true, UseHeadlineView = true },
      EnemyPlayer = { Show = true, UseHeadlineView = false },
      EnemyNPC = { Show = true, UseHeadlineView = false },
      EnemyTotem = { Show = "nameplateShowEnemyTotems", UseHeadlineView = false },
      EnemyGuardian = { Show = "nameplateShowEnemyGuardians", UseHeadlineView = false },
      EnemyPet = { Show = "nameplateShowEnemyPets", UseHeadlineView = false },
      EnemyMinus = { Show = "nameplateShowEnemyMinus", UseHeadlineView = false },
      NeutralNPC = { Show = true, UseHeadlineView = false },
      --        NeutralGuardian = { Show = true, UseHeadlineView = false },
      NeutralMinus = { Show = true, UseHeadlineView = false },
      -- special units
      HideNormal = false,
      HideBoss = false,
      HideElite = false,
      HideTapped = false,
      HideFriendlyInCombat = false,
    },
    castbarColor = {
      -- toggle = true, -- removed in 8.7.0
      r = 1,
      g = 0.56,
      b = 0.06,
      a = 1
    },
    castbarColorShield = {
      --toggle = true,  -- removed in 8.7.0
      r = 1,
      g = 0,
      b = 0,
      a = 1
    },
    castbarColorInterrupted = RGB(255, 0, 255, 1),
    aHPbarColor = RGB_P(0, 1, 0),
    bHPbarColor = RGB_P(1, 1, 0),
--    cHPbarColor = {
--      r = 1,
--      g = 0,
--      b = 0
--    },
--    fHPbarColor = RGB(0, 255, 0),
--    nHPbarColor = RGB(255, 255, 0),
--    tapHPbarColor = RGB(100, 100, 100),
--    HPbarColor = RGB(255, 0, 0),
--    tHPbarColor = {
--      r = 0,
--      g = 0.5,
--      b = 1,
--    },
    ColorByReaction = {
      FriendlyPlayer = RGB(0, 0, 255),           -- blue
      FriendlyNPC = RGB(0, 255, 0),              -- green
      HostileNPC = RGB(255, 0, 0),               -- red
      HostilePlayer = RGB(255, 0, 0),            -- red
      NeutralUnit = RGB(255, 255, 0),            -- yellow
      TappedUnit = RGB(110, 110, 110, 1),	       -- grey
      DisconnectedUnit = RGB(128, 128, 128, 1),  -- dray, darker than tapped color
      UnfriendlyFaction = RGB(255, 153, 51, 1),  -- brown/orange for unfriendly, hostile, non-attackable units (unit reaction = 3)
    },
    text = {
      amount = false, -- old default: true,
      percent = true,
      full = false,
      max = false,
      deficit = false,
      truncate = true,
      LocalizedUnitSymbol = true,
    },
    totemWidget = {
      ON = true,
      scale = 35,
      x = 0,
      y = 35,
      level = 1,
      anchor = "CENTER"
    },
    arenaWidget = {
      ON = false, --old default: true,
      scale = 16,
      x = 36,
      y = -6,
      anchor = "CENTER",
      colors = {
        [1] = RGB_P(1, 0, 0, 1),
        [2] = RGB_P(1, 1, 0, 1),
        [3] = RGB_P(0, 1, 0, 1),
        [4] = RGB_P(0, 1, 1, 1),
        [5] = RGB_P(0, 0, 1, 1),
      },
      numColors = {
        [1] = RGB_P(1, 1, 1, 1),
        [2] = RGB_P(1, 1, 1, 1),
        [3] = RGB_P(1, 1, 1, 1),
        [4] = RGB_P(1, 1, 1, 1),
        [5] = RGB_P(1, 1, 1, 1),
      },
    },
    healerTracker = {
      ON = true,
      scale = 1,
      x = 0,
      y = 35,
      level = 1,
      anchor = "CENTER"
    },
    AuraWidget = {
      ON = true,
      x = 0,
      y = 16,
      x_hv = 0,
      y_hv = 16,
      scale = 1,
      FrameOrder = "HEALTHBAR_AURAS",
      anchor = "TOP",
      ShowInHeadlineView = false,
      ShowEnemy = true,
      ShowFriendly = true,
      FilterMode = "blacklistMine",
      FilterByType = {
        [1] = true,
        [2] = true,
        [3] = true,
        [4] = true,
        [5] = true,
        [6] = true
      },
      ShowDebuffsOnFriendly = false,
      FilterBySpell = {},
      ShowTargetOnly = false,
      ShowCooldownSpiral = false,
      ShowStackCount = true,
      ShowAuraType = true,
      DefaultBuffColor = RGB(102, 0, 51, 1),
      DefaultDebuffColor = 	RGB(204, 0, 0, 1),
      -- DebuffTypeColor["none"]	= { r = 0.80, g = 0, b = 0 };
      SortOrder = "TimeLeft",
      SortReverse = false,
      AlignmentH = "LEFT",
      AlignmentV = "BOTTOM",
      ModeIcon = {
        Columns = 5,
        Rows = 3,
        ColumnSpacing = 5,
        RowSpacing = 8,
        Style = "wide",
      },
      ModeBar = {
        Enabled = false,
        BarHeight = 14,
        BarWidth = 100,
        BarSpacing = 2,
        MaxBars = 10,
        Texture = "Smooth", -- old default: "Aluminium",
        Font = DEFAUL_SMALL_FONT,
        FontSize = 10,
        FontColor = RGB(255, 255, 255),
        LabelTextIndent = 4,
        TimeTextIndent = 4,
        BackgroundTexture = "Smooth",
        BackgroundColor = RGB(0, 0, 0, 0.3),
        -- BackgroundBorder = "ThreatPlatesBorder", -- not used
        -- BackgroundBorderEdgeSize = 1, -- not used
        -- BackgroundBorderInset = 1, -- not used
        -- BackgroundBorderColor = RGB(0, 0, 0, 0.3), -- not used
        ShowIcon = true,
        IconSpacing = 2,
        IconAlignmentLeft = true,
      },
    },
    uniqueWidget = {
      ON = true,
      scale = 22, -- old default: 35,
      x = 0,
      y = 30, -- old default:  24,
      x_hv = 0,
      y_hv = 22,
      level = 1,
      anchor = "CENTER"
    },
    classWidget = {
      ON = false,
      scale = 22,
      x = -76,
      y = -7,
      x_hv = -74,
      y_hv = -7,
      theme = "default",
      anchor = "CENTER",
      ShowInHeadlineView = false,
    },
    targetWidget = {
      ON = true,
      theme = "default",
      r = 1,
      g = 1,
      b = 1,
      a = 1,
      ModeHPBar = false,
      ModeNames = false,
      HPBarColor = RGB(255, 0, 255), -- Magenta / Fuchsia
    },
    threatWidget = {
      ON = false,
      x = 0,
      y = 26,
      anchor = "CENTER",
    },
    tankedWidget = {
      ON = false,
      scale = 1,
      x = 65,
      y = 6,
      anchor = "CENTER",
    },
    comboWidget = {
      ON = true,
      scale = 1,
      x = 0,
      y = -8,
      x_hv = 0,
      y_hv = -16,
      ShowInHeadlineView = false,
    },
    --      eliteWidget = {
    --        ON = true,
    --        theme = "default",
    --        scale = 15,
    --        x = 64,
    --        y = 9,
    --        anchor = "CENTER"
    --      },
    socialWidget = {
      ON = false,
      scale = 16,
      x = 65,
      y = 6,
      x_hv = 65,
      y_hv = 6,
      --anchor = "Top",
      ShowInHeadlineView = true,
      ShowFriendIcon = true,
      ShowFactionIcon = false,
      ShowFriendColor = false,
      FriendColor = RGB(29, 39, 61),      -- Blizzard friend dark blue, color for healthbars of friends
      ShowGuildmateColor = false,
      GuildmateColor = RGB(60, 168, 255), -- light blue, color for healthbars of guildmembers
    },
    FactionWidget = {
      --ON = false,
      scale = 16,
      x = 0,
      y = 28,
      x_hv = 0,
      y_hv = 20,
      --anchor = "Top",
    },
    questWidget = {
      ON = true, -- old default: false
      scale = 20,
      x = 0,
      y = 20,
      x_hv = 0,
      y_hv = 20,
      alpha = 1,
      anchor = "CENTER",
      ModeHPBar = false, -- old default: true
      ModeIcon = true,
      HPBarColor = RGB(218, 165, 32), -- Golden rod
      ColorPlayerQuest = RGB(255, 215, 0), -- Golden
      ColorGroupQuest = RGB(32, 217, 114), -- See green-ish
      IconTexture = "QUESTICON",
      HideInCombat = false,
      HideInCombatAttacked = true,
      HideInInstance = true,
      ShowInHeadlineView = true,
    },
    stealthWidget = {
      ON = false,
      scale = 28,
      x = 0,
      y = 0,
      alpha = 1,
      anchor = "CENTER",
      ShowInHeadlineView = false,
    },
    ResourceWidget  = {
      ON = true,
      --ShowInHeadlineView = false,
      --scale = 28,
      x = 0,
      y = -18,
      ShowFriendly = false,
      ShowEnemyPlayer = false,
      ShowEnemyNPC = false,
      ShowEnemyBoss = true,
      ShowOnlyAltPower = true,
      ShowBar = true,
      BarHeight = 12,
      BarWidth = 80,
      BarTexture = "Smooth", -- old default: "Aluminium"
      BackgroundUseForegroundColor = false,
      BackgroundColor = RGB(0, 0, 0, 0.3),
      BorderTexture = "ThreatPlatesBorder",
      BorderEdgeSize = 1,
      BorderOffset = 1,
      BorderUseForegroundColor = false,
      BorderUseBackgroundColor = false,
      BorderColor = RGB(255, 255, 255, 1),
      --BorderInset = 4,
      --BorderTileSize = 16,
      ShowText = true,
      Font = DEFAULT_FONT,
      FontSize = 10,
      FontColor = RGB(255, 255, 255),
    },
    BossModsWidget = {
      ON = true,
      ShowInHeadlineView = true,
      x = 0,
      y = 66,
      x_hv = 0,
      y_hv = 40,
      scale = 40,
      AuraSpacing = 4,
      Font = DEFAULT_FONT,
      FontSize = 24,
      FontColor = RGB(255, 255, 255),
      -- TODO: add font flags like for custom text
    },
    TestWidget = {
      ON = true,
      BarWidth = 120,
      BarHeight = 10,
      BarTexture = "Smooth",
      BorderTexture = "TP_Border_1px",
      BorderBackground = "ThreatPlatesEmpty",
      EdgeSize = 5,
      Offset = 5,
      Inset = 5,
      Scale = 1,
    },
    totemSettings = GetDefaultTotemSettings(),
    uniqueSettings = {
      map = {},
      ["**"] = {
        name = "",
        showNameplate = true,
        ShowHeadlineView = false,
        showIcon = true,
        useStyle = true,
        useColor = true,
        UseThreatColor = false,
        UseThreatGlow = false,
        allowMarked = true,
        overrideScale = false,
        overrideAlpha = false,
        icon = "",
        scale = 1,
        alpha = 1,
        color = {
          r = 1,
          g = 1,
          b = 1
        },
      },
      [1] = {
        name = L["Shadow Fiend"],
        showNameplate = true,
        ShowHeadlineView = false,
        showIcon = false,
        useStyle = false,
        useColor = true,
        UseThreatColor = false,
        UseThreatGlow = false,
        allowMarked = true,
        overrideScale = false,
        overrideAlpha = false,
        icon = "Interface\\Addons\\TidyPlates_ThreatPlates\\Widgets\\UniqueIconWidget\\U1",
        scale = 0.45,
        alpha = 1,
        color = {
          r = 0.61,
          g = 0.40,
          b = 0.86
        },
      },
      [2] = {
        name = L["Spirit Wolf"],
        showNameplate = true,
        ShowHeadlineView = false,
        showIcon = false,
        useStyle = false,
        useColor = true,
        UseThreatColor = false,
        UseThreatGlow = false,
        allowMarked = true,
        overrideScale = false,
        overrideAlpha = false,
        icon = "Interface\\Addons\\TidyPlates_ThreatPlates\\Widgets\\UniqueIconWidget\\U2",
        scale = 0.45,
        alpha = 1,
        color = {
          r = 0.32,
          g = 0.7,
          b = 0.89
        },
      },
      [3] = {
        name = L["Ebon Gargoyle"],
        showNameplate = true,
        ShowHeadlineView = false,
        showIcon = false,
        useStyle = false,
        useColor = true,
        UseThreatColor = false,
        UseThreatGlow = false,
        allowMarked = true,
        overrideScale = false,
        overrideAlpha = false,
        icon = "Interface\\Addons\\TidyPlates_ThreatPlates\\Widgets\\UniqueIconWidget\\U3",
        scale = 0.45,
        alpha = 1,
        color = {
          r = 1,
          g = 0.71,
          b = 0
        },
      },
      [4] = {
        name = L["Water Elemental"],
        showNameplate = true,
        ShowHeadlineView = false,
        showIcon = false,
        useStyle = false,
        useColor = true,
        UseThreatColor = false,
        UseThreatGlow = false,
        allowMarked = true,
        overrideScale = false,
        overrideAlpha = false,
        icon = "Interface\\Addons\\TidyPlates_ThreatPlates\\Widgets\\UniqueIconWidget\\U4",
        scale = 0.45,
        alpha = 1,
        color = {
          r = 0.33,
          g = 0.72,
          b = 0.44
        },
      },
      [5] = {
        name = L["Treant"],
        showNameplate = true,
        ShowHeadlineView = false,
        showIcon = false,
        useStyle = false,
        useColor = true,
        UseThreatColor = false,
        UseThreatGlow = false,
        allowMarked = true,
        overrideScale = false,
        overrideAlpha = false,
        icon = "Interface\\Addons\\TidyPlates_ThreatPlates\\Widgets\\UniqueIconWidget\\U5",
        scale = 0.45,
        alpha = 1,
        color = {
          r = 1,
          g = 0.71,
          b = 0
        },
      },
      [6] = {
        name = L["Viper"],
        showNameplate = true,
        ShowHeadlineView = false,
        showIcon = true,
        useStyle = true,
        useColor = true,
        UseThreatColor = false,
        UseThreatGlow = false,
        allowMarked = true,
        overrideScale = false,
        overrideAlpha = false,
        icon = "Interface\\Addons\\TidyPlates_ThreatPlates\\Widgets\\UniqueIconWidget\\U6",
        scale = 0.45,
        alpha = 1,
        color = {
          r = 0.39,
          g = 1,
          b = 0.11
        },
      },
      [7] = {
        name = L["Venomous Snake"],
        showNameplate = true,
        ShowHeadlineView = false,
        showIcon = true,
        useStyle = true,
        useColor = true,
        UseThreatColor = false,
        UseThreatGlow = false,
        allowMarked = true,
        overrideScale = false,
        overrideAlpha = false,
        icon = "Interface\\Addons\\TidyPlates_ThreatPlates\\Widgets\\UniqueIconWidget\\U6",
        scale = 0.45,
        alpha = 1,
        color = {
          r = 0.75,
          g = 0,
          b = 0.02
        },
      },
      [8] = {
        name = L["Army of the Dead Ghoul"],
        showNameplate = true,
        ShowHeadlineView = false,
        showIcon = false,
        useStyle = true,
        useColor = true,
        UseThreatColor = false,
        UseThreatGlow = false,
        allowMarked = true,
        overrideScale = false,
        overrideAlpha = false,
        icon = "Interface\\Addons\\TidyPlates_ThreatPlates\\Widgets\\UniqueIconWidget\\U7",
        scale = 0.45,
        alpha = 1,
        color = {
          r = 0.87,
          g = 0.78,
          b = 0.88
        },
      },
      [9] = {
        name = L["Shadowy Apparition"],
        showNameplate = true,
        ShowHeadlineView = false,
        showIcon = true,
        useStyle = true,
        useColor = true,
        UseThreatColor = false,
        UseThreatGlow = false,
        allowMarked = true,
        overrideScale = false,
        overrideAlpha = false,
        icon = "Interface\\Addons\\TidyPlates_ThreatPlates\\Widgets\\UniqueIconWidget\\U8",
        scale = 1,
        alpha = 1,
        color = {
          r = 0.62,
          g = 0.19,
          b = 1
        },
      },
      [10] = {
        name = L["Shambling Horror"],
        showNameplate = true,
        ShowHeadlineView = false,
        showIcon = true,
        useStyle = true,
        useColor = true,
        UseThreatColor = false,
        UseThreatGlow = false,
        allowMarked = true,
        overrideScale = false,
        overrideAlpha = false,
        icon = "Interface\\Addons\\TidyPlates_ThreatPlates\\Widgets\\UniqueIconWidget\\U9",
        scale = 1,
        alpha = 1,
        color = {
          r = 0.69,
          g = 0.26,
          b = 0.25
        },
      },
      [11] = {
        name = L["Web Wrap"],
        showNameplate = true,
        ShowHeadlineView = false,
        showIcon = true,
        useStyle = true,
        useColor = true,
        UseThreatColor = false,
        UseThreatGlow = false,
        allowMarked = true,
        overrideScale = false,
        overrideAlpha = false,
        icon = "Interface\\Addons\\TidyPlates_ThreatPlates\\Widgets\\UniqueIconWidget\\U10",
        scale = 0.75,
        alpha = 1,
        color = {
          r = 1,
          g = 0.39,
          b = 0.96
        },
      },
      [12] = {
        name = L["Immortal Guardian"],
        showNameplate = true,
        ShowHeadlineView = false,
        showIcon = true,
        useStyle = true,
        useColor = true,
        UseThreatColor = false,
        UseThreatGlow = false,
        allowMarked = true,
        overrideScale = false,
        overrideAlpha = false,
        icon = "Interface\\Addons\\TidyPlates_ThreatPlates\\Widgets\\UniqueIconWidget\\U11",
        scale = 1,
        alpha = 1,
        color = {
          r = 0.33,
          g = 0.33,
          b = 0.33
        },
      },
      [13] = {
        name = L["Marked Immortal Guardian"],
        showNameplate = true,
        ShowHeadlineView = false,
        showIcon = true,
        useStyle = true,
        useColor = true,
        UseThreatColor = false,
        UseThreatGlow = false,
        allowMarked = true,
        overrideScale = false,
        overrideAlpha = false,
        icon = "Interface\\Addons\\TidyPlates_ThreatPlates\\Widgets\\UniqueIconWidget\\U12",
        scale = 1,
        alpha = 1,
        color = {
          r = 0.75,
          g = 0,
          b = 0.02
        },
      },
      [14] = {
        name = L["Empowered Adherent"],
        showNameplate = true,
        ShowHeadlineView = false,
        showIcon = true,
        useStyle = true,
        useColor = true,
        UseThreatColor = false,
        UseThreatGlow = false,
        allowMarked = true,
        overrideScale = false,
        overrideAlpha = false,
        icon = "Interface\\Addons\\TidyPlates_ThreatPlates\\Widgets\\UniqueIconWidget\\U13",
        scale = 1,
        alpha = 1,
        color = {
          r = 0.29,
          g = 0.11,
          b = 1
        },
      },
      [15] = {
        name = L["Deformed Fanatic"],
        showNameplate = true,
        ShowHeadlineView = false,
        showIcon = true,
        useStyle = true,
        useColor = true,
        UseThreatColor = false,
        UseThreatGlow = false,
        allowMarked = true,
        overrideScale = false,
        overrideAlpha = false,
        icon = "Interface\\Addons\\TidyPlates_ThreatPlates\\Widgets\\UniqueIconWidget\\U14",
        scale = 1,
        alpha = 1,
        color = {
          r = 0.55,
          g = 0.7,
          b = 0.29
        },
      },
      [16] = {
        name = L["Reanimated Adherent"],
        showNameplate = true,
        ShowHeadlineView = false,
        showIcon = true,
        useStyle = true,
        useColor = true,
        UseThreatColor = false,
        UseThreatGlow = false,
        allowMarked = true,
        overrideScale = false,
        overrideAlpha = false,
        icon = "Interface\\Addons\\TidyPlates_ThreatPlates\\Widgets\\UniqueIconWidget\\U15",
        scale = 1,
        alpha = 1,
        color = {
          r = 1,
          g = 0.88,
          b = 0.61
        },
      },
      [17] = {
        name = L["Reanimated Fanatic"],
        showNameplate = true,
        ShowHeadlineView = false,
        showIcon = true,
        useStyle = true,
        useColor = true,
        UseThreatColor = false,
        UseThreatGlow = false,
        allowMarked = true,
        overrideScale = false,
        overrideAlpha = false,
        icon = "Interface\\Addons\\TidyPlates_ThreatPlates\\Widgets\\UniqueIconWidget\\U15",
        scale = 1,
        alpha = 1,
        color = {
          r = 1,
          g = 0.88,
          b = 0.61
        },
      },
      [18] = {
        name = L["Bone Spike"],
        showNameplate = true,
        ShowHeadlineView = false,
        showIcon = true,
        useStyle = true,
        useColor = true,
        UseThreatColor = false,
        UseThreatGlow = false,
        allowMarked = true,
        overrideScale = false,
        overrideAlpha = false,
        icon = "Interface\\Addons\\TidyPlates_ThreatPlates\\Widgets\\UniqueIconWidget\\U16",
        scale = 1,
        alpha = 1,
        color = {
          r = 1,
          g = 1,
          b = 1
        },
      },
      [19] = {
        name = L["Onyxian Whelp"],
        showNameplate = false,
        ShowHealthbarView = true,
        ShowHeadlineView = false,
        showIcon = true,
        useStyle = true,
        useColor = true,
        UseThreatColor = false,
        UseThreatGlow = false,
        allowMarked = true,
        overrideScale = false,
        overrideAlpha = false,
        icon = "Interface\\Addons\\TidyPlates_ThreatPlates\\Widgets\\UniqueIconWidget\\U17",
        scale = 1,
        alpha = 1,
        color = {
          r = 0.33,
          g = 0.28,
          b = 0.71
        },
      },
      [20] = {
        name = L["Gas Cloud"],
        showNameplate = true,
        ShowHeadlineView = false,
        showIcon = true,
        useStyle = true,
        useColor = true,
        UseThreatColor = false,
        UseThreatGlow = false,
        allowMarked = true,
        overrideScale = false,
        overrideAlpha = false,
        icon = "Interface\\Addons\\TidyPlates_ThreatPlates\\Widgets\\UniqueIconWidget\\U18",
        scale = 1,
        alpha = 1,
        color = {
          r = 0.96,
          g = 0.56,
          b = 0.07
        },
      },
      [21] = {
        name = L["Volatile Ooze"],
        showNameplate = true,
        ShowHeadlineView = false,
        showIcon = true,
        useStyle = true,
        useColor = true,
        UseThreatColor = false,
        UseThreatGlow = false,
        allowMarked = true,
        overrideScale = false,
        overrideAlpha = false,
        icon = "Interface\\Addons\\TidyPlates_ThreatPlates\\Widgets\\UniqueIconWidget\\U19",
        scale = 1,
        alpha = 1,
        color = {
          r = 0.36,
          g = 0.95,
          b = 0.33
        },
      },
      [22] = {
        name = L["Darnavan"],
        showNameplate = true,
        ShowHeadlineView = false,
        showIcon = true,
        useStyle = true,
        useColor = true,
        UseThreatColor = false,
        UseThreatGlow = false,
        allowMarked = true,
        overrideScale = false,
        overrideAlpha = false,
        icon = "Interface\\Addons\\TidyPlates_ThreatPlates\\Widgets\\UniqueIconWidget\\U20",
        scale = 1,
        alpha = 1,
        color = {
          r = 0.78,
          g = 0.61,
          b = 0.43
        },
      },
      [23] = {
        name = L["Val'kyr Shadowguard"],
        showNameplate = true,
        ShowHeadlineView = false,
        showIcon = true,
        useStyle = true,
        useColor = true,
        UseThreatColor = false,
        UseThreatGlow = false,
        allowMarked = true,
        overrideScale = false,
        overrideAlpha = false,
        icon = "Interface\\Addons\\TidyPlates_ThreatPlates\\Widgets\\UniqueIconWidget\\U21",
        scale = 1,
        alpha = 1,
        color = {
          r = 0.47,
          g = 0.89,
          b = 1
        },
      },
      [24] = {
        name = L["Kinetic Bomb"],
        showNameplate = true,
        ShowHeadlineView = false,
        showIcon = true,
        useStyle = true,
        useColor = true,
        UseThreatColor = false,
        UseThreatGlow = false,
        allowMarked = true,
        overrideScale = false,
        overrideAlpha = false,
        icon = "Interface\\Addons\\TidyPlates_ThreatPlates\\Widgets\\UniqueIconWidget\\U22",
        scale = 1,
        alpha = 1,
        color = {
          r = 0.91,
          g = 0.71,
          b = 0.1
        },
      },
      [25] = {
        name = L["Lich King"],
        showNameplate = true,
        ShowHeadlineView = false,
        showIcon = false,
        useStyle = true,
        useColor = true,
        UseThreatColor = false,
        UseThreatGlow = false,
        allowMarked = true,
        overrideScale = false,
        overrideAlpha = false,
        icon = "Interface\\Addons\\TidyPlates_ThreatPlates\\Widgets\\UniqueIconWidget\\U23",
        scale = 1,
        alpha = 1,
        color = {
          r = 0.77,
          g = 0.12,
          b = 0.23
        },
      },
      [26] = {
        name = L["Raging Spirit"],
        showNameplate = true,
        ShowHeadlineView = false,
        showIcon = true,
        useStyle = true,
        useColor = true,
        UseThreatColor = false,
        UseThreatGlow = false,
        allowMarked = true,
        overrideScale = false,
        overrideAlpha = false,
        icon = "Interface\\Addons\\TidyPlates_ThreatPlates\\Widgets\\UniqueIconWidget\\U24",
        scale = 1,
        alpha = 1,
        color = {
          r = 0.77,
          g = 0.27,
          b = 0
        },
      },
      [27] = {
        name = L["Drudge Ghoul"],
        showNameplate = true,
        ShowHeadlineView = false,
        showIcon = false,
        useStyle = true,
        useColor = true,
        UseThreatColor = false,
        UseThreatGlow = false,
        allowMarked = true,
        overrideScale = false,
        overrideAlpha = false,
        icon = "Interface\\Addons\\TidyPlates_ThreatPlates\\Widgets\\UniqueIconWidget\\U25",
        scale = 0.85,
        alpha = 1,
        color = {
          r = 0.43,
          g = 0.43,
          b = 0.43
        },
      },
      [28] = {
        name = L["Living Inferno"],
        showNameplate = true,
        ShowHeadlineView = false,
        showIcon = true,
        useStyle = true,
        useColor = true,
        UseThreatColor = false,
        UseThreatGlow = false,
        allowMarked = true,
        overrideScale = false,
        overrideAlpha = false,
        icon = "Interface\\Addons\\TidyPlates_ThreatPlates\\Widgets\\UniqueIconWidget\\U27",
        scale = 1,
        alpha = 1,
        color = {
          r = 0,
          g = 1,
          b = 0
        },
      },
      [29] = {
        name = L["Living Ember"],
        showNameplate = true,
        ShowHeadlineView = false,
        showIcon = false,
        useStyle = true,
        useColor = true,
        UseThreatColor = false,
        UseThreatGlow = false,
        allowMarked = true,
        overrideScale = false,
        overrideAlpha = false,
        icon = "Interface\\Addons\\TidyPlates_ThreatPlates\\Widgets\\UniqueIconWidget\\U28",
        scale = 0.60,
        alpha = 0.75,
        color = {
          r = 0.25,
          g = 0.25,
          b = 0.25
        },
      },
      [30] = {
        name = L["Fanged Pit Viper"],
        showNameplate = false,
        ShowHealthbarView = true,
        ShowHeadlineView = false,
        showIcon = false,
        useStyle = true,
        useColor = true,
        UseThreatColor = false,
        UseThreatGlow = false,
        allowMarked = true,
        overrideScale = false,
        overrideAlpha = false,
        icon = "",
        scale = 0,
        alpha = 0,
        color = {
          r = 1,
          g = 1,
          b = 1
        },
      },
      [31] = {
        name = L["Canal Crab"],
        showNameplate = true,
        ShowHeadlineView = false,
        showIcon = true,
        useStyle = true,
        useColor = true,
        UseThreatColor = false,
        UseThreatGlow = false,
        allowMarked = true,
        overrideScale = false,
        overrideAlpha = false,
        icon = "Interface\\Addons\\TidyPlates_ThreatPlates\\Widgets\\UniqueIconWidget\\U29",
        scale = 1,
        alpha = 1,
        color = {
          r = 0,
          g = 1,
          b = 1
        },
      },
      [32] = {
        name = L["Muddy Crawfish"],
        showNameplate = false,
        ShowHeadlineView = true,
        showIcon = false,
        useStyle = false,
        useColor = true,
        UseThreatColor = false,
        UseThreatGlow = false,
        allowMarked = true,
        overrideScale = false,
        overrideAlpha = false,
        icon = "Interface\\Addons\\TidyPlates_ThreatPlates\\Widgets\\UniqueIconWidget\\U30",
        scale = 1,
        alpha = 1,
        color = {
          r = 0.96,
          g = 0.36,
          b = 0.34
        },
      },
      [33] = {
		name = "魔化炸彈",
		showNameplate = true,
		ShowHeadlineView = false,
		showIcon = false,
		useStyle = true,
		useColor = true,
		UseThreatColor = false,
		UseThreatGlow = false,
		allowMarked = true,
		overrideScale = false,
		overrideAlpha = false,
		icon = "",
		scale = 2,
		alpha = 1,
		color = {
		r = 1,
		g = 0,
		b = 0
		},
	  },
      [34] = {},
      [35] = {},
      [36] = {},
      [37] = {},
      [38] = {},
      [39] = {},
      [40] = {},
      [41] = {},
      [42] = {},
      [43] = {},
      [44] = {},
      [45] = {},
      [46] = {},
      [47] = {},
      [48] = {},
      [49] = {},
      [50] = {},
      [51] = {},
      [52] = {},
      [53] = {},
      [54] = {},
      [55] = {},
      [56] = {},
      [57] = {},
      [58] = {},
      [59] = {},
      [60] = {},
      [61] = {},
      [62] = {},
      [63] = {},
      [64] = {},
      [65] = {},
      [66] = {},
      [67] = {},
      [68] = {},
      [69] = {},
      [70] = {},
      [71] = {},
      [72] = {},
      [73] = {},
      [74] = {},
      [75] = {},
      [76] = {},
      [77] = {},
      [78] = {},
      [79] = {},
      [80] = {},
    },
    settings = {
      frame = {
        x = 0,
        y = 0,
        width = 110,
        height = 45,
        SyncWithHealthbar = true,
      },
      highlight = {
        -- texture = "TP_HealthBarHighlight", -- removed in 8.7.0
        show = true,
      },
      elitehealthborder = {
        texture = "TP_EliteBorder_Default",
        show = false, -- old default: true
      },
      healthborder = {
        texture = "TP_Border_Thin", -- old default: "TP_HealthBarOverlay",
        backdrop = "",
        EdgeSize = 1,
        Offset = 1,
        show = true,
      },
      threatborder = {
        show = true,
      },
      healthbar = {
        width = 100,
        height = 8,
        texture = "Smooth", -- old default: "ThreatPlatesBar",
        backdrop = "Smooth", -- old default: "ThreatPlatesEmpty",
        BackgroundUseForegroundColor = false,
        BackgroundOpacity = 0.7, -- old default: 1,
        BackgroundColor = RGB(0, 0, 0),
        ShowAbsorbs = true,
        AbsorbColor = RGB(0, 255, 255, 1),
        AlwaysFullAbsorb = false,
        OverlayTexture = true,
        OverlayColor = RGB(0, 128, 255, 1),
      },
      castnostop = {
        show = true,
        ShowOverlay = true,
        ShowInterruptShield = true,
      },
      castborder = {
        texture = "TP_Castbar_Border_Thin", -- old default: "TP_CastBarOverlay",
        EdgeSize = 1,
        Offset = 1,
        show = true,
      },
      castbar = {
        width = 104,
        height = 8,
        texture = "Smooth", -- old default: "ThreatPlatesBar",
        backdrop = "Smooth",
        BackgroundUseForegroundColor = false,
        BackgroundOpacity = 0.3,
        BackgroundColor = RGB(0, 0, 0),
        x = 0,
        y = 14,
        x_hv = 0,
        y_hv = 14,
        x_target = 0,
        y_target = 0,
        show = true,
        ShowInHeadlineView = false,
      },
      name = { -- Names for Healthbar View
        show = true,
        typeface = DEFAULT_FONT, -- old default: "Accidental Presidency",
        size = 11, -- old default: 14
        shadow = true,
        flags = "NONE",
        width = 140, -- old default: 116,
        height = 14,
        x = 0,
        y = 13,
        align = "CENTER",
        vertical = "CENTER",
        --
        EnemyTextColorMode = "CUSTOM",
        EnemyTextColor = RGB(255, 255, 255),
        FriendlyTextColorMode = "CUSTOM",
        FriendlyTextColor = RGB(255, 255, 255),
        UseRaidMarkColoring = false,
      },
      level = {
        typeface = DEFAULT_FONT, -- old default: "Accidental Presidency",
        size = 9, -- old default: 12,
        width = 20,
        height = 10, -- old default: 14,
        x = 49, -- old default: 50,
        y = 0,
        align = "RIGHT",
        vertical = "CENTER", -- old default: "TOP",
        shadow = true,
        flags = "NONE",
        show = false,
      },
      eliteicon = {
        show = true,
        theme = "default",
        scale = 15,
        x = 51, -- old default: 64
        y = 5, -- old default: 9
        level = 22,
        anchor = "CENTER"
      },
      customtext = {
        typeface = DEFAULT_FONT, -- old default: "Accidental Presidency",
        size = 9, -- old default: 12,
        width = 110,
        height = 14,
        x = 0,
        y = 0, -- old default: 1,
        align = "CENTER",
        vertical = "CENTER",
        shadow = true,
        flags = "NONE",
        --
        FriendlySubtext = "HEALTH",
        EnemySubtext = "HEALTH",
        SubtextColorUseHeadline = false,
        SubtextColorUseSpecific = false,
        SubtextColor =  RGB(255, 255, 255, 1),
      },
      spelltext = {
        typeface = DEFAULT_FONT, -- old default: "Accidental Presidency",
        size = 12,  -- old default: 12
        width = 110,
        height = 14,
        x = 0,
        y = 10,  -- old default: -13
        x_hv = 0,
        y_hv = 10,  -- old default: -13
        align = "CENTER",
        vertical = "CENTER",
        shadow = true,
        flags = "OUTLINE",
        show = true,
      },
      raidicon = {
        scale = 20,
        x = 0,
        y = 30, -- old default: 27
        x_hv = 0,
        y_hv = 25,
        anchor = "CENTER",
        hpColor = true,
        show = true,
        ShowInHeadlineView = false,
        hpMarked = {
          ["STAR"] = RGB_P(0.85, 0.81, 0.27),
          ["MOON"] = RGB_P(0.60, 0.75, 0.85),
          ["CIRCLE"] = RGB_P(0.93, 0.51,0.06),
          ["SQUARE"] = RGB_P(0, 0.64, 1),
          ["DIAMOND"] = RGB_P(0.7, 0.06, 0.84),
          ["CROSS"] = RGB_P(0.82, 0.18, 0.18),
          ["TRIANGLE"] = RGB_P(0.14, 0.66, 0.14),
          ["SKULL"] = RGB_P(0.89, 0.83, 0.74),
        },
      },
      spellicon = {
        scale = 30,
        x = 70,
        y = 6,
        x_hv = 70,
        y_hv = 6,
        anchor = "CENTER",
        show = true,
      },
      customart = {
        scale = 22,
        x = -74,
        y = -7,
        anchor = "CENTER",
        show = true,
      },
      skullicon = {
        scale = 16,
        x = 51, -- old default: 55
        y = -8,
        anchor = "CENTER",
        show = true,
      },
      unique = {
        threatcolor = {
          LOW = RGB_P(0, 0, 0, 0),
          MEDIUM = RGB_P(0, 0, 0, 0),
          HIGH = RGB_P(0, 0, 0, 0),
        },
      },
      totem = {
        threatcolor = {
          LOW = RGB_P(0, 0, 0, 0),
          MEDIUM = RGB_P(0, 0, 0, 0),
          HIGH = RGB_P(0, 0, 0, 0),
        },
      },
      normal = {
        threatcolor = {
          LOW = RGB_P(1, 1, 1, 1),
          MEDIUM = RGB_P(1, 1, 0, 1),
          HIGH = RGB_P(1, 0, 0, 1),
        },
      },
      dps = {
        threatcolor = {
          LOW = RGB_P(0, 1, 0, 1),
          MEDIUM = RGB_P(1, 1, 0, 1),
          HIGH = RGB_P(1, 0, 0, 1),
        },
      },
      tank = {
        threatcolor = {
          LOW = RGB_P(1, 0, 0, 1),
          MEDIUM = RGB_P(1, 1, 0, 1),
          HIGH = RGB_P(0, 1, 0, 1),
          OFFTANK = RGB(15, 170, 200, 1),
        },
      },
    },
    threat = {
      ON = true,
      marked = false,
      nonCombat = true,
      hideNonCombat = false,
      useType = true,
      useScale = true,
      AdditiveScale = true,
      useAlpha = true,
      AdditiveAlpha = true,
      useHPColor = true,
      art = {
        ON = true,
        theme = "default",
      },
      --        scaleType = {
      --          ["Normal"] = -0.2,
      --          ["Elite"] = 0,
      --          ["Boss"] = 0.2,
      --          ["Minus"] = -0.2,
      --        },
      toggle = {
        ["Boss"]	= true,
        ["Elite"]	= true,
        ["Normal"]	= true,
        ["Neutral"]	= true,
        ["Minus"] 	= true,
        ["Tapped"] 	= true,
        ["OffTank"] = true,
        ["InstancesOnly"] = false,
      },
      dps = {
        scale = {
          LOW 		= -0.2,
          MEDIUM		= -0.1,
          HIGH 		= 0, -- old default: 1.25,
        },
        alpha = {
          LOW 		= 1,
          MEDIUM		= 1,
          HIGH 		= 1
        },
      },
      tank = {
        scale = {
          LOW 		= 0, -- old default: 1.25,
          MEDIUM		= -0.1,
          HIGH 		= -0.2,
          OFFTANK = -0.2
        },
        alpha = {
          LOW 		= 1,
          MEDIUM		= 1,
          HIGH 		= 1,
          OFFTANK = 0.75
        },
      },
      marked = {
        alpha = false,
        art = false,
        scale = false
      },
    },
    nameplate = {
      toggle = {
        ["Boss"]	= true,
        ["Elite"]	= true,
        ["Normal"]	= true,
        ["Neutral"]	= true,
        ["Minus"]	= true,
        ["Tapped"] 	= true,
        ["TargetA"]  = false,   -- Target Alpha
        ["NonTargetA"]	= true, -- Non-Target Alpha
        ["NoTargetA"]  = false, -- No Target Alpha
        ["TargetS"]  = true,   -- Target Scale
        ["NonTargetS"]	= false, -- Non-Target Scale
        ["NoTargetS"]  = false, -- No Target Scale
        ["MarkedA"] = false,
        ["MarkedS"] = false,
        ["CastingUnitAlpha"] = false, -- Friendly Unit Alpha
        ["CastingEnemyUnitAlpha"] = false,
        ["CastingUnitScale"] = false, -- Friendly Unit Scale
        ["CastingEnemyUnitScale"] = false,
        ["MouseoverUnitAlpha"] = false,
        ["MouseoverUnitScale"] = false,
      },
      scale = {
        AbsoluteTargetScale  = false,
        ["Target"]	  	     = 0.2,
        ["NonTarget"]	       = -0.3,
        ["NoTarget"]	       = 0,
        ["Totem"]		         = 0.75,
        ["Marked"] 		       = 1.3,
        --["Normal"]		     = 1,
        ["CastingUnit"]      = 1.3,  -- Friendly Unit Scale
        ["CastingEnemyUnit"] = 1.3,
        ["MouseoverUnit"]    = 1.3,
        ["FriendlyPlayer"]   = 1,
        ["FriendlyNPC"]      = 1,
        ["Neutral"]		       = 0.9,
        ["EnemyPlayer"]      = 1,
        ["EnemyNPC"]         = 1,
        ["Elite"]		         = 1.04,
        ["Boss"]		         = 1.1,
        ["Guardian"]         = 0.75,
        ["Pet"]              = 0.75,
        ["Minus"]	           = 0.6,
        ["Tapped"] 		       = 0.9,
      },
      alpha = {
        AbsoluteTargetAlpha  = false,
        ["Target"]		       = 1,
        ["NonTarget"]	       = 0.7,
        ["NoTarget"]	       = 1,
        ["Totem"]		         = 1,
        ["Marked"] 		       = 1,
        --["Normal"]		     = 1,
        ["CastingUnit"]	     = 1,  -- Friendly Unit Alpha
        ["CastingEnemyUnit"] = 1,
        ["MouseoverUnit"]	   = 1,
        ["FriendlyPlayer"]   = 1,
        ["FriendlyNPC"]      = 1,
        ["Neutral"]		       = 1,
        ["EnemyPlayer"]      = 1,
        ["EnemyNPC"]         = 1,
        ["Elite"]		         = 1,
        ["Boss"]		         = 1,
        ["Guardian"]         = 0.8,
        ["Pet"]              = 0.8,
        ["Minus"]	           = 0.8,
        ["Tapped"]		       = 1,
      },
    },
  }
}