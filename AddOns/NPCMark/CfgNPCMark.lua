U1RegisterAddon("NPCMark", {
    title = "地图NPC标记",
    defaultEnable = 0,
    load = "DEMAND",
    --nolodbutton = 1,

    tags = { TAG_MAPQUEST },
    icon = [[Interface\ICONS\INV_Misc_Map08]],

    author = "大脚Terry",
    modifier = "静谧的狼狈(7.0)",

    toggle = function(name, info, enable, justload)
        if not justload then
            NPCM_ToggleEnable(enable and 1 or 0)
        else
            if WorldMapFrame:IsVisible() then
                NPCMark_WorldMapFrameOnShow()
            end
            if NPCMarkLoadButton then NPCMarkLoadButton:Hide() end
        end
    end,

    {
        text = "始终自动加载",
        tip = "说明`为了节省内存,默认每次都要点一下地图上的按钮才加载, 选中此项可以进游戏就自动加载",
        default = nil,
        var = "autoLoad",
    }
});

if WW then
    local btn = WW:Button("NPCMarkLoadButton", WorldMapFrame.UIElementsFrame, "UIPanelButtonTemplate")
    :SetScale(0.9)
    :SetText("NPC标记")
    :SetTextFont(ChatFontNormal, 12, "")
    :SetWidth(65)
    :TR(-40, -2)
    :AddFrameLevel(3)
    :SetScript("OnClick", function(self) U1LoadAddOn("NPCMark") end)
    :un()

    CoreRegisterEvent("INIT_COMPLETED", { INIT_COMPLETED = function()
        if U1GetCfgValue("NPCMark", "autoLoad") then
            U1LoadAddOn("NPCMark")
        end
    end })
end

