--[[
Blip.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

BuildEnv(...)

Blip = Addon:NewClass('Blip', 'Button')

function Blip:Constructor()
    local Icon = self:CreateTexture(nil, 'ARTWORK') do
        Icon:SetAllPoints(self)
        Icon:SetAtlas('QuestNormal')
        Icon:SetVertexColor(0, 1, 0)
    end

    local AnimParent = CreateFrame('Frame', nil, self) do
        AnimParent:SetAllPoints(self)
    end

    local Anim = AnimParent:CreateAnimationGroup() do
        Anim:SetLooping('REPEAT')
    end

    local Grow = Anim:CreateAnimation('Scale') do
        Grow:SetOrigin('CENTER', 0, 0)
        Grow:SetOrder(0)
        Grow:SetScale(3, 3)
        Grow:SetDuration(1)
    end

    local Texture = AnimParent:CreateTexture(nil, 'OVERLAY') do
        Texture:SetAllPoints(AnimParent)
        Texture:SetBlendMode('ADD')
        Texture:SetTexture([[Interface\Cooldown\starburst]])
    end

    self.Icon = Icon

    self:SetFrameLevel(1300)
    Anim:Play()
end
