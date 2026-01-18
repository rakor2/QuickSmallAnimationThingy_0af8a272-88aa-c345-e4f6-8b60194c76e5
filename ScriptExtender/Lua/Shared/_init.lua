Ext.Require("Shared/LibLib/_init.lua")
setmetatable(Mods.QSAT, { __index = Mods.BG3AF }) --it's joever, my mod is Skizzed and haunted with Satan FeelsGoodMan

-- This only for removing yellow thing Gladge
AnimationSet = AnimationSet or {}
EmoteCollection = EmoteCollection or {}
EmotePose = EmotePose or {}
FaceExpression = FaceExpression or {}
TemplateAnimationSetOverride = TemplateAnimationSetOverride or {}

Ext.Require("Shared/Tables.lua")
Ext.Require("Shared/SharedHandlers.lua")
