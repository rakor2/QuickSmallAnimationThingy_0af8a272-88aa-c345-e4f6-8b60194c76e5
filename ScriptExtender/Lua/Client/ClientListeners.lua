---@diagnostic disable: param-type-mismatch

Ext.RegisterNetListener('QSAT_WhenLevelGameplayStarted', function (channel, payload, user)
    Globals.entity = _C()
    InitializeMapKeys()
end)

-- local triggerOnce = 0
-- Ext.Entity.OnCreate("ClientEquipmentVisuals", function(entity, componentType, component)
--     local pmDunny
--     local sub
--     Helpers.Timer:OnTicks(10, function ()
--         if entity:GetAllComponentNames(false)[2] == 'ecl::dummy::AnimationStateComponent' then
--             pmDunny = entity
--             if triggerOnce == 0 then
--                 triggerOnce = 1
--                 visTemComob.Visible = true
--                 populateOptions.Visible = true
--                 Helpers.Timer:OnTicks(1, function ()
--                     visTemplatesTable, _ = getDummyVisualTemplates()
--                     getSelectedFillCharacter()
--                 end)
--                 sub = Ext.Events.Tick:Subscribe(function()
--                     if pmDunny:GetAllComponentNames(false)[2] == 'ecl::dummy::AnimationStateComponent' then
--                         return
--                     else
--                         Ext.Events.Tick:Unsubscribe(sub)
--                         sub = nil
--                         visTemComob.Visible = false
--                         populateOptions.Visible = false
--                         visTemplatesTable = nil
--                         selectedCharacter = nil
--                     end
--                 end)
--             end
--         end
--     end)
--     triggerOnce = 0
-- end)



local visTemplatesOptions = {}
visTemplatesTable = {}
Ext.Entity.OnCreate('PauseExcluded', function (entity)
    local characters = Ext.Entity.GetAllEntitiesWithComponent('Origin')
    for _, character in pairs(characters) do
        if Characters:MatchPMDummyAndCharacter(character, entity) then
            local name = character.DisplayName.Name:Get()
            if name then
                table.insert(visTemplatesOptions, name .. '##' .. Ext.Math.Random(1,10000))
                table.insert(visTemplatesTable, entity)
                if visTemComob then
                    visTemComob.Visible = true
                    selectedCharacter = visTemComob.SelectedIndex + 1
                    visTemComob.Options = visTemplatesOptions
                end
            end
        end
    end
    Utils:AntiSpam(100, function ()
        Utils:SubUnsubToTick('sub', 'QSAT_PM', function ()
        if Entity:IsPMDummy(entity) then
            return
        else
            visTemplatesTable = {}
            visTemplatesOptions = {}
            visTemComob.Options = {}
            visTemComob.Visible = false
            Utils:SubUnsubToTick('unsub', 'QSAT_PM', nil)
        end
    end)
    end)
end)

-- Ext.Events.ResetCompleted:Subscribe(function()
--     Helpers.Timer:OnTicks(100, function ()
--         if Entity:IsPMDummy(_C()) then
--             Helpers.Timer:OnTicks(1, function ()
--                 visTemplatesTable, _ = getDummyVisualTemplates()
--                 getSelectedFillCharacter()
--                 selectedCharacter = visTemComob.SelectedIndex + 1
--             end)
--         end
--     end)
-- end)

-- Ext.Entity.OnCreate('PauseExcluded', function (entity)
--     DPrint(entity)
-- end)