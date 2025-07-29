---@diagnostic disable: param-type-mismatch

Ext.RegisterNetListener('QSAT_WhenLevelGameplayStarted', function (channel, payload, user)
    Globals.entity = _C()
    InitializeMapKeys()
end)

local triggerOnce = 0
Ext.Entity.OnCreate("ClientEquipmentVisuals", function(entity, componentType, component)
    local pmDunny
    local sub
    Helpers.Timer:OnTicks(10, function ()
        if entity:GetAllComponentNames(false)[2] == 'ecl::dummy::AnimationStateComponent' then
            pmDunny = entity
            if triggerOnce == 0 then
                triggerOnce = 1
                visTemComob.Visible = true
                populateOptions.Visible = true
                Helpers.Timer:OnTicks(1, function ()
                    visTemplatesTable, _ = getDummyVisualTemplates()
                    getSelectedFillCharacter()
                end)
                sub = Ext.Events.Tick:Subscribe(function()
                    if pmDunny:GetAllComponentNames(false)[2] == 'ecl::dummy::AnimationStateComponent' then
                        return
                    else
                        Ext.Events.Tick:Unsubscribe(sub)
                        sub = nil
                        visTemComob.Visible = false
                        populateOptions.Visible = false
                        visTemplatesTable = nil
                        selectedCharacter = nil
                    end
                end)
            end
        end
    end)
    triggerOnce = 0
end)
