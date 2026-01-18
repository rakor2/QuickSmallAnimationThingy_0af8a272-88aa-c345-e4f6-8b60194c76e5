---@diagnostic disable: param-type-mismatch

Ext.RegisterNetListener('QSAT_WhenLevelGameplayStarted', function (channel, payload, user)

    Globals.entity = _C()

    -- local TASO
    -- local uuid = Globals.entity.Uuid.EntityUuid

    -- TASO = TemplateAnimationSetOverride.Get(uuid)

    -- TASO:AddSet(ModuleUUID, true, {
    --     Resource = QSAT_AnimationSets.Body,
    --     Slot = '',
    --     Type = 'Visual'
    -- })

    InitializeFaceMapKeys()
    InitializeMapKeys()
    -- ParseModsForAnimations()
end)



Ext.Entity.OnCreate('PhotoModeSession', function ()
    Helpers.Timer:OnTicks(12, function ()
        Globals.States.inPhotoMode = true
        Globals.DummyNameMap = {}
        local dummies = Ext.Entity.GetAllEntitiesWithComponent('Dummy')

        for _, dummy in pairs(dummies) do
            Globals.DummyNameMap[Dummy:Name(dummy) .. '##' .. Ext.Math.Random(1,10000)] = dummy
        end

        Globals.DummyNames = Utils:MapToArray(Globals.DummyNameMap)
        comboDummies.Options = Globals.DummyNames
        pm.Visible = true
        selectedDummy = Globals.DummyNameMap[Globals.DummyNames[1]]
        Globals.States.wpnMode = false
        E.btnQuickSwitch.Label = 'Position mode'

        Helpers.Timer:OnTicks(10, function () --AHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH
            SaveInitialItemSlotTransfrom()
        end)

    end)
end)



Ext.Entity.OnDestroy('PhotoModeSession', function ()
    Globals.States.inPhotoMode = false
    pm.Visible = false
    Globals.DummyNameMap = nil
    Globals.newRotation = nil
    Globals.newPosition = nil

    if Utils.subID then
        for key, _ in pairs(Utils.subID) do
            if string.find(key, 'qsat_rotation_reset_') or string.find(key, 'qsat_translation_reset_') then
                Utils:SubUnsubToTick('unsub', key, nil)
            end
        end
    end

end)

--Ext.System.ClientVisual.ReloadAllVisuals = true