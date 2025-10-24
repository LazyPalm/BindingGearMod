Scriptname bndg_BindingGearManagerMcm extends SKI_ConfigBase

string version

Actor thePlayer

int selectedSlot
int idx

int toggleLearnSlot
int toggleUseAnimation
int toggleDoNotUnequipSpells
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

int toggleClearPrimaryWeapon
int toggleClearOffhandWeapon
int toggleClearAmmo

int toggleLearnPrimaryWeapon
int toggleLearnOffhandWeapon
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

;adding a note - testing github

event OnConfigOpen()

    thePlayer = Game.GetPlayer()
    keymapOption = new int[10]
    modifierOption = new int[10]
    Pages = new string[9]
    toggleClearItem = new int[128]
    toggleLearnItem = new int[128]
    
    Pages[0] = "Settings"

    idx = 1
    while idx <= bndg_BindingGearManager.GetSlotCount()
        Pages[idx] = "Set " + idx
        idx += 1
    endwhile

endevent

event OnPageReset(string page)

    version = "0.7"

    SetCursorFillMode(LEFT_TO_RIGHT)
    SetCursorPosition(0)

    if page == ""
        DisplayWelcome()
    elseif page == "Settings"
        DisplaySettings()
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

function DisplayWelcome()

    AddTextOption("Version", version)

endfunction

function DisplaySettings()

    AddHeaderOption("General Settings")
    AddHeaderOption("")
    
    toggleUseAnimation = AddToggleOption("Use Animation", bndg_SkseFunctions.GetShowAnimations())
    ;toggleDoNotUnequipSpells = AddToggleOption("Do Not Unequip Spells/Shouts", 0); main.GetDoNotUnequipSpells())
    AddTextOption("", "")

    AddHeaderOption("Hotkeys")
    AddHeaderOption("")

    idx = 1
    while idx <= bndg_BindingGearManager.GetSlotCount()
        int keyCode = bndg_SkseFunctions.GetHotkey(idx) ; main.GetHotkey(idx)
        int modifierKey = bndg_SkseFunctions.GetModifier(idx)
        MiscUtil.PrintConsole("modifier idx : " + idx + " modifier: " + modifierKey)
        if keyCode == 0
            keyCode = -1
        endif
        keymapOption[idx] = AddKeyMapOption("Set " + idx + " hotkey", keyCode)
        modifierOption[idx] = AddTextOption("Set " + idx + " modifier", GetModifierString(modifierKey))
        idx += 1
    endwhile

    int wmHotkey = bndg_SkseFunctions.GetHotkey(0); main.GetWheelMenuHotkey()
    int wmModifierKey = bndg_SkseFunctions.GetModifier(0)
    if wmHotkey == 0
        wmHotkey = -1
    endif
    wheelMenuKeymapOption = AddKeyMapOption("Set wheel menu hotkey", wmHotkey)
    wheelMenuModifierOption = AddTextOption("Set wheel menu modifier", GetModifierString(wmModifierKey)) ;GetModifierString(main.GetWheelMenuModifier()))

endfunction

function DisplaySlot(int slot)

    ;ShowMessage("slot: " + slot, false)

    bndg_BindingGearManager.WriteToConsole("DisplaySlot slot: " + slot)

    selectedSlot = slot

    AddHeaderOption("Set " + slot)
    AddHeaderOption("")

    toggleLearnSlot = AddTextOption("Learn equipped armor", "Learn")
    inputEnterSetName = AddInputOption("Set Name", bndg_SkseFunctions.GetSetName(selectedSlot))    
    toggleSetLeavesItems = AddToggleOption("Set Leaves Existing Items Equipped", bndg_SkseFunctions.GetSetLeavesItems(selectedSlot))
    AddTextOption("", "")

    AddHeaderOption("Weapons / Ammo")
    AddHeaderOption("")

    Form storedWeapon1 = bndg_SkseFunctions.GetWeapon(selectedSlot, true)
    Form storedWeapon2 = bndg_SkseFunctions.GetWeapon(selectedSlot, false)
    Form storedAmmo = bndg_SkseFunctions.GetAmmo(selectedSlot)

    string storedWeapon1Name = ""
    string storedWeapon2Name = ""
    string storedAmmoName = ""

    if storedWeapon1 != none
        storedWeapon1Name = storedWeapon1.GetName()
    endif
    if storedWeapon2 != none
        storedWeapon2Name = storedWeapon2.GetName()
    endif
    if storedAmmo != none
        storedAmmoName = storedAmmo.GetName()
    endif

    toggleClearPrimaryWeapon = AddTextOption("Primary Weapon", storedWeapon1Name)
    toggleClearOffhandWeapon = AddTextOption("Offhand Weapon", storedWeapon2Name)
    toggleClearAmmo = AddTextOption("Ammo", storedAmmoName)
    AddTextOption("", "")

    AddHeaderOption("Spells / Shout")
    AddHeaderOption("")

    Spell leftHandSpell = bndg_SkseFunctions.GetSpell(selectedSlot, 1) 
    Spell rightHandSpell = bndg_SkseFunctions.GetSpell(selectedSlot, 2)
    Shout shoutSpell = bndg_SkseFunctions.GetShout(selectedSlot)
    Spell otherSpell = bndg_SkseFunctions.GetSpell(selectedSlot, 3)

    string lSpellName = ""
    string rSpellName = ""
    string shoutName = ""
    if leftHandSpell != none
        lSpellName = leftHandSpell.GetName()
    endif
    if rightHandSpell != none
        rSpellName = rightHandSpell.GetName()
    endif
    if shoutSpell != none
        shoutName = shoutSpell.GetName()
    endif
    if otherSpell != none
        shoutName = otherSpell.GetName()
    endif

    toggleClearLeftHandSpell = AddTextOption("Left Hand Spell", lSpellName)
    toggleClearRightHandSpell = AddTextOption("Right Hand Spell", rSpellName)
    toggleClearShout = AddTextOption("Shout/Voice Spell", shoutName)
    AddTextOption("", "")

    AddHeaderOption("Items In Set")
    AddHeaderOption("")

    Form[] items = bndg_SkseFunctions.GetSetItems(selectedSlot)

    bndg_BindingGearManager.WriteToConsole("DisplaySlot items: " + items)

    if items.Length > 0
        idx = 0
        while idx < items.Length
            Form item = items[idx]
            toggleClearItem[idx] = AddTextOption(item.GetName(), "")
            idx += 1
        endwhile
    endif

    if items.Length % 2 != 0 && items.Length > 0
        AddTextOption("", "")
    endif

    AddHeaderOption("Learn From Equipped Gear")
    AddHeaderOption("")
    Form[] inventory = bndg_SkseFunctions.GetWornGear()
    ;debug.MessageBox(inventory)
    idx = 0
    int equippedCount = 0
    ; Form[] wornItems = StorageUtil.FormListToArray(thePlayer, bndg_Data.WornItemsStorageKey())
    ; while idx < wornItems.Length
    ;     Form item = wornItems[idx]
    ;     if item != none
    ;         equippedCount += 1
    ;         toggleLearnItem[idx] = AddTextOption(item.GetName(), "")
    ;     endif
    ;     idx += 1
    ; endwhile
    while idx < inventory.Length
        Form item = inventory[idx]
        if thePlayer.IsEquipped(item) && item.IsPlayable()
            equippedCount += 1
            ;bndg_BindingGearManager.WriteToConsole("equipped item: " + item)
            toggleLearnItem[idx] = AddTextOption(item.GetName(), "")
        endif
        idx += 1
    endwhile
    
    if equippedCount % 2 != 0 && equippedCount > 0
        AddTextOption("", "")
    endif

    AddHeaderOption("Learn From Equipped Weapons / Ammo")
    AddHeaderOption("")
    Form eqWeapon1 = thePlayer.GetEquippedWeapon(false)
    Form eqWeapon2 = thePlayer.GetEquippedWeapon(true)
    Form eqAmmo = bndg_SkseFunctions.GetEquippedAmmo(thePlayer)

    string eqWeapon1Name = ""
    string eqWeapon2Name = ""
    string eqAmmoName = ""

    if eqWeapon1 != none
        eqWeapon1Name = eqWeapon1.GetName()
    endif
    if eqWeapon2 != none
        eqWeapon2Name = eqWeapon2.GetName()
    endif
    if eqAmmo != none
        eqAmmoName = eqAmmo.GetName()
    endif

    toggleLearnPrimaryWeapon = AddTextOption("Primary Weapon", eqWeapon1Name)
    toggleLearnOffhandWeapon = AddTextOption("Offhand Weapon", eqWeapon2Name)
    toggleLearnAmmo = AddTextOption("Ammo", eqAmmoName)
    AddTextOption("", "")


    AddHeaderOption("Learn From Equipped Spells / Shout")
    AddHeaderOption("")
    Spell eqSpellLeft = thePlayer.GetEquippedSpell(0)
    Spell eqSpellRight = thePlayer.GetEquippedSpell(1)

    string eqLeftSpellName = ""
    string eqRightSpellName = ""

    if eqSpellLeft != none
        eqLeftSpellName = eqSpellLeft.GetName()
    endif

    if eqSpellRight != none
        eqRightSpellName = eqSpellRight.GetName()
    endif

    string eqShoutName = ""
    Shout eqShout = thePlayer.GetEquippedShout()
    Spell eqSpellOther = thePlayer.GetEquippedSpell(2)
    if eqShout
        eqShoutName = eqShout.GetName()
    endif
    if eqSpellOther
        eqShoutName = eqSpellOther.GetName()
    endif

    bndg_BindingGearManager.WriteToConsole("equipped shout: " + eqShout + " power: " + eqSpellOther)

    toggleLearnLeftHandSpell = AddTextOption("Left Hand Spell", eqLeftSpellName)
    toggleLearnRightHandSpell = AddTextOption("Right Hand Spell", eqRightSpellName)
    toggleLearnShout = AddTextOption("Shout", eqShoutName)
    AddTextOption("", "")

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
        bndg_SkseFunctions.SetSetName(selectedSlot, textStr)
		SetInputOptionValue(option, textStr)
	endIf
endEvent

event OnOptionSelect(int option)

    bool skipOthers = false

    if option == toggleSetLeavesItems
        int leavesItems = bndg_SkseFunctions.GetSetLeavesItems(selectedSlot)
        if leavesItems == 1
            leavesItems = 0
        else
            leavesitems = 1
        endif
        bndg_SkseFunctions.ToggleSetLeavesItems(selectedSlot, leavesItems == 1)
        SetToggleOptionValue(option, leavesItems)
        skipOthers = true        
    endif

    if option == toggleClearLeftHandSpell
        if ShowMessage("Clear left hand spell? slot -" + selectedSlot, true, "$Yes", "$No")
            bndg_SkseFunctions.ClearSpell(selectedSlot, 1)
            ShowMessage("Left hand spell cleared", false)
            ForcePageReset()
        endif
        skipOthers = true
    endif

    if option == toggleClearRightHandSpell
        if ShowMessage("Clear right hand spell? slot -" + selectedSlot, true, "$Yes", "$No")
            bndg_SkseFunctions.ClearSpell(selectedSlot, 2)
            ShowMessage("Right hand spell cleared", false)
            ForcePageReset()
        endif
        skipOthers = true
    endif

    if option == toggleClearShout
        if ShowMessage("Clear shout? slot -" + selectedSlot, true, "$Yes", "$No")
            bndg_SkseFunctions.ClearSpell(selectedSlot, 3)
            ShowMessage("Shout cleared", false)
            ForcePageReset()
        endif
        skipOthers = true
    endif

    if option == toggleClearPrimaryWeapon
        if ShowMessage("Clear primary weapon?", true, "$Yes", "$No")
            bndg_SkseFunctions.ClearWeapon(selectedSlot, true)
            ShowMessage("Primary weapon cleared", false)
            ForcePageReset()
        endif
        skipOthers = true
    endif

    if option == toggleClearOffhandWeapon
        if ShowMessage("Clear offhand weapon?", true, "$Yes", "$No")
            bndg_SkseFunctions.ClearWeapon(selectedSlot, false)
            ShowMessage("Offhand weapon cleared", false)
            ForcePageReset()
        endif
        skipOthers = true
    endif

    if option == toggleClearAmmo
        if ShowMessage("Clear ammo?", true, "$Yes", "$No")
            bndg_SkseFunctions.ClearAmmo(selectedSlot)
            ShowMessage("Ammo cleared", false)
            ForcePageReset()
        endif
        skipOthers = true
    endif

    if option == toggleLearnPrimaryWeapon
        if thePlayer.GetEquippedWeapon(false) == none
            ShowMessage("No primary weapon equipped", false)
        else
            if ShowMessage("Learn primary weapon?", true, "$Yes", "$No")
                bndg_SkseFunctions.LearnWeapon(selectedSlot, true)
                ShowMessage("Primary weapon learned", false)
                ForcePageReset()
            endif
        endif
        skipOthers = true
    endif

    if option == toggleLearnOffhandWeapon
        if thePlayer.GetEquippedWeapon(false) == none
            ShowMessage("No offhand weapon equipped", false)
        else
            if ShowMessage("Learn offhand weapon?", true, "$Yes", "$No")
                bndg_SkseFunctions.LearnWeapon(selectedSlot, false)
                ShowMessage("Offhand weapon learned", false)
                ForcePageReset()
            endif
        endif
        skipOthers = true
    endif

    if option == toggleLearnAmmo
        if bndg_SkseFunctions.GetEquippedAmmo(thePlayer) == none
            ShowMessage("No ammo is equipped", false)
        else
            if ShowMessage("Learn ammo?", true, "$Yes", "$No")
                bndg_SkseFunctions.LearnAmmo(selectedSlot)
                ShowMessage("Ammo learned", false)
                ForcePageReset()
            endif
        endif
        skipOthers = true
    endif

    if option == toggleLearnLeftHandSpell
        if thePlayer.GetEquippedSpell(0) == none
            ShowMessage("No left hand spell equipped", false)
        else
            if ShowMessage("Learn left hand spell?", true, "$Yes", "$No")
                bndg_SkseFunctions.LearnSpell(selectedSlot, 1, thePlayer.GetEquippedSpell(0))
                ShowMessage("Left hand spell learned", false)
                ForcePageReset()
            endif
        endif
        skipOthers = true
    endif

    if option == toggleLearnRightHandSpell
        if thePlayer.GetEquippedSpell(1) == none
            ShowMessage("No right hand spell equipped", false)
        else
            if ShowMessage("Learn right hand spell?", true, "$Yes", "$No")
                bndg_SkseFunctions.LearnSpell(selectedSlot, 2, thePlayer.GetEquippedSpell(1))
                ShowMessage("Right hand spell learned", false)
                ForcePageReset()
            endif
        endif
        skipOthers = true
    endif

    if option == toggleLearnShout
        if thePlayer.GetEquippedSpell(2) == none && thePlayer.GetEquippedShout() == none
            ShowMessage("No shout or voice spell equipped", false)
        else
            if ShowMessage("Learn shout / voice spell?", true, "$Yes", "$No")
                if thePlayer.GetEquippedSpell(2) != none
                    bndg_SkseFunctions.LearnSpell(selectedSlot, 3, thePlayer.GetEquippedSpell(2))
                    bndg_SkseFunctions.ClearShout(selectedSlot)
                else
                    bndg_SkseFunctions.LearnShout(selectedSlot, thePlayer.GetEquippedShout())
                    bndg_SkseFunctions.ClearSpell(selectedSlot, 3)
                endif
                ShowMessage("Shout / voice spell learned", false)
                ForcePageReset()
            endif
        endif
        skipOthers = true
    endif

    if option == toggleUseAnimation
        if bndg_SkseFunctions.GetShowAnimations() == 1
            bndg_SkseFunctions.ToggleAnimations(0)
            SetToggleOptionValue(option, 0)
        else
            bndg_SkseFunctions.ToggleAnimations(1)
            SetToggleOptionValue(option, 1)
        endif
        skipOthers = true
    endif

    if option == toggleDoNotUnequipSpells
        ; if main.GetDoNotUnequipSpells() == 1
        ;     main.SetDoNotUnequipSpells(0)
        ;     SetToggleOptionValue(option, 0)
        ; else
        ;     main.SetDoNotUnequipSpells(1)
        ;     SetToggleOptionValue(option, 1)
        ; endif
        skipOthers = true
    endif

    if option == wheelMenuModifierOption
        int hk = bndg_SkseFunctions.GetHotkey(0)
        int hkm = bndg_SkseFunctions.GetModifier(0)
        int newModifier = AdvanceModifierValue(hkm)

        bndg_SkseFunctions.LearnHotKey(0, hk, newModifier)
        ; int currentModifier = main.GetWheelMenuModifier()
        ; int newModifier = AdvanceModifierValue(currentModifier)
        ; main.SetWheelMenuModifier(newModifier)
        SetTextOptionValue(option, GetModifierString(newModifier))
        skipOthers = true
    endif

    if option == toggleLearnSlot && !working && !skipOthers
        working = true
        if ShowMessage("Use worn items to build this slot?", true, "$Yes", "$No")
            ;LearnWornGear()
            bndg_SkseFunctions.LearnWornGear(selectedSlot);
            ShowMessage("Worn items learned", false)
            ForcePageReset()
            skipOthers = true
        endif
        working = false
    endif

    if !working && !skipOthers
        working = true
        idx = 1
        while idx <= bndg_BindingGearManager.GetSlotCount()
            if option == modifierOption[idx]
                int hk = bndg_SkseFunctions.GetHotkey(idx)
                int hkm = bndg_SkseFunctions.GetModifier(idx)
                int newModifier = AdvanceModifierValue(hkm)
                ;debug.MessageBox("idx: " + idx + " hk:" + hk + " hkm: " + hkm + " new: " + newModifier)
                bndg_SkseFunctions.LearnHotKey(idx, hk, newModifier)
                ; int currentModifier = main.GetModifierKey(idx)
                ; int newModifier = AdvanceModifierValue(currentModifier)
                ; main.SetModifierKey(idx, newModifier)
                SetTextOptionValue(option, GetModifierString(newModifier))
                skipOthers = true
                ;ForcePageReset()
            endif
            idx += 1
        endwhile
        working = false
    endif

    if !working && !skipOthers
        working = true
        idx = 0
        Form[] items = bndg_SkseFunctions.GetSetItems(selectedSlot)
        while idx < items.Length
            if option == toggleClearItem[idx]
                Form selectedItem = items[idx] ;JsonUtil.FormListGet(gearsData.JsonFileName, "binding_gear_items_" + selectedSlot, idx)
                if ShowMessage("Remove " + selectedItem.GetName() + " from set?", true, "$Yes", "$No")
                    bndg_SkseFunctions.RemoveSetItem(selectedSlot, selectedItem)
                    ShowMessage("Item removed from set", false)
                    ForcePageReset()
                    skipOthers = true
                endif
                idx = 500
            endif
            idx += 1
        endwhile
        working = false 
    endif

    if !working && !skipOthers
        working = true
        Form[] items = bndg_SkseFunctions.GetWornGear()
        idx = 0
        while idx < items.Length
            if option == toggleLearnItem[idx]
                Form selectedItem = items[idx]
                if ShowMessage("Learn " + selectedItem.GetName() + " from set?", true, "$Yes", "$No")
                    bndg_SkseFunctions.AddSetItem(selectedSlot, selectedItem)
                    ShowMessage("Item added to set", false)
                    ForcePageReset()
                    skipOthers = true
                endif
                idx = 500
            endif
            idx += 1
        endwhile
        working = false 
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
            ; if main.GetWheelMenuHotkey() > 0
            ;     ;UnregisterForKey(main.GetWheelMenuHotkey())
            ; endif
            ;main.SetWheelMenuHotKey(keyCode)
            ;RegisterForKey(keyCode)
            bndg_SkseFunctions.LearnHotKey(0, keyCode, 0)
            SetKeyMapOptionValue(wheelMenuKeymapOption, keyCode)
        endif

        idx = 1
        while idx <= bndg_BindingGearManager.GetSlotCount()
            if option == keymapOption[idx]
                ; if main.GetHotkey(idx) > 0
                ;     ;UnregisterForKey(main.GetHotkey(idx))
                ; endif
                int hkm = bndg_SkseFunctions.GetModifier(idx)
                bndg_SkseFunctions.LearnHotKey(idx, keyCode, hkm)
                ;Debug.MessageBox(keyCode)
                ;main.SetHotkey(idx, keyCode)
                ;RegisterForKey(keyCode)
                SetKeyMapOptionValue(keymapOption[idx], keyCode)
            endif
            idx += 1
        endwhile
    endif

endevent

bndg_BindingGearManager property main auto
bndg_Data property gearsData auto