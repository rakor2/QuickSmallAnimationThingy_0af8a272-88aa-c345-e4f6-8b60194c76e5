--[[
██╗      █████╗  ██████╗     ███╗   ███╗ █████╗  ██████╗██╗  ██╗██╗███╗   ██╗███████╗
██║     ██╔══██╗██╔════╝     ████╗ ████║██╔══██╗██╔════╝██║  ██║██║████╗  ██║██╔════╝
██║     ███████║██║  ███╗    ██╔████╔██║███████║██║     ███████║██║██╔██╗ ██║█████╗  
██║     ██╔══██║██║   ██║    ██║╚██╔╝██║██╔══██║██║     ██╔══██║██║██║╚██╗██║██╔══╝  
███████╗██║  ██║╚██████╔╝    ██║ ╚═╝ ██║██║  ██║╚██████╗██║  ██║██║██║ ╚████║███████╗
╚══════╝╚═╝  ╚═╝ ╚═════╝     ╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝╚══════╝
]]


---@class QSAT #I guess?
QSAT = QSAT or {}


NamedFavAnimations = NamedFavAnimations or {}
NamedHistAnimations = NamedHistAnimations or {}




---Creates named options for the combo
---@return string[]
function createAnimationOptions()
    Globals.AnimationOptions = {}
    for animationName, animationID in pairs(NamedAnimations) do
        table.insert(Globals.AnimationOptions, animationName)
    end
    table.sort(Globals.AnimationOptions)
    return Globals.AnimationOptions
end


---Creates named options for the favorites combo
---@return string[]
function createFavOptions()
    local favoriteOptions = {}
    for _, animationName in pairs(NamedFavAnimations) do
        table.insert(favoriteOptions, animationName.name)
    end
    return favoriteOptions
end


---Creates named options for the history combo
---@return string[]
function createHistOptions()
    local historyOptions = {}
    local xd = {}
    
    for _, animation in pairs(NamedHistAnimations) do
        local animationName = animation.name
        if not xd[animationName] then
            xd[animationName] = true
            table.insert(historyOptions, 1, animationName)
        end
    end
    return historyOptions
end


-- function createModdedOptions()
--     if Globals.ModdedOptions then
--         return Globals.ModdedOptions
--     end
--     Globals.ModdedOptions = {}
--     for animationName, animationID in pairs(NamedAnimations) do
--         if Ext.Resource.Get(animationID, "Animation").IsModded == true then
--             local animation = Ext.Resource.Get(animationID, "Animation")
--             table.insert(Globals.ModdedOptions, animationName)
--         end
--     end
--     table.sort(Globals.ModdedOptions)
--     return Globals.ModdedOptions
-- end

---Creates modded options and categorizes them by animation.Template
---@return string[]
function createModdedOptions()
    if Globals.ModdedOptions then
        return Globals.ModdedOptions
    end
    Globals.ModdedOptions = {}
    local Temlated = {}
    for animationName, animationID in pairs(NamedAnimations) do
        local animation = Ext.Resource.Get(animationID, "Animation")
        if animation and animation.IsModded then
    ---SloppedTopped
            table.insert(Temlated, {template = animation.Template, name = animationName})
        end
    end
    table.sort(Temlated, function(a, b)
        return a.template == b.template and a.name < b.name or a.template < b.template
    end)
    for _, v in ipairs(Temlated) do
        table.insert(Globals.ModdedOptions, v.name)
    end
    return Globals.ModdedOptions
end

---Matches slot combo index and returns its MapKey
---@return string
function getReservedSlot()
    return MapKeys[selectSlot.SelectedIndex + 1]
end


---sd;flkjsdahflkj
-- function getSelectedAnimationSet()
--     local s = selectAnimSet.Options[selectAnimSet.SelectedIndex + 1]
--     return s
-- end

---Gets selected characters index in the Fill combo
function getSelectedFillCharacter()
    local selectedOptionName = visTemComob.Options[visTemComob.SelectedIndex + 1]
    for k, v in ipairs(visTemplatesTable) do
        for optionName, dummy in pairs(NamedOptions) do
            if optionName == selectedOptionName and dummy == v then
                selectedCharacter = k
                break
            end
        end
    end
end

---@return EntityHandle[] visTemplatesTable
---@return table visTemplatesOptions
function getDummyVisualTemplates()
    local visTemplatesTable = {}
    local visTemplatesOptions= {}
    NamedOptions = {}
    local visTemplates = Ext.Entity.GetAllEntitiesWithComponent("Visual")
    for i = 1, #visTemplates do
        if visTemplates[i].Visual and visTemplates[i].Visual.Visual
            and visTemplates[i].Visual.Visual.VisualResource
            and visTemplates[i].Visual.Visual.VisualResource.Template == "EMPTY_VISUAL_TEMPLATE"
            and visTemplates[i]:GetAllComponentNames(false)[2] == "ecl::dummy::AnimationStateComponent"
        then
        table.insert(visTemplatesTable, visTemplates[i])
        local origins = Ext.Entity.GetAllEntitiesWithComponent('Origin')
            for _, origin in pairs(origins) do
                local match = MatchCharacterAndPMDummy(origin.Uuid.EntityUuid, visTemplatesTable)
                NamedOptions[origin.DisplayName.Name:Get()] = match
            end
        end
    end
    for name, _ in pairs(NamedOptions) do
        table.insert(visTemplatesOptions, name)
    end
    visTemComob.Options = visTemplatesOptions
    return visTemplatesTable, visTemplatesOptions
end


---@param charUuid string
---@param dummies table<EntityHandle> | #table with PM dummies
---@return EntityHandle
function MatchCharacterAndPMDummy(charUuid, dummies)
    local originEnt = Ext.Entity.Get(charUuid)
    for i = 1, #dummies do
        if originEnt.Transform.Transform.Translate[1] == dummies[i].Transform.Transform.Translate[1]
            and originEnt.Transform.Transform.Translate[2] == dummies[i].Transform.Transform.Translate[2] 
            and originEnt.Transform.Transform.Translate[3] == dummies[i].Transform.Transform.Translate[3] then
            return dummies[i]
        end
    end
end


function AddAnimationToFav()
    for animationName, animationID in pairs(NamedAnimations) do
        if animationName:find(ihateCombos.Options[ihateCombos.SelectedIndex + 1]) then
            -- NamedFavAnimations[animationName] = animationID
            table.insert(NamedFavAnimations, { name = animationName, id = animationID })
            Ext.IO.SaveFile('QuickSmallAnimationThingy/Favorites.json', Ext.Json.Stringify(NamedFavAnimations))
        end
    end
end


function RemoveAnimationFromFav()
    if NamedFavAnimations then
        local animationName = ihateCombos.Options[ihateCombos.SelectedIndex + 1]
        for i = #NamedFavAnimations, 1, -1 do
            local fav = NamedFavAnimations[i]
            if fav.name:find(animationName) then
                table.remove(NamedFavAnimations, i)
            end
        end
        Ext.IO.SaveFile('QuickSmallAnimationThingy/Favorites.json', Ext.Json.Stringify(NamedFavAnimations))
    end
end


---@param mapKey string | ResourceAnimationSetResourceBank
---@param animID string | ResourceAnimationResource
---@param subSet string | ResourceAnimationSetResourceSubset
function SkizzingSataning(animationSet, mapKey, animID, subSet)
    local animSet = AnimationSet.Get(animationSet)
    animSet:AddLink(mapKey, animID, subSet)
end


---@param entity #Not in use for now
---@param animationSet ResourceAnimationSetResourceBank | string
---@param action string #play, pause, stop
---@param random boolean
function QSAT:PlayAnimation(entity, part, action, random, reset)
    --local uuid = _C().Uuid.EntityUuid
    local slotMapKey
    local index
    if random == true then
        index = Ext.Math.Random(1, #ihateCombos.Options)
        ihateCombos.SelectedIndex = index - 1
    else
        index = ihateCombos.SelectedIndex + 1
    end
    if ihateCombos.Options[index] then
        for animationName, animationID in pairs(NamedAnimations) do --Gladge
                if animationName:find(ihateCombos.Options[index]) then
                    slotMapKey = getReservedSlot()
                    if reset == true then
                        animationID = Utils.ZEROUUID
                    end
                    if part == 'Body' then
                        for _,AnimationSet in pairs(BaseBodyAnimationSets) do
                            SkizzingSataning(AnimationSet, slotMapKey, animationID, '')
                        end
                    elseif part == 'Face' then
                        for _,AnimationSet in pairs(BaseHeadAnimationSets) do
                            SkizzingSataning(AnimationSet, slotMapKey, animationID, '')
                        end
                    elseif part == 'Tail' then
                        for _,AnimationSet in pairs(BaseTailAnimationSets) do
                            SkizzingSataning(AnimationSet, slotMapKey, animationID, '')
                        end
                    end
                    if not histCheckbox.Checked then
                        table.insert(NamedHistAnimations, {name = animationName, id = animationID})
                    end
                    break
                end
            end
        Helpers.Timer:OnTicks(5, function ()
            local data = {
                --uuid = uuid,
                slotMapKey = slotMapKey,
            }
            if action == 'Play' then
                Ext.Net.PostMessageToServer('QSAT_PlayAnimation', Ext.Json.Stringify(data))
            elseif action == 'Pause' then
                Ext.Net.PostMessageToServer('QSAT_PauseAnimation', Ext.Json.Stringify(data))
            elseif action == 'Stop' then
                Ext.Net.PostMessageToServer('QSAT_StopAnimation', Ext.Json.Stringify(data))
            end
        end)
    end
end


---Saves default animation IDs for each Animation Set in BaseBodyAnimationSets
function LazyBodySave()
    local Data = {}
    if Ext.IO.LoadFile('QuickSmallAnimationThingy/DefaultBodyAnimationIDs.json') then
        return
    else
        for _, animationSet in pairs(BaseBodyAnimationSets) do
            Data[animationSet] = Data[animationSet] or {}
            local animSet = AnimationSet.Get(animationSet)
                for _, mapKey in pairs(MapKeys) do
                Data[animationSet][mapKey] = Data[animationSet][mapKey] or {}
                if animSet and animSet[1] and animSet[1].AnimationBank.AnimationSubSets[''] and animSet[1].AnimationBank.AnimationSubSets[''].Animation[mapKey] then
                    local savedAnimID = animSet[1].AnimationBank.AnimationSubSets[''].Animation[mapKey].ID
                    table.insert(Data[animationSet][mapKey], savedAnimID)
                end
            end
        end
    end
    DPrint('Default body animation IDs saved to local file')
    Ext.IO.SaveFile('QuickSmallAnimationThingy/DefaultBodyAnimationIDs.json', Ext.Json.Stringify(Data))
end
LazyBodySave()

-- function LazyFaceSave()
--     local Data = {}
--     if Ext.IO.LoadFile('QuickSmallAnimationThingy/DefaultHeadAnimationIDs.json') then
--         return
--     else
--         for _, animationSet in pairs(BaseHeadAnimationSets) do
--             Data[animationSet] = Data[animationSet] or {}
--             local animSet = AnimationSet.Get(animationSet)
--                 for _, mapKey in pairs(MapKeys) do
--                 Data[animationSet][mapKey] = Data[animationSet][mapKey] or {}
--                 if animSet and animSet[1] and animSet[1].AnimationBank.AnimationSubSets[''] and animSet[1].AnimationBank.AnimationSubSets[''].Animation[mapKey] then
--                     local savedAnimID = animSet[1].AnimationBank.AnimationSubSets[''].Animation[mapKey].ID
--                     table.insert(Data[animationSet][mapKey], savedAnimID)
--                 end
--             end
--         end
--     end
--     DPrint('Default head animation IDs saved to local file')
--     Ext.IO.SaveFile('QuickSmallAnimationThingy/DefaultHeadAnimationIDs.json', Ext.Json.Stringify(Data))
-- end
-- LazyFaceSave()


---Loads default animation IDs
function UnSkizzing()
    local data = Ext.Json.Parse(Ext.IO.LoadFile('QuickSmallAnimationThingy/DefaultBodyAnimationIDs.json'))
    for animationSet, MapKeys in pairs(data) do
        for mapKey, animID in pairs(MapKeys) do
            local animSet = AnimationSet.Get(animationSet)
            animSet:AddLink(mapKey, animID[1], '')
        end
    end
    -- local data2 = Ext.Json.Parse(Ext.IO.LoadFile('QuickSmallAnimationThingy/DefaultHeadAnimationIDs.json'))
    -- for animationSet, MapKeys in pairs(data2) do
    --     for mapKey, animID in pairs(MapKeys) do
    --         local animSet = AnimationSet.Get(animationSet)
    --         animSet:AddLink(mapKey, animID[1], '')
    --     end
    -- end
end




