--Idk why, but for some reasom if I send uuid from client, it just doesn't work correctly, so _C() for now
Ext.RegisterNetListener('QSAT_PlayAnimation', function (channel, payload, user)
    local data = Ext.Json.Parse(payload)
    if data.slotMapKey then
        Osi.PlayLoopingAnimation(_C().Uuid.EntityUuid, '', data.slotMapKey, '', '', '', '', '') 
    end
end)

Ext.RegisterNetListener('QSAT_PauseAnimation', function (channel, payload, user)
    local data = Ext.Json.Parse(payload)
    if data.slotMapKey then
        Osi.PlayLoopingAnimation(_C().Uuid.EntityUuid, '', '', '', '', '', '', '')
    end
end)

Ext.RegisterNetListener('QSAT_StopAnimation', function (channel, payload, user)
    local data = Ext.Json.Parse(payload)
    if data.slotMapKey then
        Osi.StopAnimation(_C().Uuid.EntityUuid, 1)
    end
end)


Ext.RegisterNetListener('QSAT_SavePos', function (channel, payload, user)
    local data = Ext.Json.Parse(payload)
    SavePosition(data)
end)

Ext.RegisterNetListener('QSAT_LoadPos', function (channel, payload, user)
    local data = Ext.Json.Parse(payload)
    LoadPosition(data)
end)


Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", function(levelName, isEditorMode)
    Ext.Net.BroadcastMessage('QSAT_WhenLevelGameplayStarted', '')
end)