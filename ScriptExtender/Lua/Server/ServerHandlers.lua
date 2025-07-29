function SavePosition(uuid)
    x,y,z = Osi.GetPosition(uuid)
end

function LoadPosition(uuid)
    if x then
        Osi.TeleportToPosition(uuid, x, y, z, '', 0, 0, 0, 1, 0)
    end
end