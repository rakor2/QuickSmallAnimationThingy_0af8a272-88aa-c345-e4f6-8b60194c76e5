
--[[SEARCH REESET ON EMPTY INPUT]]


local OPENQUESTIONMARK = false
IMGUI:AntiStupiditySystem()

UI = UI or {}
Window = Window or {}
Globals = Globals or {}
MCM = MCM or {} -- NO YELLOW THINGY ALLOWED


function UI:Init()
    Window:QSATMCM()
    Window:QSATWindow()
end


function Window:QSATMCM()
    local function CreateQSATMCMTab(tab)
        local openButton = tab:AddButton('Open')
        openButton.OnClick = function()
            QSATWindow.Open = not QSATWindow.Open
        end
    end
    MCM.InsertModMenuTab('QSAT', CreateQSATMCMTab, ModuleUUID)
end



function Window:QSATWindow()
    QSATWindow = Ext.IMGUI.NewWindow('quick skiz animation thingy')
    QSATWindow.Open = OPENQUESTIONMARK
    QSATWindow.Closeable = true
    -- QSATWindow.AlwaysAutoResize = true
    QSATWindow:SetSize({643, 700})

    local mainTabBar = QSATWindow:AddTabBar('LL')

    p = mainTabBar:AddTabItem('Animations')
    -- pv2 = mainTabBar:AddTabItem("v2")

    StyleV2:RegisterWindow(QSATWindow)

    ApplyStyle(QSATWindow, 1)


    MCM.SetKeybindingCallback('qsat_toggle_window', function()
        QSATWindow.Open = not QSATWindow.Open
    end)


    MCM.SetKeybindingCallback('qsat_pause_window', function()
        if paused == 0 then
            QSAT:PlayAnimation(Globals.part, 'Pause', false)
            paused = 1
        else
            QSAT:PlayAnimation(Globals.part, 'Play', false)
            paused = 0
        end
        PhotoModePlayPause()
    end)



    Globals.AnimationOptions = createAnimationOptions()
    Globals.ModdedOptions = createModdedOptions()
    Globals.CurrentOptions = Globals.AnimationOptions
    Globals.FilteredOptions = {}
    local faceCheck
    local tailCheck
    local wingsCheck



    selectFaceSlot = p:AddCombo('Expression slot')
    selectFaceSlot.Options = SlotsFace
    selectFaceSlot.SelectedIndex = 0



    selectSlot = p:AddCombo('Pose slot')
    selectSlot.Options = Slots
    selectSlot.SelectedIndex = 0



    ihateCombos = p:AddCombo('Animations')
    ihateCombos.HeightLarge = true
    ihateCombos.Options = Globals.AnimationOptions
    ihateCombos.SelectedIndex = 0
    ihateCombos.OnChange = function ()
        QSAT:PlayAnimation(Globals.part, 'Play', false)
    end



    searchInput = p:AddInputText('')
    searchInput.OnChange = function()
        if searchInput.Text == '' then
            Globals.FilteredOptions = {}
            Globals.CurrentOptions = Globals.AnimationOptions
            ihateCombos.Options = Globals.CurrentOptions
        else
            Globals.FilteredOptions = {}
            local searchText = string.lower(searchInput.Text)
            ---SloppedTopped
            searchText = string.gsub(searchText, " ", "_")
            local searchParts = {}

            for part in string.gmatch(searchText, "[^_]+") do
                if  part ~= "" then
                    table.insert(searchParts, part)
                end
            end

            for _, animationName in ipairs(Globals.CurrentOptions) do
                local animationLower = string.lower(animationName)
                local matches = true

                for _, searchPart in ipairs(searchParts) do
                    if not string.find(animationLower, searchPart, 1, true) then
                        matches = false
                        break
                    end
                end

                if matches then
                    table.insert(Globals.FilteredOptions, animationName)
                end
            end
            ihateCombos.Options = Globals.FilteredOptions
            ihateCombos.SelectedIndex = 0
        end
    end

    local clearSearch = p:AddButton('Search')
    clearSearch.SameLine = true
    clearSearch.OnClick = function ()
        searchInput.Text = ''
        ihateCombos.Options = Globals.CurrentOptions
    end



    local moddedGroup = p:AddGroup('modded')
    moddedGroup.Visible = false
    moddedGroup:AddSeparatorText('Photo mode poses')



    ihateCombosModAuth = moddedGroup:AddCombo('Author')
    ihateCombosModAuth.HeightLarge = true
    ihateCombosModAuth.Options = Globals.AnimationOptions
    ihateCombosModAuth.SelectedIndex = 0
    ihateCombosModAuth.OnChange = function ()
        createAuthorOptions()
    end



    ihateCombosModPack = moddedGroup:AddCombo('Pack')
    ihateCombosModPack.HeightLarge = true
    ihateCombosModPack.Options = Globals.AnimationOptions
    ihateCombosModPack.SelectedIndex = 0
    ihateCombosModPack.OnChange = function ()
        createPackOptions()
    end



    ihateCombosModAnim = moddedGroup:AddCombo('Animations')
    ihateCombosModAnim.IDContext = 'awdojanwdjn'
    ihateCombosModAnim.HeightLarge = true
    ihateCombosModAnim.Options = Globals.AnimationOptions
    ihateCombosModAnim.SelectedIndex = 0
    ihateCombosModAnim.OnChange = function ()
        QSAT:PlayAnimation(Globals.part, 'Play', false)
    end



    searchInputMod = moddedGroup:AddInputText('')
    searchInputMod.OnChange = function()
        if searchInputMod.Text == '' then
            Globals.FilteredOptions = {}
            Globals.CurrentOptions = Globals.AnimationOptions
            ihateCombos.Options = Globals.CurrentOptions
        else
            Globals.FilteredOptions = {}
            local searchText = string.lower(searchInputMod.Text)
            ---SloppedTopped
            searchText = string.gsub(searchText, " ", "_")
            local searchParts = {}
            for part in string.gmatch(searchText, "[^_]+") do
                if  part ~= "" then
                    table.insert(searchParts, part)
                end
            end
            for _, animationName in ipairs(Globals.CurrentOptions) do
                local animationLower = string.lower(animationName)
                local matches = true
                for _, searchPart in ipairs(searchParts) do
                    if not string.find(animationLower, searchPart, 1, true) then
                        matches = false
                        break
                    end
                end
                if matches then
                    table.insert(Globals.FilteredOptions, animationName)
                end
            end
            ihateCombos.Options = Globals.FilteredOptions
            ihateCombos.SelectedIndex = 0
        end
    end

    local clearSearchMod = moddedGroup:AddButton('Search')
    clearSearchMod.IDContext = 'awdojanwdwwdjn'
    clearSearchMod.SameLine = true
    clearSearchMod.OnClick = function ()
        searchInputMod.Text = ''
        ihateCombos.Options = Globals.CurrentOptions
    end


    local checkGlobalS = moddedGroup:AddCheckbox('Global search')
    local checkLocalS = moddedGroup:AddCheckbox('Local search')
    checkLocalS.SameLine = true
    moddedGroup:AddSeparator('')




    faceCheck = p:AddCheckbox('Face')
    faceCheck.OnChange = function ()
        if not faceCheck.Checked then
            Globals.part = 'Body'
        else
            Globals.part = 'Face'
            tailCheck.Checked = false
            wingsCheck.Checked = false
        end
    end

    tailCheck = p:AddCheckbox('Tail')
    tailCheck.SameLine = true
    tailCheck.OnChange = function ()
        if not tailCheck.Checked then
            Globals.part = 'Body'
        else
            Globals.part = 'Tail'
            faceCheck.Checked = false
            wingsCheck.Checked = false
        end
    end

    wingsCheck = p:AddCheckbox('Wings')
    wingsCheck.SameLine = true
    wingsCheck.OnChange = function ()
        if not wingsCheck.Checked then
            Globals.part = 'Body'
        else
            Globals.part = 'Wings'
            faceCheck.Checked = false
            tailCheck.Checked = false
        end
    end



    -- wpnCheck = p:AddCheckbox('Weapon')
    -- wpnCheck.SameLine = true
    -- wpnCheck.OnChange = function ()
    --     if not wpnCheck.Checked then
    --         Globals.part = 'Body'
    --     else
    --         Globals.part = 'Weapon'
    --         faceCheck.Checked = false
    --         tailCheck.Checked = false
    --     end
    -- end


    --TBD: Use new component
    local ikCheck = p:AddCheckbox('Toggle IK feet')
    ikCheck.OnChange = function ()
        if ikCheck.Checked then
            saveAllBlueprintIDs()
            Helpers.Timer:OnTicks(1, function ()
                setBlueprintIDs()
            end)
            -- Globals.DummyNameMap[comboDummies.Options[selectedCharacter]].DummyFootIKState.field_E = 1
        else
            -- Globals.DummyNameMap[comboDummies.Options[selectedCharacter]].DummyFootIKState.field_E = 0
            restoreBlueprintIDs()
        end
    end



    Globals.part = 'Body'
    local paused = 0
    local outPlay = p:AddButton('Play')
    outPlay.OnClick = function ()
        QSAT:PlayAnimation(Globals.part, 'Play', false)
        paused = 0
    end



    local arrowOutBack = p:AddButton('<')
    arrowOutBack.IDContext = '123'
    arrowOutBack.SameLine = true
    arrowOutBack.OnClick = function ()
        ihateCombos.SelectedIndex = ihateCombos.SelectedIndex - 1
        if ihateCombos.SelectedIndex < 0  then
            ihateCombos.SelectedIndex = #ihateCombos.Options - 1
        end
        QSAT:PlayAnimation(Globals.part, 'Play', false)
        paused = 0
    end



    local arrowOutForward = p:AddButton('>')
    arrowOutBack.IDContext = '321'
    arrowOutForward.SameLine = true
    arrowOutForward.OnClick = function ()
        ihateCombos.SelectedIndex = ihateCombos.SelectedIndex + 1
        if ihateCombos.SelectedIndex > #ihateCombos.Options - 1 then
            ihateCombos.SelectedIndex = 0
        end
        QSAT:PlayAnimation(Globals.part, 'Play', false)
        paused = 0
    end



    local outPause = p:AddButton('Pause')
    outPause.SameLine = true
    outPause.OnClick = function ()
        if paused == 0 then
            QSAT:PlayAnimation(Globals.part, 'Pause', false)
            paused = 1
        else
            QSAT:PlayAnimation(Globals.part, 'Play', false)
            paused = 0
        end
    end



    local outStop = p:AddButton('Stop')
    outStop.SameLine = true
    outStop.OnClick = function ()
        QSAT:PlayAnimation(Globals.part, 'Stop', false)
    end



    local randomAnim = p:AddButton('Random')
    randomAnim.SameLine = true
    randomAnim.OnClick = function ()
        QSAT:PlayAnimation(Globals.part, 'Play', true)
        paused = 0
        if histCheckbox.Checked then
            ihateCombos.Options = Globals.AnimationOptions
        elseif searchInput.Text ~= '' then
            ihateCombos.Options = Globals.FilteredOptions
        else
            ihateCombos.Options = Globals.CurrentOptions
        end
        histCheckbox.Checked = false
    end



    moddedCheckbox = p:AddCheckbox('Modded')
    moddedCheckbox.OnChange = function ()
        local ModdedOptions = createModdedOptions()
        if moddedCheckbox.Checked then
            searchInput.Text = ''

            ihateCombos.SelectedIndex = 0
            ihateCombos.Options = ModdedOptions
            Globals.CurrentOptions = ModdedOptions

            histCheckbox.Checked = false
            favCheckbox.Checked = false
            removeFav.Disabled = true

            -- moddedGroup.Visible = true
        else
            searchInput.Text = ''

            ihateCombos.Options = Globals.AnimationOptions
            Globals.CurrentOptions = Globals.AnimationOptions

            removeFav.Disabled = false
            -- moddedGroup.Visible = false


        end
    end






    favCheckbox = p:AddCheckbox('Favorites')
    favCheckbox.OnChange = function ()
        local favOptions = createFavOptions()
        if favCheckbox.Checked then
            searchInput.Text = ''
            ihateCombos.SelectedIndex = 0

            ihateCombos.Options = favOptions
            Globals.CurrentOptions = favOptions

            histCheckbox.Checked = false
            moddedCheckbox.Checked = false
            removeFav.Disabled = false

        else
            searchInput.Text = ''
            removeFav.Disabled = true

            ihateCombos.Options = Globals.AnimationOptions
            Globals.CurrentOptions = Globals.AnimationOptions
        end
    end



    local addFav = p:AddButton('Add')
    addFav.SameLine = true
    addFav.OnClick = function ()
        AddAnimationToFav()
    end



    removeFav = p:AddButton('Remove')
    removeFav.SameLine = true
    removeFav.OnClick = function ()
        RemoveAnimationFromFav()
        ihateCombos.Options = createFavOptions()
        ihateCombos.SelectedIndex = #ihateCombos.Options - 1
        if ihateCombos.SelectedIndex < 0 then
            ihateCombos.SelectedIndex = 0
            ihateCombos.Options = Globals.AnimationOptions
            Globals.CurrentOptions = Globals.AnimationOptions
            favCheckbox.Checked = false
            removeFav.Disabled = true
            removeFav:SetColor('TextDisabled', {0.94, 0.94, 0.94, 0.00})
        end
    end
    removeFav.Disabled = true



    histCheckbox = p:AddCheckbox('History')
    histCheckbox.OnChange = function ()
        local histOptions = createHistOptions()
        if histCheckbox.Checked then
            favCheckbox.Checked = false
            moddedCheckbox.Checked = false
            ihateCombos.Options = histOptions
            Globals.CurrentOptions = histOptions
            ihateCombos.SelectedIndex = 0
            searchInput.Text = ''
        else
            ihateCombos.Options = Globals.AnimationOptions
            Globals.CurrentOptions = Globals.AnimationOptions
            searchInput.Text = ''
        end
    end



    local clearHist = p:AddButton('Clear')
    clearHist.SameLine = true
    clearHist.OnClick = function ()
        NamedHistAnimations = {}
        histOptions = {}
        ihateCombos.Options = Globals.AnimationOptions
        histCheckbox.Checked = false
    end



    pm = p:AddGroup('pmgroup')
    pm.Visible = false

    sepaTiming = pm:AddSeparatorText('Photo Mode things')

    comboDummies = pm:AddCombo('Dummies')
    comboDummies.IDContext = 'awdawd'
    comboDummies.SelectedIndex = 0
    comboDummies.HeightLargest = true
    comboDummies.SameLine = false
    comboDummies.OnChange = function ()
        selectedCharacter = comboDummies.SelectedIndex + 1
        selectedDummy = Globals.DummyNameMap[comboDummies.Options[selectedCharacter]]
    end



    slTiming = pm:AddSlider('', 0, 0, 1, 1)
    slTiming.OnChange = function (e)
        local i = getNoesisActorNumber()
        pcall(function ()
            Ext.UI.GetRoot():Find("ContentRoot"):Child(21).DataContext.ActorSettings[i].SelectedEmote.IsScrubbingEnabled = true
            Ext.UI.GetRoot():Find("ContentRoot"):Child(21).DataContext.ActorSettings[i].SelectedEmote.ScrubPercent = e.Value[1]
        end)
    end



    function PhotoModePlayPause()
        pcall(function ()
            local i = getNoesisActorNumber()
            local SelectedEmote = Ext.UI.GetRoot():Find("ContentRoot"):Child(21).DataContext.ActorSettings[i].SelectedEmote
            local state = SelectedEmote.IsScrubbingEnabled
            state = not state
            SelectedEmote.IsScrubbingEnabled = state
            Ext.UI.GetRoot():Find("ContentRoot"):Child(21).DataContext.UpdateAnimationState:Execute()
        end)
    end



    function PhotoModePause()
        pcall(function ()
            local i = getNoesisActorNumber()
            local SelectedEmote = Ext.UI.GetRoot():Find("ContentRoot"):Child(21).DataContext.ActorSettings[i].SelectedEmote
            SelectedEmote.IsScrubbingEnabled = true
            Ext.UI.GetRoot():Find("ContentRoot"):Child(21).DataContext.UpdateAnimationState:Execute()
        end)
    end



    function PhotoModePlay()
        pcall(function ()
            local i = getNoesisActorNumber()
            local SelectedEmote = Ext.UI.GetRoot():Find("ContentRoot"):Child(21).DataContext.ActorSettings[i].SelectedEmote
            SelectedEmote.IsScrubbingEnabled = false
            Ext.UI.GetRoot():Find("ContentRoot"):Child(21).DataContext.UpdateAnimationState:Execute()
        end)
    end


    btnPlayPause = pm:AddButton('Play')
    btnPlayPause.SameLine = true
    btnPlayPause.IDContext = 'apeofjanse;lkjna'
    btnPlayPause.OnClick = function (e)
        PhotoModePlayPause()
    end



    local sepa123 = p:AddSeparatorText('Position')



    Globals.entity = _C()
    local savedPos = {}
    selectedCharacter = 1


    local savePos = p:AddButton('Save')
    savePos.OnClick = function ()
        if selectedCharacter and Globals.DummyNameMap then
            savedPos[selectedCharacter] = Globals.DummyNameMap[comboDummies.Options[selectedCharacter]].Visual.Visual.WorldTransform.Translate
        else
            Ext.Net.PostMessageToServer('QSAT_SavePos', Ext.Json.Stringify(Globals.entity.Uuid.EntityUuid))
        end
    end



    local loadPos = p:AddButton('Load')
    Globals.entity = _C()
    loadPos.SameLine = true
    loadPos.OnClick = function ()
        if selectedCharacter and Globals.DummyNameMap then
            Globals.DummyNameMap[comboDummies.Options[selectedCharacter]].Visual.Visual.WorldTransform.Translate = savedPos[selectedCharacter]
        else
            Ext.Net.PostMessageToServer('QSAT_LoadPos', Ext.Json.Stringify(Globals.entity.Uuid.EntityUuid))
        end
    end


    E.grpEquip = pm:AddGroup('Equppies')
    E.grpEquip.Visible = false

    local sepaEquip = E.grpEquip:AddSeparatorText('Equipables')


    --- TBD: refactor the things
    local QSAT_DummyUnsheath = {}
    function ReEquipWeapons()
        local keys = {}
        local uuid = selectedDummy.Dummy.Entity.Uuid.EntityUuid
        local key = uuid .. '_ReEquip'
        keys[key] = key
        if Utils.subID and Utils.subID[key] then Utils:SubUnsubToTick('unsub', key, _) end

        Utils:SubUnsubToTick('sub', key, function()

            if not Globals.States.inPhotoMode then
                for key, _ in pairs(keys) do
                    Utils:SubUnsubToTick('unsub', key, _)
                end
                return
            end

            if  selectedDummy.DummyUnsheath.field_0 ~= QSAT_DummyUnsheath[uuid].field_0 or
                selectedDummy.DummyUnsheath.field_4 ~= QSAT_DummyUnsheath[uuid].field_4 then


                selectedDummy.DummyUnsheath.field_0 = QSAT_DummyUnsheath[uuid].field_0
                selectedDummy.DummyUnsheath.field_4 = QSAT_DummyUnsheath[uuid].field_4

                for i = 1, #Ext.UI.GetRoot():Find("ContentRoot"):Child(21).DataContext.ActorSettings do
                    Ext.UI.GetRoot():Find("ContentRoot"):Child(21).DataContext.ActorSettings[i].ShowWeapons = false
                    Ext.UI.GetRoot():Find("ContentRoot"):Child(21).DataContext.UpdateEquipmentVisibility:Execute()
                end

                Utils:AntiSpam(1, function()
                    for i = 1, #Ext.UI.GetRoot():Find("ContentRoot"):Child(21).DataContext.ActorSettings do
                        Ext.UI.GetRoot():Find("ContentRoot"):Child(21).DataContext.ActorSettings[i].ShowWeapons = true
                        Ext.UI.GetRoot():Find("ContentRoot"):Child(21).DataContext.UpdateEquipmentVisibility:Execute()
                    end
                end)
            end
        end)
    end



    local function createQSATDummyUnsheath(uuid)
        QSAT_DummyUnsheath = {}
        QSAT_DummyUnsheath[uuid] = QSAT_DummyUnsheath[uuid] or {
        field_0 = selectedDummy.DummyUnsheath.field_0,
        field_4 = selectedDummy.DummyUnsheath.field_4,
        }
        -- DDump(QSAT_DummyUnsheath)
    end



    local btnEquipMelee = E.grpEquip:AddButton('Melee')
    btnEquipMelee.OnClick = function(e)
        local uuid = selectedDummy.Dummy.Entity.Uuid.EntityUuid
        createQSATDummyUnsheath(uuid)
        QSAT_DummyUnsheath[uuid].field_0 = QSAT_DummyUnsheath[uuid].field_0 == 1 and 0 or 1
        ReEquipWeapons()
    end



    local btnEquipOffMelee = E.grpEquip:AddButton('Off-melee')
    btnEquipOffMelee.SameLine = true
    btnEquipOffMelee.OnClick = function(e)
        local uuid = selectedDummy.Dummy.Entity.Uuid.EntityUuid
        createQSATDummyUnsheath(uuid)
        QSAT_DummyUnsheath[uuid].field_4 = QSAT_DummyUnsheath[uuid].field_4 == 1 and 0 or 1
        ReEquipWeapons()
    end



    local btnEquipRange = E.grpEquip:AddButton('Ranged')
    btnEquipRange.SameLine = true
    btnEquipRange.OnClick = function(e)
        local uuid = selectedDummy.Dummy.Entity.Uuid.EntityUuid
        createQSATDummyUnsheath(uuid)
        QSAT_DummyUnsheath[uuid].field_0 = QSAT_DummyUnsheath[uuid].field_0 == 2 and 0 or 2
        ReEquipWeapons()
    end



    local btnEquipOffRange = E.grpEquip:AddButton('Off-ranged')
    btnEquipOffRange.SameLine = true
    btnEquipOffRange.OnClick = function(e)
        local uuid = selectedDummy.Dummy.Entity.Uuid.EntityUuid
        createQSATDummyUnsheath(uuid)
        QSAT_DummyUnsheath[uuid].field_4 = QSAT_DummyUnsheath[uuid].field_4 == 2 and 0 or 2
        ReEquipWeapons()
    end




    function RotateWpn(entity, itemSlot, axis, value)

        if not entity.ClientEquipmentVisuals.Equipment[itemSlot] then return end

        local InitRotation = entity.ClientEquipmentVisuals.Equipment[itemSlot].SubVisuals[1].Visual.Visual.WorldTransform.RotationQuat
        local CurrentQuat = {InitRotation[1], InitRotation[2], InitRotation[3], InitRotation[4]}
        local rotationAngle = math.rad(value)
        local AxisVec = {0, 0, 0}

        if axis == 'rx' then
            AxisVec = {1, 0, 0}

        elseif axis == 'ry' then
            AxisVec = {0, 1, 0}

        elseif axis == 'rz' then
            AxisVec = {0, 0, 1}
        end

        local Quats = Ext.Math.QuatRotateAxisAngle(CurrentQuat, AxisVec, rotationAngle)

        entity.ClientEquipmentVisuals.Equipment[itemSlot].SubVisuals[1].Visual.Visual:SetWorldRotate(Quats)

        return Quats
    end



    function TranslateWpn(entity, itemSlot, axis, value)

        if not entity.ClientEquipmentVisuals.Equipment[itemSlot] then return end

        local InitPosition = entity.ClientEquipmentVisuals.Equipment[itemSlot].SubVisuals[1].Visual.Visual.WorldTransform.Translate

        local Pos = {}
        local px = InitPosition[1]
        local py = InitPosition[2]
        local pz = InitPosition[3]

        if axis == 'x' then
            Pos = {px + value, py, pz}

        elseif axis == 'y' then
            Pos = {px, py + value, pz}

        elseif axis == 'z' then
            Pos = {px, py, pz + value}
        end

        entity.ClientEquipmentVisuals.Equipment[itemSlot].SubVisuals[1].Visual.Visual:SetWorldTranslate(Pos)

        -- WHY THE FUCK IT RESETS BACK

        return Pos
    end



    function ScaleWpn(entity, itemSlot, axis, value)

        if not entity.ClientEquipmentVisuals.Equipment[itemSlot] then return end

        local InitScale = entity.ClientEquipmentVisuals.Equipment[itemSlot].SubVisuals[1].Visual.Visual.WorldTransform.Scale

        local Scale = {}
        local sx = InitScale[1]
        local sy = InitScale[2]
        local sz = InitScale[3]

        if axis == 'x' then
            Scale = {sx + value, sy, sz}

        elseif axis == 'y' then
            Scale = {sx + value, sy, sz}

        elseif axis == 'z' then
            Scale = {sx + value, sy, sz}

        elseif axis == 'all' then
            Scale = {sx + value, sy + value, sz + value}
        end

        entity.ClientEquipmentVisuals.Equipment[itemSlot].SubVisuals[1].Visual.Visual:SetWorldScale(Scale)

        return Scale
    end



    function StopRotationReset(entity, itemSlot, newRotation)

        local subKey = 'qsat_rotation_reset_' .. tostring(Dummy:Owner(entity)) .. '_' .. itemSlot

        if Utils.subID and Utils.subID[subKey] then return end

        Utils:SubUnsubToTick('sub', subKey, function ()
            pcall(function (...)
                entity.ClientEquipmentVisuals.Equipment[itemSlot].SubVisuals[1].Visual.Visual:SetWorldRotate(newRotation)
            end)
        end)

    end



    function ResumeRotationReset(entity, itemSlot)
        local subKey = 'qsat_rotation_reset_' .. tostring(Dummy:Owner(entity)) .. '_' .. itemSlot
        Utils:SubUnsubToTick('unsub', subKey, nil)
    end



    function StopTranslationReset(entity, itemSlot, newPosition)

        local subKey = 'qsat_translation_reset_' .. tostring(Dummy:Owner(entity)) .. '_' .. itemSlot

        if Utils.subID and Utils.subID[subKey] then return end

        Utils:SubUnsubToTick('sub', subKey, function ()
            pcall(function (...)
                entity.ClientEquipmentVisuals.Equipment[itemSlot].SubVisuals[1].Visual.Visual:SetWorldTranslate(newPosition)
            end)
        end)

    end



    function ResumeTranslationReset(entity, itemSlot)
        local subKey = 'qsat_translation_reset_' .. tostring(Dummy:Owner(entity)) .. '_' .. itemSlot
        Utils:SubUnsubToTick('unsub', subKey, nil)
    end



    function QuickResumeStopSwitch(entity, itemSlot, newRotation, newPosition, state)
        if state then
            ResumeTranslationReset(entity, itemSlot)
            local rot = newRotation or entity.ClientEquipmentVisuals.Equipment[itemSlot].SubVisuals[1].Visual.Visual.WorldTransform.RotationQuat
            StopRotationReset(entity, itemSlot, rot)
            E.btnQuickSwitch.Label = 'Rotation mode'
        else
            ResumeRotationReset(entity, itemSlot)
            local pos = newPosition or entity.ClientEquipmentVisuals.Equipment[itemSlot].SubVisuals[1].Visual.Visual.WorldTransform.Translate
            StopTranslationReset(entity, itemSlot, pos)
            E.btnQuickSwitch.Label = 'Position mode'
        end
    end


    function StopAll(entity, itemSlot, newRotation, newPosition)
        local rot = newRotation or entity.ClientEquipmentVisuals.Equipment[itemSlot].SubVisuals[1].Visual.Visual.WorldTransform.RotationQuat
        StopRotationReset(entity, itemSlot, rot)
        local pos = newPosition or entity.ClientEquipmentVisuals.Equipment[itemSlot].SubVisuals[1].Visual.Visual.WorldTransform.Translate
        StopTranslationReset(entity, itemSlot, pos)
    end


    local selectedWpnSlot = nil

    E.comboWpnSlot = E.grpEquip:AddCombo('Slot')
    UI:Config(E.comboWpnSlot, {
        Options = ValidItemSlots,
        SelectedIndex = 0,
        OnChange = function (e)
            selectedWpnSlot = UI:SelectedOpt(e)
        end
    })
    selectedWpnSlot = UI:SelectedOpt(E.comboWpnSlot)



    Globals.States.wpnMode = false

    E.btnQuickSwitch = E.grpEquip:AddButton('Position mode')
    UI:Config(E.btnQuickSwitch, {
        OnClick = function (e)

            local entity = selectedDummy
            local itemSlot = selectedWpnSlot
            local newRotation = Globals.newRotation
            local newPosition = Globals.newPosition
            Globals.States.wpnMode = not Globals.States.wpnMode
            local state = Globals.States.wpnMode

            QuickResumeStopSwitch(entity, itemSlot, newRotation, newPosition, state)
        end
    })



    E.btnStopAll = E.grpEquip:AddButton('Stop')
    UI:Config(E.btnStopAll, {
        SameLine = true,
        OnClick = function (e)

            local entity = selectedDummy
            local itemSlot = selectedWpnSlot
            local newRotation = Globals.newRotation
            local newPosition = Globals.newPosition

            StopAll(entity, itemSlot, newRotation, newPosition)
        end
    })



    E.btnSaveCurrent = E.grpEquip:AddButton('Save all')
    UI:Config(E.btnSaveCurrent, {
        SameLine = true,
        OnClick = function (e)
            SaveCurrentItemSlotTransfrom()
        end
    })



    E.btnSaveCurrent = E.grpEquip:AddButton('Load all')
    UI:Config(E.btnSaveCurrent, {
        SameLine = true,
        OnClick = function (e)
            LoadCurrentItemSlotTransform()
        end
    })


    E.collapseWpnRot = E.grpEquip:AddCollapsingHeader('Rotation')



    E.slWpnX = E.collapseWpnRot:AddSlider('RX', 0, -10, 10)
    UI:Config(E.slWpnX, {
        OnChange = function (e)

            if not Globals.States.inPhotoMode then return end

            local entity = selectedDummy
            local itemSlot = selectedWpnSlot
            local axis = 'rx'
            local value = e.Value[1]

            Globals.newRotation = RotateWpn(entity, itemSlot, axis, value)

            e.Value = {0,0,0,0}
        end
    })



    E.slWpnY = E.collapseWpnRot:AddSlider('RY', 0, -10, 10)
    UI:Config(E.slWpnY, {
        OnChange = function (e)

            if not Globals.States.inPhotoMode then return end

            local entity = selectedDummy
            local itemSlot = selectedWpnSlot
            local axis = 'ry'
            local value = e.Value[1]

            Globals.newRotation = RotateWpn(entity, itemSlot, axis, value)

            e.Value = {0,0,0,0}
        end
    })



    E.slWpnZ = E.collapseWpnRot:AddSlider('RZ', 0, -10, 10)
    UI:Config(E.slWpnZ, {
        OnChange = function (e)

            if not Globals.States.inPhotoMode then return end

            local entity = selectedDummy
            local itemSlot = selectedWpnSlot
            local axis = 'rz'
            local value = e.Value[1]

            Globals.newRotation = RotateWpn(entity, itemSlot, axis, value)

            e.Value = {0,0,0,0}
        end
    })



    -- E.btnStopRotation = E.collapseWpnRot:AddButton('Stop')
    -- UI:Config(E.btnStopRotation, {
    --     OnClick = function (e)

    --         if not Globals.States.inPhotoMode then return end

    --         local entity = selectedDummy
    --         local itemSlot = selectedWpnSlot
    --         local InitRotation = entity.ClientEquipmentVisuals.Equipment[itemSlot].SubVisuals[1].Visual.Visual.WorldTransform.RotationQuat
    --         local newRotation = Globals.newRotation or InitRotation

    --         StopRotationReset(entity, itemSlot, newRotation)

    --     end
    -- })



    -- E.btnResumeRotation = E.collapseWpnRot:AddButton('Resume')
    -- UI:Config(E.btnResumeRotation, {
    --     SameLine = true,
    --     OnClick = function (e)

    --         if not Globals.States.inPhotoMode then return end

    --         local entity = selectedDummy
    --         local itemSlot = selectedWpnSlot

    --         ResumeRotationReset(entity, itemSlot)
    --     end
    -- })



    E.btnResetRotation = E.collapseWpnRot:AddButton('Reset')
    UI:Config(E.btnResetRotation, {
        OnClick = function (e)
            Globals.newRotation = nil

            local entity = selectedDummy
            local itemSlot = selectedWpnSlot
            local transformType = 'RotationQuat'

            local RotationQuat = LoadInitialItemSlotTransform(entity, itemSlot, transformType)

            entity.ClientEquipmentVisuals.Equipment[itemSlot].SubVisuals[1].Visual.Visual:SetWorldRotate(RotationQuat)

        end
    })



    E.collapseWpnPos = E.grpEquip:AddCollapsingHeader('Position')



    E.slWpnTX = E.collapseWpnPos:AddSlider('X', 0, -0.1, 0.1)
    UI:Config(E.slWpnTX, {
        OnChange = function (e)

            if not Globals.States.inPhotoMode then return end

            local entity = selectedDummy
            local itemSlot = selectedWpnSlot
            local axis = 'x'
            local value = e.Value[1]

            Globals.newPosition = TranslateWpn(entity, itemSlot, axis, value/10)

            e.Value = {0,0,0,0}
        end
    })



    E.slWpnTY = E.collapseWpnPos:AddSlider('Y', 0, -0.1, 0.1)
    UI:Config(E.slWpnTY, {
        OnChange = function (e)

            if not Globals.States.inPhotoMode then return end

            local entity = selectedDummy
            local itemSlot = selectedWpnSlot
            local axis = 'y'
            local value = e.Value[1]

            Globals.newPosition = TranslateWpn(entity, itemSlot, axis, value/10)

            e.Value = {0,0,0,0}
        end
    })



    E.slWpnTZ = E.collapseWpnPos:AddSlider('Z', 0, -0.1, 0.1)
    UI:Config(E.slWpnTZ, {
        OnChange = function (e)

            if not Globals.States.inPhotoMode then return end

            local entity = selectedDummy
            local itemSlot = selectedWpnSlot
            local axis = 'z'
            local value = e.Value[1]

            Globals.newPosition = TranslateWpn(entity, itemSlot, axis, value/10)

            e.Value = {0,0,0,0}
        end
    })



    -- E.btnStopTranslation = E.collapseWpnPos:AddButton('Stop')
    -- UI:Config(E.btnStopTranslation, {
    --     OnClick = function (e)

    --         if not Globals.States.inPhotoMode then return end

    --         local entity = selectedDummy
    --         local itemSlot = selectedWpnSlot
    --         local InitPosition = entity.ClientEquipmentVisuals.Equipment[itemSlot].SubVisuals[1].Visual.Visual.WorldTransform.Translate
    --         local newPosition = Globals.newPosition or InitPosition

    --         StopTranslationReset(entity, itemSlot, newPosition)

    --     end
    -- })



    -- E.btnResumeTranslation = E.collapseWpnPos:AddButton('Resume')
    -- UI:Config(E.btnResumeTranslation, {
    --     SameLine = true,
    --     OnClick = function (e)

    --         if not Globals.States.inPhotoMode then return end

    --         local entity = selectedDummy
    --         local itemSlot = selectedWpnSlot

    --         ResumeTranslationReset(entity, itemSlot)
    --     end
    -- })



    E.btnResetTranslation = E.collapseWpnPos:AddButton('Reset')
    UI:Config(E.btnResetTranslation, {
        OnClick = function (e)
            Globals.newPosition = nil

            local entity = selectedDummy
            local itemSlot = selectedWpnSlot
            local transformType = 'Translate'

            local Translate = LoadInitialItemSlotTransform(entity, itemSlot, transformType)

            entity.ClientEquipmentVisuals.Equipment[itemSlot].SubVisuals[1].Visual.Visual:SetWorldTranslate(Translate)

        end
    })



    E.collapseWpnScale = E.grpEquip:AddCollapsingHeader('Scale')



    E.slWpnSX = E.collapseWpnScale :AddSlider('X', 0, -0.1, 0.1)
    UI:Config(E.slWpnSX, {
        OnChange = function (e)

            if not Globals.States.inPhotoMode then return end

            local entity = selectedDummy
            local itemSlot = selectedWpnSlot
            local axis = 'x'
            local value = e.Value[1]

            Globals.newScale = ScaleWpn(entity, itemSlot, axis, value)

            e.Value = {0,0,0,0}
        end
    })



    E.slWpnSY = E.collapseWpnScale :AddSlider('Y', 0, -0.1, 0.1)
    UI:Config(E.slWpnSY, {
        OnChange = function (e)

            if not Globals.States.inPhotoMode then return end

            local entity = selectedDummy
            local itemSlot = selectedWpnSlot
            local axis = 'y'
            local value = e.Value[1]

            Globals.newScale = ScaleWpn(entity, itemSlot, axis, value)

            e.Value = {0,0,0,0}
        end
    })



    E.slWpnSZ = E.collapseWpnScale :AddSlider('Z', 0, -0.1, 0.1)
    UI:Config(E.slWpnSZ, {
        OnChange = function (e)

            if not Globals.States.inPhotoMode then return end

            local entity = selectedDummy
            local itemSlot = selectedWpnSlot
            local axis = 'z'
            local value = e.Value[1]

            Globals.newScale = ScaleWpn(entity, itemSlot, axis, value)

            e.Value = {0,0,0,0}
        end
    })



    E.slWpnSAll = E.collapseWpnScale :AddSlider('All', 0, -0.1, 0.1)
    UI:Config(E.slWpnSAll, {
        OnChange = function (e)

            if not Globals.States.inPhotoMode then return end

            local entity = selectedDummy
            local itemSlot = selectedWpnSlot
            local axis = 'all'
            local value = e.Value[1]

            Globals.newScale = ScaleWpn(entity, itemSlot, axis, value)

            e.Value = {0,0,0,0}
        end
    })



    E.btnResetScale = E.collapseWpnScale :AddButton('Reset')
    UI:Config(E.btnResetScale, {
        OnClick = function (e)

            Globals.newScale = nil

            local entity = selectedDummy
            local itemSlot = selectedWpnSlot
            local transformType = 'Scale'

            local Scale = LoadInitialItemSlotTransform(entity, itemSlot, transformType)

            entity.ClientEquipmentVisuals.Equipment[itemSlot].SubVisuals[1].Visual.Visual:SetWorldScale(Scale)

        end
    })



    local sepa123 = p:AddSeparatorText('?')



    local resetTail = p:AddButton('Reset body')
    resetTail.OnClick = function ()
        QSAT:PlayAnimation('Body', 'Stop', false, true)
    end



    local resetHead = p:AddButton('Reset head')
    resetHead.SameLine = true
    resetHead.OnClick = function ()
        QSAT:PlayAnimation('Face', 'Stop', false, true)
    end



    local resetTail = p:AddButton('Reset tail')
    resetTail.SameLine = true
    resetTail.OnClick = function ()
        QSAT:PlayAnimation('Tail', 'Stop', false, true)
    end



    local resetWings = p:AddButton('Reset wings')
    resetWings.SameLine = true
    resetWings.OnClick = function ()
        QSAT:PlayAnimation('Wings', 'Stop', false, true)
    end



    local resetAll = p:AddButton('Reset all')
    resetAll.SameLine = true
    resetAll.OnClick = function ()
        QSAT:PlayAnimation('Body', 'Stop', false, true)
        QSAT:PlayAnimation('Face', 'Stop', false, true)
        QSAT:PlayAnimation('Tail', 'Stop', false, true)
        QSAT:PlayAnimation('Wings', 'Stop', false, true)
    end



    -- local resetAnims = p:AddButton('Reset to default')
    -- resetAnims.OnClick = function ()
    --     UnSkizzing()
    -- end

    local updateNamedAnimations = p:AddButton('Update available animations list')
    updateNamedAnimations.OnClick = function ()
        ForceGenerateAnimationsWithNames()
        Globals.ModdedOptions = nil
        Helpers.Timer:OnTicks(30, function ()
            createAnimationOptions()
        end)
    end

    local tt1 = updateNamedAnimations:Tooltip()
    tt1:AddText([[
        Updates available animations list, that are available to play]])



    local checkExper = p:AddCheckbox('Experimental')
    UI:Config(checkExper, {
        OnChange = function (e)
            E.grpEquip.Visible = not E.grpEquip.Visible
        end
    })


    local tt2 = checkExper:Tooltip()
    tt2:AddText([[
        Enables controls for weapon positioning in PM
        No further explanation will be presented.]])

end

UI:Init()