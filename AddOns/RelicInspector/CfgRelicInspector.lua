U1RegisterAddon("RelicInspector", {
    title = "神器圣物信息",
    tags = { TAG_ITEM },
    defaultEnable = 1,

    desc = "不需切换专精就可以显示神器嵌入的圣物信息，以及各圣物在不同专精下的效果。`查看神器时按住CTRL键可以显示更详细的信息。",

    nopic = 1,
    icon = [[Interface\Icons\INV_Relics_6oRunestone_OgreMissive]], --花蕾的图标

    toggle = function(name, info, enable, justload)
        return true
    end,

});
