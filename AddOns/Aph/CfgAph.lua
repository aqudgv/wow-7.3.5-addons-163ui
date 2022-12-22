U1RegisterAddon("Aph", {
    title = "神器能量助手",
    defaultEnable = 1,

    tags = { TAG_ITEM, TAG_GOOD },
    icon = 255347,
    nopic = 1,

    modifier = "warbaby",

    desc = "一个比'一键神器能量(apu)'更强大和详细的神器信息插件，可以计算背包（或银行）里所有神器能量的总和，还可以计算当前世界任务能够获得的神器能量。`同时可以列出所有的神器能量物品，方便使用。`插件会列出你所有神器，左键点击可以吃能量或者切换到对应专精，右键点击则可以弹出神器界面。`插件窗口可以显示为精简模式，战斗时会自动隐藏。通过命令/aph可以调出设置界面。",


    toggle = function(name, info, enable, justload)
        if justload then return end
        local APH = LibStub("AceAddon-3.0"):GetAddon("APH")
        APH.originPreUpdate = APH.originPreUpdate or APH.PreUpdate
        if enable then
            APH.PreUpdate = APH.originPreUpdate
            APH:RegisterEvent("PLAYER_REGEN_DISABLED")
            APH:RegisterEvent("PLAYER_REGEN_ENABLED")
            APH:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
            APH:RegisterEvent("PLAYER_ENTERING_WORLD")
            APH:RegisterEvent("PLAYER_LEAVING_WORLD")
            APH:RegisterEvent("ARTIFACT_XP_UPDATE")
            APH:RegisterEvent("ARTIFACT_UPDATE")
            APH:RegisterEvent("BANKFRAME_CLOSED")
            APH:RegisterEvent("BANKFRAME_OPENED")
            APH:RegisterEvent("WORLD_MAP_UPDATE")
            APH:PreUpdate(true)
        else
            APH.PreUpdate = noop
            APH:UnregisterAllEvents()
            APHMainFrame:Hide()
            APHMinimizedFrame:Hide()
        end
    end,
});
