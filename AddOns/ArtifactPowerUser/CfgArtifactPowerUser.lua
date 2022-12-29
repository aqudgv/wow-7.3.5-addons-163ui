U1RegisterAddon("ArtifactPowerUser", {
    title = "一键神器能量",
    tags = { TAG_ITEM },
    defaultEnable = 0,

    desc = "如果背包中有神器能量物品，会在屏幕上增加一个快捷按钮，点击此按钮即可依次使用。右键点击图标可以选择在哪些专精下启用，防止误吃。`可以使用命令/apu进行设置`/apu enable - 当前专精显示`/apu size 60 - 设置大小`/apu lock - 锁定位置`/apu unlock - 可拖动`/apu reset - 重置位置",

    nopic = 1,
    icon = 1052641, --随机奖励的图标

    toggle = function(name, info, enable, justload)
        return true
    end,
});
