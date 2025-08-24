Ext.Require("Shared/LibLib/_init.lua")
setmetatable(Mods.QSAT, { __index = Mods.BG3AF }) --it's joever, my mod is Skizzed and haunted with Satan FeelsGoodMan
AnimationSet = AnimationSet or {}
EmoteCollection = EmoteCollection or {}
EmotePose = EmotePose or {}
Ext.Require("Shared/Tables.lua")
Ext.Require("Shared/SharedHandlers.lua")

--[[
x = Ext.StaticData.GetAll('PhotoModeBlueprintOverride')
for k,v in pairs(x) do
    local bp = Ext.StaticData.Get(v, 'PhotoModeBlueprintOverride')
    bp.DummyBlueprintUUID = '2fa7fff7-3870-90e7-8d1e-49bac4a0b5eb'
end
]]--


