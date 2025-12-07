Scriptname bndg_BindingGearManagerMcm extends SKI_ConfigBase

string version

Actor thePlayer

int selectedSlot
int idx

int toggleUseAnimation
int toggleBlockDuringDHLP
int toggleDoNotUnequipSpells

int clickedVersion
int clickedClearDhlp

int toggleLearnSlot
int inputEnterSetName
int toggleSetLeavesItems

int[] toggleClearItem
int toggleClearLeftHandSpell
int toggleClearRightHandSpell
int toggleClearShout

int[] toggleLearnItem
int toggleLearnLeftHandSpell
int toggleLearnRightHandSpell
int toggleLearnShout

int toggleClearRightHandWeapon
int toggleClearLeftHandWeapon
int toggleClearAmmo

int toggleLearnRightHandWeapon
int toggleLearnLeftHandWeapon
int toggleLearnAmmo

int[] keymapOption
int[] modifierOption

int wheelMenuKeymapOption
int wheelMenuModifierOption

int keyCodeLeftControl = 29
int keyCodeRightControl = 157
int keyCodeLeftAlt = 56
int keyCodeRightAlt = 184
int keyCodeLeftShift = 42
int keyCodeRightShift = 54

string backupFolder = "data/skse/plugins/StorageUtilData/binding_gear_backup/"

int clickedBackupSettings
int clickedRestoreSettings

event OnConfigOpen()

    thePlayer = Game.GetPlayer()
    keymapOption = new int[10]
    modifierOption = new int[10]
    Pages = new string[10]
    toggleClearItem = new int[128]
    toggleLearnItem = new int[128]
    
    Pages[0] = "Settings"

    idx = 1
    while idx <= bndg_BindingGearManager.GetSlotCount()
        Pages[idx] = "Set " + idx
        idx += 1
    endwhile

    Pages[bndg_BindingGearManager.GetSlotCount() + 1] = "Backup"

endevent

event OnPageReset(string page)

    version = "0.84"

    SetCursorFillMode(LEFT_TO_RIGHT)
    SetCursorPosition(0)

    if page == ""
        DisplayWelcome()
    elseif page == "Settings"
        DisplaySettings()
    elseif page == "Backup"
        DisplayBackup()
    Else
        idx = 1
        while idx <= bndg_BindingGearManager.GetSlotCount()
            if page == "Set " + idx
                DisplaySlot(idx)
                idx = 1000
            endif
            idx += 1
        endwhile        
    endif



endevent

function DisplayBackup()

    AddHeaderOption("Backup & Restore")
    AddHeaderOption("")

    clickedBackupSettings = AddTextOption("Backup Hotkeys & Settings", "")
    clickedRestoreSettings = AddTextOption("Restore Hotkeys & Settings", "")

    ; AddHeaderOption("Sets")
    ; AddHeaderOption("")

endfunction

function DisplayWelcome()

    clickedVersion = AddTextOption("Version", version)
    ;AddTextOption("Game ID", gearsData.GameId)

    bndg_BindingGearManager gear = Quest.GetQuest("bndg_BindingGearManagerQuest") as bndg_BindingGearManager
    clickedClearDhlp = AddTextOption("DHLP Active", gear.GetDhlpActive())

endfunction

function DisplaySettings()

    AddHeaderOption("General Settings")
    AddHeaderOption("")
    
    toggleUseAnimation = AddToggleOption("Use Animation", StorageUtil.GetIntValue(thePlayer, gearsData.STORAGE_KEY_ANIMATIONS, 0))
    ;toggleDoNotUnequipSpells = AddToggleOption("Do Not Unequip Spells/Shouts", 0); main.GetDoNotUnequipSpells())
    toggleBlockDuringDHLP = AddToggleOption("Block During DHLP", StorageUtil.GetIntValue(thePlayer, gearsData.STORAGE_KEY_DHLP_BLOCKED, 0))

    AddHeaderOption("Hotkeys")
    AddHeaderOption("")

    idx = 1
    while idx <= gearsData.SLOT_COUNT
        int keyCode = StorageUtil.GetIntValue(thePlayer, gearsData.STORAGE_KEY_KEYCODE + idx) 
        int modifierKey = StorageUtil.GetIntValue(thePlayer, gearsData.STORAGE_KEY_MODIFIER + idx) 
        MiscUtil.PrintConsole("modifier idx : " + idx + " modifier: " + modifierKey)
        if keyCode == 0
            keyCode = -1
        endif
        keymapOption[idx] = AddKeyMapOption("Set " + idx + " hotkey", keyCode)
        modifierOption[idx] = AddTextOption("Set " + idx + " modifier", GetModifierString(modifierKey))
        idx += 1
    endwhile

    int wmHotkey = StorageUtil.GetIntValue(thePlayer, gearsData.STORAGE_KEY_KEYCODE + "0") 
    int wmModifierKey = StorageUtil.GetIntValue(thePlayer, gearsData.STORAGE_KEY_MODIFIER+ "0") 
    if wmHotkey == 0
        wmHotkey = -1
    endif
    wheelMenuKeymapOption = AddKeyMapOption("Set wheel menu hotkey", wmHotkey)
    wheelMenuModifierOption = AddTextOption("Set wheel menu modifier", GetModifierString(wmModifierKey)) 

endfunction

function DisplaySlot(int slot)

    ;ShowMessage("slot: " + slot, false)

    bndg_BindingGearManager.WriteToConsole("DisplaySlot slot: " + slot)

    selectedSlot = slot

    AddHeaderOption("Set " + slot)
    AddHeaderOption("")

    toggleLearnSlot = AddTextOption("Learn equipped armor", "Learn")
    inputEnterSetName = AddInputOption("Set Name", StorageUtil.GetStringValue(thePlayer, gearsData.STORAGE_KEY_SET_NAME + selectedSlot, ""))
    toggleSetLeavesItems = AddToggleOption("Set Leaves Existing Items Equipped", StorageUtil.GetIntValue(thePlayer, gearsData.STORAGE_KEY_LEAVES_ITEMS + selectedSlot, 0)) 
    AddTextOption("", "")

    AddHeaderOption("Items In Set")
    AddHeaderOption("")

    Form[] items = StorageUtil.FormListToArray(thePlayer, gearsData.STORAGE_KEY_GEAR + selectedSlot) ; bndg_SkseFunctions.GetSetItems(selectedSlot)

    bndg_BindingGearManager.WriteToConsole("DisplaySlot items: " + items)

    if items.Length > 0
        idx = 0
        while idx < items.Length
            Form item = items[idx]
            toggleClearItem[idx] = AddTextOption("", item.GetName())
            idx += 1
        endwhile
    endif

    if items.Length % 2 != 0 && items.Length > 0
        AddTextOption("", "")
    endif

    AddHeaderOption("Weapons / Spells")
    AddHeaderOption("")

    Form storedLeft = StorageUtil.GetFormValue(thePlayer, gearsData.STORAGE_KEY_LEFT_HAND + selectedSlot) ;bndg_SkseFunctions.GetWeapon(selectedSlot, true)
    Form storedRight = StorageUtil.GetFormValue(thePlayer, gearsData.STORAGE_KEY_RIGHT_HAND + selectedSlot) ;bndg_SkseFunctions.GetWeapon(selectedSlot, false)
    Form storedAmmo = StorageUtil.GetFormValue(thePlayer, gearsData.STORAGE_KEY_AMMO + selectedSlot) ;bndg_SkseFunctions.GetAmmo(selectedSlot)
    Form storedVoice = StorageUtil.GetFormValue(thePlayer, gearsData.STORAGE_KEY_VOICE + selectedSlot)

    string storedLeftName = ""
    string storedRightName = ""
    string storedAmmoName = ""
    string storedVoiceName = ""

    if storedLeft != none
        storedLeftName = storedLeft.GetName()
    endif
    if storedRight != none
        storedRightName = storedRight.GetName()
    endif
    if storedAmmo != none
        storedAmmoName = storedAmmo.GetName()
    endif
    if storedVoice != none
        storedVoiceName = storedVoice.GetName()
    endif

    AddTextOption("Left Hand Weapon / Spell", "")
    AddTextOption("Right Hand Weapon / Spell", "")
    toggleClearLeftHandWeapon = AddTextOption("", storedLeftName)
    toggleClearRightHandWeapon = AddTextOption("", storedRightName)
    AddTextOption("Ammo", "")
    AddTextOption("Voice spell / Shout", "")
    toggleClearAmmo = AddTextOption("", storedAmmoName)
    toggleClearShout = AddTextOption("", storedVoiceName)




    AddTextOption("", "")
    AddTextOption("", "")

    AddHeaderOption("Learn From Equipped Gear")
    AddHeaderOption("")

    Form[] inventory = bndg_SkseFunctions.GetWornGear()
    idx = 0
    int equippedCount = 0
    while idx < inventory.Length
        Form item = inventory[idx]
        if thePlayer.IsEquipped(item) && item.IsPlayable()
            equippedCount += 1
            toggleLearnItem[idx] = AddTextOption("", item.GetName())
        endif
        idx += 1
    endwhile
    
    if equippedCount % 2 != 0 && equippedCount > 0
        AddTextOption("", "")
    endif

    AddHeaderOption("Learn From Equipped Weapons / Spells")
    AddHeaderOption("")
    Form eqWeapon1 = bndg_SkseFunctions.GetEquippedRightHand() 
    Form eqWeapon2 = bndg_SkseFunctions.GetEquippedLeftHand() 
    Form eqAmmo = bndg_SkseFunctions.GetEquippedAmmo() 
    Form eqVoice = bndg_SkseFunctions.GetEquippedVoice()

    int count = 0

    string eqRigthHandName = ""
    string eqLeftHandName = ""
    string eqAmmoName = ""
    string eqVoiceName = ""

    if eqWeapon1 != none
        eqRigthHandName = eqWeapon1.GetName()
        count = bndg_SkseFunctions.IsTwoHanded(eqWeapon1 as Weapon)
    endif
    if eqWeapon2 != none
        eqLeftHandName = eqWeapon2.GetName()
    endif
    if eqAmmo != none
        eqAmmoName = eqAmmo.GetName()
    endif
    if eqVoice != none
        eqVoiceName = eqVoice.GetName()
    endif

    AddTextOption("Left Hand Weapon / Spell", "")
    AddTextOption("Right Hand Weapon / Spell", "")
    if count == 2 
        AddTextOption("", "")
    else
        toggleLearnLeftHandWeapon = AddTextOption("", eqLeftHandName)
    endif
    toggleLearnRightHandWeapon = AddTextOption("", eqRigthHandName)
    AddTextOption("Ammo", "")
    AddTextOption("Voice spell / Shout", "")
    toggleLearnAmmo = AddTextOption("", eqAmmoName)
    toggleLearnShout = AddTextOption("", eqVoiceName)

endfunction

bool working

string function GetModifierString(int modifierValue)
    string modifierStr = "No Modifier Key"
    if modifierValue == keyCodeLeftAlt
        modifierStr = "Left Alt"
    elseif modifierValue == keyCodeRightAlt
        modifierStr = "Right Alt"
    elseif modifierValue == keyCodeLeftShift
        modifierStr = "Left Shift"
    elseif modifierValue == keyCodeRightShift
        modifierStr = "Right Shift"
    elseif modifierValue == keyCodeRightControl
        modifierStr = "Right Control"
    endif
    return modifierStr
endfunction

int function AdvanceModifierValue(int currentModifier)
    int newModifier = 0
    if currentModifier == 0
        newModifier = keyCodeLeftAlt
    elseif currentModifier == keyCodeLeftAlt
        newModifier = keyCodeRightAlt
    elseif currentModifier == keyCodeRightAlt
        newModifier = keyCodeLeftShift
    elseif currentModifier == keyCodeLeftShift
        newModifier = keyCodeRightShift
    elseif currentModifier == keyCodeRightShift
        newModifier = keyCodeRightControl
    elseif currentModifier == keyCodeRightControl
        newModifier = 0
    endif
    return newModifier
endfunction

event OnOptionInputAccept(int option, string textStr)
	if (option == inputEnterSetName)
        StorageUtil.SetStringValue(thePlayer, gearsData.STORAGE_KEY_SET_NAME + selectedSlot, textStr)
		SetInputOptionValue(option, textStr)
	endIf
endEvent

event OnOptionSelect(int option)

    bool skipOthers = false
    ;working = false

    if option == clickedVersion
        skipOthers = true
    endif

    if option == clickedBackupSettings
        if ShowMessage("Backup settings and hotkeys?")
            BackupSettingsToJson()
        endif
        skipOthers = true
    endif

    if option == clickedRestoreSettings
        int exists = JsonUtil.GetIntValue("/binding_gear_backup/settings/settings.json", "backup_exists")
        if exists == 1
            if ShowMessage("Restore settings and hotkeys?")
                RestoreSettingsFromJson()
            endif
        else
            ShowMessage("No backup has been created", false)
        endif
        skipOthers = true
    endif

    if option == clickedClearDhlp && !skipOthers
        bndg_BindingGearManager gear = Quest.GetQuest("bndg_BindingGearManagerQuest") as bndg_BindingGearManager
        if gear.GetDhlpActive()
            if ShowMessage("You are clearing the DHLP flag. This could have serious impact on running mods. Are you sure?")
                gear.SendModEvent("dhlp-Resume")
                gear.ClearDhlpActive()
                ForcePageReset()
            endif
        else
            ;do nothing
        endif
        skipOthers = true
    endif

    if option == toggleSetLeavesItems && !skipOthers
        int leavesItems = StorageUtil.GetIntValue(thePlayer, gearsData.STORAGE_KEY_LEAVES_ITEMS + selectedSlot, 0) 
        if leavesItems == 1
            leavesItems = 0
        else
            leavesitems = 1
        endif
        StorageUtil.SetIntValue(thePlayer, gearsData.STORAGE_KEY_LEAVES_ITEMS + selectedSlot, leavesItems)
        SetToggleOptionValue(option, leavesItems)
        skipOthers = true        
    endif

    if option == toggleClearShout && !skipOthers
        if ShowMessage("Clear stored voice?", true, "$Yes", "$No")
            StorageUtil.SetFormValue(thePlayer, gearsData.STORAGE_KEY_VOICE + selectedSlot, none)
            ForcePageReset()
        endif
        skipOthers = true
    endif

    if option == toggleClearRightHandWeapon && !skipOthers
        if ShowMessage("Clear right hand weapon / spell?", true, "$Yes", "$No")
            StorageUtil.SetFormValue(thePlayer, gearsData.STORAGE_KEY_RIGHT_HAND + selectedSlot, none)
            ForcePageReset()
        endif
        skipOthers = true
    endif

    if option == toggleClearLeftHandWeapon && !skipOthers
        if ShowMessage("Clear left hand weapon / spell?", true, "$Yes", "$No")
            StorageUtil.SetFormValue(thePlayer, gearsData.STORAGE_KEY_LEFT_HAND + selectedSlot, none)
            ForcePageReset()
        endif
        skipOthers = true
    endif

    if option == toggleClearAmmo && !skipOthers
        if ShowMessage("Clear ammo?", true, "$Yes", "$No")
            StorageUtil.SetFormValue(thePlayer, gearsData.STORAGE_KEY_AMMO + selectedSlot, none)
            ForcePageReset()
        endif
        skipOthers = true
    endif

    if option == toggleLearnRightHandWeapon && !skipOthers
        Form eqRight = bndg_SkseFunctions.GetEquippedRightHand()
        if eqRight == none

        else
            if ShowMessage("Learn " + eqRight.GetName() + "?", true, "$Yes", "$No")
                StorageUtil.SetFormValue(thePlayer, gearsData.STORAGE_KEY_RIGHT_HAND + selectedSlot, bndg_SkseFunctions.GetEquippedRightHand())
                Form w = bndg_SkseFunctions.GetEquippedRightHand()
                if bndg_SkseFunctions.IsTwoHanded(w as Weapon) == 2
                    StorageUtil.SetFormValue(thePlayer, gearsData.STORAGE_KEY_LEFT_HAND + selectedSlot, none)
                endif
                ForcePageReset()
            endif
        endif
        skipOthers = true
    endif

    if option == toggleLearnLeftHandWeapon && !skipOthers
        Form eqLeft = bndg_SkseFunctions.GetEquippedLeftHand()
        if eqLeft == none
            ;ShowMessage("No offhand weapon equipped", false)
        else
            if ShowMessage("Learn " + eqLeft.GetName() + "?", true, "$Yes", "$No")
                StorageUtil.SetFormValue(thePlayer, gearsData.STORAGE_KEY_LEFT_HAND + selectedSlot, bndg_SkseFunctions.GetEquippedLeftHand())
                ForcePageReset()
            endif
        endif
        skipOthers = true
    endif

    if option == toggleLearnAmmo && !skipOthers
        Form eqAmmo = bndg_SkseFunctions.GetEquippedAmmo()
        if eqAmmo == none
            ;ShowMessage("No ammo is equipped", false)
        else
            if ShowMessage("Learn " + eqAmmo.GetName() + "?", true, "$Yes", "$No")
                StorageUtil.SetFormValue(thePlayer, gearsData.STORAGE_KEY_AMMO + selectedSlot, eqAmmo)
                ForcePageReset()
            endif
        endif
        skipOthers = true
    endif

    if option == toggleLearnShout && !skipOthers
        Form eqVoice = bndg_SkseFunctions.GetEquippedVoice()
        if eqVoice == none
            ;ShowMessage("No ammo is equipped", false)
        else
            if ShowMessage("Learn " + eqVoice.GetName() + "?", true, "$Yes", "$No")
                StorageUtil.SetFormValue(thePlayer, gearsData.STORAGE_KEY_VOICE + selectedSlot, eqVoice)
                ;bndg_SkseFunctions.LearnAmmo(selectedSlot)
                ;ShowMessage("Ammo learned", false)
                ForcePageReset()
            endif
        endif
        skipOthers = true
    endif

    if option == toggleUseAnimation && !skipOthers
        int animFlag = StorageUtil.GetIntValue(thePlayer, gearsData.STORAGE_KEY_ANIMATIONS, 0)
        if animFlag == 1
            StorageUtil.SetIntValue(thePlayer, gearsData.STORAGE_KEY_ANIMATIONS, 0)
            bndg_SkseFunctions.ToggleAnimations(0)
            SetToggleOptionValue(option, 0)
        else
            StorageUtil.SetIntValue(thePlayer, gearsData.STORAGE_KEY_ANIMATIONS, 1)
            bndg_SkseFunctions.ToggleAnimations(1)
            SetToggleOptionValue(option, 1)
        endif
        skipOthers = true
    endif

    if option == toggleBlockDuringDHLP && !skipOthers
        int dhlpFlag = StorageUtil.GetIntValue(thePlayer, gearsData.STORAGE_KEY_DHLP_BLOCKED, 0)
        if dhlpFlag == 1
            StorageUtil.SetIntValue(thePlayer, gearsData.STORAGE_KEY_DHLP_BLOCKED, 0)
            SetToggleOptionValue(option, 0)
        else
            StorageUtil.SetIntValue(thePlayer, gearsData.STORAGE_KEY_DHLP_BLOCKED, 1)
            SetToggleOptionValue(option, 1)
        endif
        skipOthers = true
    endif

    if option == toggleDoNotUnequipSpells && !skipOthers
        skipOthers = true
    endif

    if option == wheelMenuModifierOption && !skipOthers
        int hk = StorageUtil.GetIntValue(thePlayer, gearsData.STORAGE_KEY_KEYCODE + "0", -1)
        int hkm = StorageUtil.GetIntValue(thePlayer, gearsData.STORAGE_KEY_MODIFIER + "0", 0)
        int newModifier = AdvanceModifierValue(hkm)

        StorageUtil.SetIntValue(thePlayer, gearsData.STORAGE_KEY_MODIFIER + "0", newModifier)
        bndg_SkseFunctions.SetHotkey(0, hk, newModifier)
        SetTextOptionValue(option, GetModifierString(newModifier))
        skipOthers = true
    endif

    if option == toggleLearnSlot && !skipOthers
        if !working
            working = true
            if ShowMessage("Use worn items to build this slot?", true, "$Yes", "$No")
                
                Form[] wornItems = bndg_SkseFunctions.GetWornGear();
                StorageUtil.FormListCopy(thePlayer, gearsData.STORAGE_KEY_GEAR + selectedSlot, wornItems)
                StorageUtil.SetFormValue(thePlayer, gearsData.STORAGE_KEY_RIGHT_HAND + selectedSlot, bndg_SkseFunctions.GetEquippedRightHand())
                StorageUtil.SetFormValue(thePlayer, gearsData.STORAGE_KEY_LEFT_HAND + selectedSlot, bndg_SkseFunctions.GetEquippedLeftHand())
                StorageUtil.SetFormValue(thePlayer, gearsData.STORAGE_KEY_AMMO + selectedSlot, bndg_SkseFunctions.GetEquippedAmmo())
                StorageUtil.SetFormValue(thePlayer, gearsData.STORAGE_KEY_VOICE + selectedSlot, bndg_SkseFunctions.GetEquippedVoice())

                ForcePageReset()
                skipOthers = true
            endif
            working = false
        endif
    endif

    if !skipOthers
        if !working
            working = true
            idx = 1
            while idx <= bndg_BindingGearManager.GetSlotCount()
                if option == modifierOption[idx]
                    int hk = StorageUtil.GetIntValue(thePlayer, gearsData.STORAGE_KEY_KEYCODE + idx, -1)
                    int hkm = StorageUtil.GetIntValue(thePlayer, gearsData.STORAGE_KEY_MODIFIER + idx, 0)

                    int newModifier = AdvanceModifierValue(hkm)
                    
                    StorageUtil.SetIntValue(thePlayer, gearsData.STORAGE_KEY_MODIFIER + idx, newModifier)
                    bndg_SkseFunctions.SetHotkey(idx, hk, newModifier)
                    SetTextOptionValue(option, GetModifierString(newModifier))
                    skipOthers = true
                    ;ForcePageReset()
                endif
                idx += 1
            endwhile
            working = false
        endif
    endif

    if !skipOthers
        if !working
            working = true
            idx = 0
            Form[] items = StorageUtil.FormListToArray(thePlayer, gearsData.STORAGE_KEY_GEAR + selectedSlot) ;bndg_SkseFunctions.GetSetItems(selectedSlot)
            while idx < items.Length
                if option == toggleClearItem[idx]
                    Form selectedItem = items[idx] ;JsonUtil.FormListGet(gearsData.JsonFileName, "binding_gear_items_" + selectedSlot, idx)
                    if ShowMessage("Remove " + selectedItem.GetName() + " from set?", true, "$Yes", "$No")
                        StorageUtil.FormListRemove(thePlayer, gearsData.STORAGE_KEY_GEAR + selectedSlot, selectedItem, true) ;remove all
                        ForcePageReset()
                        skipOthers = true
                    endif
                    idx = 500
                endif
                idx += 1
            endwhile
            working = false 
        endif
    endif

    if !skipOthers
        if !working
            working = true
            Form[] items = bndg_SkseFunctions.GetWornGear()
            idx = 0
            while idx < items.Length
                if option == toggleLearnItem[idx]
                    Form selectedItem = items[idx]
                    if ShowMessage("Learn " + selectedItem.GetName() + " from set?", true, "$Yes", "$No")
                        StorageUtil.FormListAdd(thePlayer, gearsData.STORAGE_KEY_GEAR + selectedSlot, selectedItem, false) ;no duplicates
                        ForcePageReset()
                        skipOthers = true
                    endif
                    idx = 500
                endif
                idx += 1
            endwhile
            working = false 
        endif
    endif

endevent

event OnOptionKeyMapChange(int option, int keyCode, string conflictControl, string conflictName)

	bool continue = true
	if (conflictControl != "" && keyCode != 1)
		string msg
		if (conflictControl != "")
			msg = "This key is mapped to:\n'" + conflictControl + "'\n(" + conflictName + ")\n\nDo you want to continue?"
		else
			msg = "This key is mapped to:\n'" + conflictControl + "'\n\nDo you want to continue?"
		endIf
		continue = ShowMessage(msg, true, "$Yes", "$No")
	endIf

	; clear if escape key
	if (keyCode == 1)
		keyCode = -1
	endIf

	if (continue)
        if option == wheelMenuKeymapOption
            StorageUtil.SetIntValue(thePlayer, gearsData.STORAGE_KEY_KEYCODE + "0", keyCode)
            bndg_SkseFunctions.SetHotkey(0, keyCode, StorageUtil.GetIntValue(thePlayer, gearsData.STORAGE_KEY_MODIFIER + "0"))
            SetKeyMapOptionValue(wheelMenuKeymapOption, keyCode)
        endif

        idx = 1
        while idx <= bndg_BindingGearManager.GetSlotCount()
            if option == keymapOption[idx]
                StorageUtil.SetIntValue(thePlayer, gearsData.STORAGE_KEY_KEYCODE + idx, keyCode)
                StorageUtil.SetIntValue(thePlayer, gearsData.STORAGE_KEY_MODIFIER + idx, 0)
                bndg_SkseFunctions.SetHotkey(idx, keyCode, StorageUtil.GetIntValue(thePlayer, gearsData.STORAGE_KEY_MODIFIER + idx))
                SetKeyMapOptionValue(keymapOption[idx], keyCode)
            endif
            idx += 1
        endwhile
    endif

endevent

function BackupSettingsToJson()

    string fileName = "/binding_gear_backup/settings/settings.json"

    JsonUtil.SetIntValue(fileName, gearsData.STORAGE_KEY_ANIMATIONS, StorageUtil.GetIntValue(thePlayer, gearsData.STORAGE_KEY_ANIMATIONS, 0))
    JsonUtil.SetIntValue(fileName, gearsData.STORAGE_KEY_DHLP_BLOCKED, StorageUtil.GetIntValue(thePlayer, gearsData.STORAGE_KEY_DHLP_BLOCKED, 0))

    idx = 1
    while idx <= gearsData.SLOT_COUNT
        JsonUtil.SetIntValue(fileName, gearsData.STORAGE_KEY_KEYCODE + idx, StorageUtil.GetIntValue(thePlayer, gearsData.STORAGE_KEY_KEYCODE + idx)) 
        JsonUtil.SetIntValue(fileName, gearsData.STORAGE_KEY_MODIFIER + idx, StorageUtil.GetIntValue(thePlayer, gearsData.STORAGE_KEY_MODIFIER + idx)) 

        idx += 1
    endwhile

    JsonUtil.SetIntValue(fileName, gearsData.STORAGE_KEY_KEYCODE + "0", StorageUtil.GetIntValue(thePlayer, gearsData.STORAGE_KEY_KEYCODE + "0"))
    JsonUtil.SetIntValue(fileName, gearsData.STORAGE_KEY_MODIFIER + "0", StorageUtil.GetIntValue(thePlayer, gearsData.STORAGE_KEY_MODIFIER + "0"))

    JsonUtil.SetIntValue(fileName, "backup_exists", 1)

    JsonUtil.Save(fileName)

    ShowMessage("Settings & Hotkeys backup completed")

endfunction

function RestoreSettingsFromJson()

    string fileName = "/binding_gear_backup/settings/settings.json"

    StorageUtil.SetIntValue(thePlayer, gearsData.STORAGE_KEY_ANIMATIONS, JsonUtil.GetIntValue(fileName, gearsData.STORAGE_KEY_ANIMATIONS))
    StorageUtil.SetIntValue(thePlayer, gearsData.STORAGE_KEY_DHLP_BLOCKED, JsonUtil.GetIntValue(fileName, gearsData.STORAGE_KEY_DHLP_BLOCKED))

    idx = 1
    while idx <= gearsData.SLOT_COUNT
        StorageUtil.SetIntValue(thePlayer, gearsData.STORAGE_KEY_KEYCODE + idx, JsonUtil.GetIntValue(fileName, gearsData.STORAGE_KEY_KEYCODE + idx))
        StorageUtil.SetIntValue(thePlayer, gearsData.STORAGE_KEY_MODIFIER + idx, JsonUtil.GetIntValue(fileName, gearsData.STORAGE_KEY_MODIFIER + idx))

        idx += 1
    endwhile

    StorageUtil.SetIntValue(thePlayer, gearsData.STORAGE_KEY_KEYCODE + "0", JsonUtil.GetIntValue(fileName, gearsData.STORAGE_KEY_KEYCODE + "0"))
    StorageUtil.SetIntValue(thePlayer, gearsData.STORAGE_KEY_MODIFIER + "0", JsonUtil.GetIntValue(fileName, gearsData.STORAGE_KEY_MODIFIER + "0"))

    int i = 0
    while i < 9
        bndg_SkseFunctions.SetHotkey(i, StorageUtil.GetIntValue(thePlayer, gearsData.STORAGE_KEY_KEYCODE + i), StorageUtil.GetIntValue(thePlayer, gearsData.STORAGE_KEY_MODIFIER + i))
        i += 1
    endwhile

    bndg_SkseFunctions.ToggleAnimations(StorageUtil.GetIntValue(thePlayer, gearsData.STORAGE_KEY_ANIMATIONS, 0))

    ShowMessage("Settings & Hotkeys backup restored")

endfunction

bndg_BindingGearManager property main auto
bndg_Data property gearsData auto