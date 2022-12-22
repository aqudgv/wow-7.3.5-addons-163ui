--[[
    https://uWow.biz/
    Author: Glazzer
]]

local _, NS = ...
local Locale = GetLocale()

local L =
{
	__index = function(_, k)
		return format("[%s] %s", Locale, tostring(k))
	end
}

function NS:NewLocale()
	return setmetatable({}, L)
end

function NS:IsSameLocale(name1, name2, name3)
	local l = GetLocale()
	return name1 == l or name2 == l or name3 == l
end
