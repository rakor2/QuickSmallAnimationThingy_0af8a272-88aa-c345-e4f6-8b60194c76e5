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
Globals.States = {}
NamedFavAnimations = NamedFavAnimations or {}
NamedHistAnimations = NamedHistAnimations or {}

local initializedBody = false
local initializedFace = false
local parsedAnimations = false



---@param animationSet string | ResourceAnimationSetResourceBank
---@param mapKey Animation
---@param animID string | ResourceAnimationResource
---@param subSet string | ResourceAnimationSetResourceSubset
function SkizzingSataning(animationSet, mapKey, animID, subSet)
    local animSet = AnimationSet.Get(animationSet)
    animSet:AddLink(mapKey, animID, subSet)
    -- DPrint('\nAnimSet: %s, \nMapKey: %s, \nAnimID: %s, \nSubSet: %s', animationSet, mapKey, animID, subSet)
    -- DPrint('AnimSetDump:')
    -- DDump(animSet)
end



---Intizialezes MapKeys so they show up in PM pose colletion
function InitializeMapKeys()
    if initializedBody == false then
        local animationID
        for _, BaseAnimationSets in pairs({BaseBodyAnimationSets, BaseHeadAnimationSets, BaseTailAnimationSets}) do --QSAT_AnimationSets
            for part, AnimationSet in pairs(BaseAnimationSets) do
                for _, slotMapKey in pairs(MapKeys) do

                    if part == 'Body' then
                        animationID = '0d802f8f-2034-17c0-983f-18f02788211c'

                    elseif BaseAnimationSets == BaseHeadAnimationSets then
                        animationID = '7b7d0561-2ed7-72f2-c8f3-ab08d6acab67'

                    elseif BaseAnimationSets == BaseTailAnimationSets then
                        animationID = '352df86f-337d-76f8-875a-c8815ead5fd7' --TIF_F Tail; do I care about M or DGB? Or do M and DGB care about me? PonderingCat

                    end

                    SkizzingSataning(AnimationSet, slotMapKey, animationID, '')

                end
            end
        end
        initializedBody = true
        DPrint('InitializeMapKeys')
    end
end


function InitializeFaceMapKeys()
    if initializedFace == false then
        local animationID
        for _, BaseAnimationSets in pairs({BaseHeadAnimationSets}) do
            for _, AnimationSet in pairs(BaseAnimationSets) do
                for _, slotMapKey in pairs(MapKeysFace) do
                    animationID = '7b7d0561-2ed7-72f2-c8f3-ab08d6acab67'
                    SkizzingSataning(AnimationSet, slotMapKey, animationID, '')
                end
            end
        end
        initializedFace = true
        DPrint('InitializeFaceMapKeys')
    end
end



function ParseModsForAnimations()
    if parsedAnimations == true then return DPrint('Animations already paresed') end
    Globals.AuthorModAnimationsMap = {}
    local ModUuids = Ext.Mod.GetLoadOrder()

    for _, modUuid in pairs(ModUuids) do
        if Ext.StaticData.GetByModId("PhotoModeEmotePose", modUuid)[1] then
            local modName = Ext.Mod.GetMod(modUuid).Info.Name
            local author = Ext.Mod.GetMod(modUuid).Info.Author
            local Animations = EmotePose.GetAllByModId(modUuid, false)

            if modName ~= 'PhotoMode' and modName ~= 'QuickSmallAnimationThingy' then
                if not Globals.AuthorModAnimationsMap[author] then
                    Globals.AuthorModAnimationsMap[author] = {}
                    Globals.AuthorModAnimationsMap[author][modName] = {}
                end

                for _, animation in pairs(Animations) do
                    local animName = getAnimationName(animation)
                    Globals.AuthorModAnimationsMap[author][modName][animName] = animation
                end

            end
        end

        if Ext.StaticData.GetByModId("PhotoModeFaceExpression", modUuid)[1] then
            local modName = Ext.Mod.GetMod(modUuid).Info.Name
            local author = Ext.Mod.GetMod(modUuid).Info.Author
            local Animations = FaceExpression.GetAllByModId(modUuid, false)

            if modName ~= 'PhotoMode' and modName ~= 'QuickSmallAnimationThingy' then
                if not Globals.AuthorModAnimationsMap[author] then
                    Globals.AuthorModAnimationsMap[author] = {}
                end
                Globals.AuthorModAnimationsMap[author][modName] = Animations
            end
        end
    end
    parsedAnimations = true
    DPrint('ParseModsForAnimations')
    return Globals.AuthorModAnimationsMap
end



Ext.RegisterConsoleCommand('q_parse', function (cmd, ...)
    DDump(ParseModsForAnimations())
end)

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



---Creates modded options and categorizes them by animation.Template
---@return string[]
function createModdedOptions()
    if Globals.ModdedOptions then return Globals.ModdedOptions end

    Globals.ModdedOptions = {}
    local Temlated = {}

    for animationName, animationID in pairs(NamedAnimations) do
        local animation = Ext.Resource.Get(animationID, "Animation")
        if animation and animation.IsModded then
            ---SloppedTopped
            table.insert(Temlated, {template = animation.Template, name = animationName})
        end
    end

    -- table.sort(Temlated, function(a, b)
    --     return a.name < b.name
    -- end)

    for _, v in ipairs(Temlated) do
        table.insert(Globals.ModdedOptions, v.name)
    end

    table.sort(Globals.ModdedOptions, function(a, b)
        return a:lower() < b:lower()
    end)

    return Globals.ModdedOptions
end



---Matches slot combo index and returns its MapKey
---@return string
function getReservedSlot()
    return MapKeys[selectSlot.SelectedIndex + 1]
end



function getFaceReservedSlot()
    return MapKeysFace[selectFaceSlot.SelectedIndex + 1]
end



function AddAnimationToFav()
    for animationName, animationID in pairs(NamedAnimations) do
        if animationName:find(ihateCombos.Options[ihateCombos.SelectedIndex + 1]) then
            -- NamedFavAnimations[animationName] = animationID
            table.insert(NamedFavAnimations, {name = animationName, id = animationID})
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



---@param entity #Not in use for now
---@param action string #play, pause, stop
---@param random boolean
function QSAT:PlayAnimation(part, action, random, reset)
    --local uuid = _C().Uuid.EntityUuid
    local slotMapKey
    local slotFaceMapKey
    local index
    local AnimationSets

    if random == true then
        index = Ext.Math.Random(1, #ihateCombos.Options)
        ihateCombos.SelectedIndex = index - 1
    else
        index = ihateCombos.SelectedIndex + 1
    end

    if ihateCombos.Options[index] then
        for animationName, animationID in pairs(NamedAnimations) do --Gladge
                if animationName == ihateCombos.Options[index] then
                    slotMapKey = getReservedSlot()

                    if reset == true then
                        animationID = Utils.ZEROUUID
                    end

                    if part == 'Body' then
                        AnimationSets = BaseBodyAnimationSets

                    elseif part == 'Face' then --TBD: temporary
                        AnimationSets = BaseHeadAnimationSets
                        slotFaceMapKey = getFaceReservedSlot()
                        for _,AnimationSet in pairs(AnimationSets) do
                            SkizzingSataning(AnimationSet, slotFaceMapKey, animationID, '')
                        end

                    elseif part == 'Tail' then
                        AnimationSets =  BaseTailAnimationSets

                    elseif part == 'Wings' then
                        AnimationSets = BaseWingsAnimationSets

                    -- elseif part == 'Weapon' then
                    --     AnimationSets = BaseWPNAnimationSets
                    end

                    for _, AnimationSet in pairs(AnimationSets) do
                        SkizzingSataning(AnimationSet, slotMapKey, animationID, '')
                    end

                    if not histCheckbox.Checked then
                        table.insert(NamedHistAnimations, {name = animationName, id = animationID})
                    end

                    -- DPrint(animationName)
                    -- DPrint(ihateCombos.Options[index])
                    -- DPrint(animationID)

                    -- DDump(Ext.Resource.Get(animationID, 'Animation'))

                    -- DPrint('Animation duration: %s', Ext.Resource.Get(animationID, 'Animation').Duration)
                    -- DDump(Ext.Resource.Get(animationID, 'Animation'))
                    break
                end
            end

        Helpers.Timer:OnTicks(5, function ()
            local data = {
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



function getBlueprintID(entity)
    local id = entity.Visual.Visual.VisualResource.BlueprintInstanceResourceID
    return id
end


function setBlueprintID(entity, id)
    entity.Visual.Visual.VisualResource.BlueprintInstanceResourceID = id
end



Globals.SavedBlueprints = Globals.SavedBlueprints or {}
function saveAllBlueprintIDs()
    local origins = Ext.Entity.GetAllEntitiesWithComponent('Origin')
    for _, entity in pairs(origins) do
        local uuid = entity.Uuid.EntityUuid
        Globals.SavedBlueprints[uuid] = getBlueprintID(entity)
    end
    return Globals.SavedBlueprints
end



function setBlueprintIDs()
    local origins = Ext.Entity.GetAllEntitiesWithComponent('Origin')
    for _, entity in pairs(origins) do
        setBlueprintID(entity, '26a49b90-cf9b-0f27-58df-03e2c67593e0')
    end
end



function restoreBlueprintIDs()
    for entityUuid, id in pairs(Globals.SavedBlueprints) do
        local entity = Ext.Entity.Get(entityUuid)
        setBlueprintID(entity, id)
    end
end



function getNoesisActorNumber()
    for k, actor in pairs(Ext.UI.GetRoot():Find("ContentRoot"):Child(21).DataContext.ActorSettings) do
        local uuid = actor.Actor.EntityUUID
        if selectedDummy == Ext.Entity.Get(uuid).HasDummy.Entity then
            return k
        end
    end
end


Globals.ItemSlotsTransform = {}

function SaveInitialItemSlotTransfrom()
    Globals.ItemSlotsTransform = {}
    local Dummies = Ext.Entity.GetAllEntitiesWithComponent('Dummy')

    for _, dummy in pairs(Dummies) do
        if not dummy.ClientEquipmentVisuals then return end
        local ItemSlots = dummy.ClientEquipmentVisuals.Equipment

        for itemSlotName, itemSlot in pairs(ItemSlots) do
            if Utils:KeyCheck(itemSlotName, ValidItemSlots) then

                table.insert(Globals.ItemSlotsTransform, {
                    entity = dummy.ClientEquipmentVisuals.Entity,
                    itemSlotName = itemSlotName,
                    itemSlotTransform = Ext.Types.Serialize(itemSlot.SubVisuals[1].Visual.Visual.WorldTransform)
                })

            end
        end
    end
    return Globals.ItemSlotsTransform
end



function LoadInitialItemSlotTransform(entity, itemSlotName, transformType)
    for _, SavedTransforms in pairs(Globals.ItemSlotsTransform) do
        if entity == SavedTransforms.entity and itemSlotName == SavedTransforms.itemSlotName then
            return SavedTransforms.itemSlotTransform[transformType]
        end
    end
end



function SaveCurrentItemSlotTransfrom()
    Globals.CurrentItemSlotsTransform = {}
    local Dummies = Ext.Entity.GetAllEntitiesWithComponent('Dummy')

    for _, dummy in pairs(Dummies) do
        local ItemSlots = dummy.ClientEquipmentVisuals.Equipment

        for itemSlotName, itemSlot in pairs(ItemSlots) do
            if Utils:KeyCheck(itemSlotName, ValidItemSlots) then
                table.insert(Globals.CurrentItemSlotsTransform, {
                    entity = Dummy:Owner(dummy),
                    itemSlotName = itemSlotName,
                    itemSlotTransform = Ext.Types.Serialize(itemSlot.SubVisuals[1].Visual.Visual.WorldTransform)
                })
            end
        end
    end
    return Globals.CurrentItemSlotsTransform
end



function LoadCurrentItemSlotTransform()
    for _, SavedTransforms in pairs(Globals.CurrentItemSlotsTransform) do
        local entity = Dummy:Get(SavedTransforms.entity)
        local itemSlot = SavedTransforms.itemSlotName
        local RotationQuat = SavedTransforms.itemSlotTransform.RotationQuat
        local Translate = SavedTransforms.itemSlotTransform.Translate
        local Scale = SavedTransforms.itemSlotTransform.Scale

        entity.ClientEquipmentVisuals.Equipment[itemSlot].SubVisuals[1].Visual.Visual:SetWorldRotate(RotationQuat)

        -- StopTranslationReset(entity, itemSlot, Translate)

        entity.ClientEquipmentVisuals.Equipment[itemSlot].SubVisuals[1].Visual.Visual:SetWorldTranslate(Translate)
        entity.ClientEquipmentVisuals.Equipment[itemSlot].SubVisuals[1].Visual.Visual:SetWorldScale(Scale)

        -- ResumeTranslationReset(entity, itemSlot)
    end
end