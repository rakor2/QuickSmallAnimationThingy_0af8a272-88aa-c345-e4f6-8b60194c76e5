
Ext.Require("_Libs/_InitLibs.lua")



-- ---@param animation string | ResourceAnimationResource
-- ---@return string
-- function getAnimationName(animation)
--     local anim = Ext.Resource.Get(animation, 'Animation')
--     local sourceFile = anim.SourceFile
--     if sourceFile then
--         local animationName = sourceFile:match("^.+/(.+)$"):match("(.+)%..+$")
--         return animationName
--     end
-- end

---@param animation string | ResourceAnimationResource
---@return string
function getAnimationName(animation)
    local anim = Ext.Resource.Get(animation, 'Animation')
    if not anim or not anim.SourceFile then
        DWarn('Invalid animation: ' .. tostring(animation))
        return 'Invalid animation name'
    end
    local sourceFile = anim.SourceFile
    local n = sourceFile:match("([^/]+)$") or sourceFile
    local animationName = n:match("(.+)%..+$") or n
    return animationName
end

function ForceGenerateAnimationsWithNames()
    NamedAnimations = {}
    AllAnimations = Ext.Resource.GetAll('Animation')
    for _, animation in pairs(AllAnimations) do
        local animationName = getAnimationName(animation)
        NamedAnimations[animationName] = animation
    end
    Ext.IO.SaveFile("QuickSmallAnimationThingy/AllNamedAnimations.json", Ext.DumpExport(NamedAnimations))
    table.sort(NamedAnimations)
    DPrint('All animations are saved to the local file')
    return NamedAnimations
end

---Gets all animations and assigns their name to them
---@return table<string, string>
function getAllAnimationsWithNames()
    if NamedAnimations == nil then
        if Ext.IO.LoadFile("QuickSmallAnimationThingy/AllNamedAnimations.json") then
            NamedAnimations = Ext.Json.Parse(Ext.IO.LoadFile("QuickSmallAnimationThingy/AllNamedAnimations.json"))
            DPrint('All animations loaded from the local file')
            return NamedAnimations
        else
            NamedAnimations = ForceGenerateAnimationsWithNames()
            return NamedAnimations
        end
    end
end
getAllAnimationsWithNames()


Ext.Require("Shared/_init.lua")



if Ext.IO.LoadFile('QuickSmallAnimationThingy/Favorites.json') then
    NamedFavAnimations = Ext.Json.Parse(Ext.IO.LoadFile('QuickSmallAnimationThingy/Favorites.json'))
    DPrint('Favorite animations loaded from the local file')
else
    NamedFavAnimations = {}
    DPrint('No favorite animations')
end


Ext.Require("Client/_init.lua")