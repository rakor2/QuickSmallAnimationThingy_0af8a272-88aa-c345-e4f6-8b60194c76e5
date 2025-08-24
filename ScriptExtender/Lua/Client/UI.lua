
local OPENQUESTIONMARK = false

UI = UI or {}
Window = Window or {}

Globals = Globals or {}

function UI:Init()
    Window:QSATMCM()
    Window:QSATWindow()
end


function Window:QSATMCM()
    local function CreateQSATMCMTab(tab)
        local openButton = tab:AddButton("Open")
        openButton.OnClick = function()
            QSATWindow.Open = not QSATWindow.Open
        end
    end
    Mods.BG3MCM.IMGUIAPI:InsertModMenuTab(ModuleUUID, "QSAT", CreateQSATMCMTab)
end


function Window:QSATWindow()
    QSATWindow = Ext.IMGUI.NewWindow("quick small animation thingy")
    QSATWindow.Open = OPENQUESTIONMARK
    QSATWindow.Closeable = true
    -- QSATWindow.AlwaysAutoResize = true
    QSATWindow:SetSize({643, 700})

    mainTabBar = QSATWindow:AddTabBar("LL")

    p = mainTabBar:AddTabItem("Animations")

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
    end)
    



    -- selectAnimSet = p:AddCombo('Anim set')
    -- selectAnimSet.Options = {
    --     'e005b1e4-c76c-4c92-9a12-569c324c7ca7',
    --     'da29fce1-056a-4f86-b110-d61679c21238',
    -- }
    -- selectAnimSet.SelectedIndex = 0

    
    --local tempText = p:AddText('da = M, e0 = F')

    
    selectFaceSlot = p:AddCombo('Expression slot')
    selectFaceSlot.Options = SlotsFace
    selectFaceSlot.SelectedIndex = 0

    selectSlot = p:AddCombo('Pose slot')
    selectSlot.Options = Slots
    selectSlot.SelectedIndex = 0


    Globals.AnimationOptions = createAnimationOptions()
    Globals.ModdedOptions = createModdedOptions()
    Globals.CurrentOptions = Globals.AnimationOptions
    Globals.FilteredOptions = {}


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

    local faceCheck
    local tailCheck
    local wingsCheck
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

    local ikCheck = p:AddCheckbox('Toggle IK feet')
    ikCheck.OnChange = function ()
        if ikCheck.Checked then
            saveAllBlueprintIDs()
            Helpers.Timer:OnTicks(1, function ()
                setBlueprintIDs()
            end)
        else
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
            --Globals.CurrentOptions = Globals.FilteredOptions
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
            histCheckbox.Checked = false
            favCheckbox.Checked = false
            ihateCombos.Options = ModdedOptions
            Globals.CurrentOptions = ModdedOptions
            ihateCombos.SelectedIndex = 0
            searchInput.Text = ''
            removeFav.Disabled = false
        else
            ihateCombos.Options = Globals.AnimationOptions
            Globals.CurrentOptions = Globals.AnimationOptions
            searchInput.Text = ''
            removeFav.Disabled = true
        end
    end


    favCheckbox = p:AddCheckbox('Favorites')
    favCheckbox.OnChange = function ()
        local favOptions = createFavOptions()
        if favCheckbox.Checked then
            histCheckbox.Checked = false
            moddedCheckbox.Checked = false
            ihateCombos.Options = favOptions
            Globals.CurrentOptions = favOptions
            ihateCombos.SelectedIndex = 0
            searchInput.Text = ''
            removeFav.Disabled = false
        else
            ihateCombos.Options = Globals.AnimationOptions
            Globals.CurrentOptions = Globals.AnimationOptions
            searchInput.Text = ''
            removeFav.Disabled = true
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



    local sepa123 = p:AddSeparatorText('Position')

    fillGroup = p:AddGroup('Fill group')

    visTemComob = fillGroup:AddCombo("")
    visTemComob.Visible = false
    visTemComob.IDContext = "visTemComob333123"
    visTemComob.SelectedIndex = 0
    visTemComob.HeightLargest = true
    visTemComob.SameLine = false
    visTemComob.OnChange = function ()
        selectedCharacter = visTemComob.SelectedIndex + 1
        --getSelectedFillCharacter()
    end


    -- populateOptions = fillGroup:AddButton("Fill options")
    -- populateOptions.IDContext = "populateOpti333ons123"
    -- populateOptions.Visible = false
    -- populateOptions.SameLine = true
    -- populateOptions.OnClick = function()
    --     visTemplatesTable, _ = getDummyVisualTemplates()
    --     selectedCharacter = visTemComob.SelectedIndex + 1
    -- end

    
    Globals.entity = _C()
    local savedPos = {}
                        
    local savePos = p:AddButton('Save')
    savePos.OnClick = function ()
        if selectedCharacter and Utils.subID['QSAT_PM'] ~= nil then
            savedPos[selectedCharacter] = visTemplatesTable[selectedCharacter].Visual.Visual.WorldTransform.Translate
        else
            Ext.Net.PostMessageToServer('QSAT_SavePos', Ext.Json.Stringify(Globals.entity.Uuid.EntityUuid))
        end
    end

    local loadPos = p:AddButton('Load')
    Globals.entity = _C()
    loadPos.SameLine = true
    loadPos.OnClick = function ()
        if selectedCharacter and Utils.subID['QSAT_PM'] ~= nil then
            visTemplatesTable[selectedCharacter].Visual.Visual.WorldTransform.Translate = savedPos[selectedCharacter]
        else
            Ext.Net.PostMessageToServer('QSAT_LoadPos', Ext.Json.Stringify(Globals.entity.Uuid.EntityUuid))
        end
    end

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

end

UI:Init()