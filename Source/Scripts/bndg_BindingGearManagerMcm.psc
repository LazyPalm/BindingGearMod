Scriptname bndg_BindingGearManagerMcm extends SKI_ConfigBase

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

endfunction

function DisplaySettings()

    AddHeaderOption("General Settings")
    AddHeaderOption("")
    
    toggleUseAnimation = AddToggleOption("Use Animation", main.GetUseAnimation())
    toggleDoNotUnequipSpells = AddToggleOption("Do Not Unequip Spells/Shouts", main.GetDoNotUnequipSpells())

    AddHeaderOption("Hotkeys")
    AddHeaderOption("")

    idx = 1
    while idx <= bndg_BindingGearManager.GetSlotCount()
        int keyCode = main.GetHotkey(idx)
        int modifierKey = main.GetModifierKey(idx)
        if keyCode == 0
            keyCode = -1
        endif
        keymapOption[idx] = AddKeyMapOption("Set " + idx + " hotkey", keyCode)
        modifierOption[idx] = AddTextOption("Set " + idx + " modifier", GetModifierString(modifierKey))
        idx += 1
    endwhile

    int wmHotkey = main.GetWheelMenuHotkey()
    if wmHotkey == 0
        wmHotkey = -1
    endif
    wheelMenuKeymapOption = AddKeyMapOption("Set wheel menu hotkey", wmHotkey)
    wheelMenuModifierOption = AddTextOption("Set wheel menu modifier", GetModifierString(main.GetWheelMenuModifier()))

endfunction

function DisplaySlot(int slot)

    bndg_BindingGearManager.WriteToConsole("DisplaySlot slot: " + slot)

    selectedSlot = slot

    AddHeaderOption("Set " + slot)
    AddHeaderOption("")

    toggleLearnSlot = AddTextOption("Learn worn items", "Learn")
    inputEnterSetName = AddInputOption("Set Name", StorageUtil.GetStringValue(thePlayer, "binding_gear_slot_name_" + slot, ""))    
    toggleSetLeavesItems = AddToggleOption("Set Leaves Existing Items Equipped", StorageUtil.GetIntValue(thePlayer, "binding_gear_slot_leaves_items_" + slot, 0))
    AddTextOption("", "")

    AddHeaderOption("Spells / Shout")
    AddHeaderOption("")

    Form leftHandSpell = StorageUtil.GetFormValue(thePlayer, "binding_gear_spell_left_" + slot)
    Form rightHandSpell = StorageUtil.GetFormValue(thePlayer, "binding_gear_spell_right_" + slot)
    Form shoutSpell = StorageUtil.GetFormValue(thePlayer, "binding_gear_shout_" + slot)
    Form otherSpell = StorageUtil.GetFormValue(thePlayer, "binding_gear_spell_other_" + slot)
    string shoutName = ""
    if shoutSpell
        shoutName = otherSpell.GetName()
    endif
    if otherSpell
        shoutName = otherSpell.GetName()
    endif

    toggleClearLeftHandSpell = AddTextOption("Left Hand Spell", leftHandSpell.GetName())
    toggleClearRightHandSpell = AddTextOption("Right Hand Spell", rightHandSpell.GetName())
    toggleClearShout = AddTextOption("Shout", shoutName)
    AddTextOption("", "")

    AddHeaderOption("Items In Set")
    AddHeaderOption("")

    Form[] items = StorageUtil.FormListToArray(thePlayer, "binding_gear_items_" + selectedSlot)

    bndg_BindingGearManager.WriteToConsole("DisplaySlot items: " + items)

    if items.Length > 0
        idx = 0
        while idx < items.Length
            toggleClearItem[idx] = AddTextOption(items[idx].GetName(), "")
            idx += 1
        endwhile
    endif

    if items.Length % 2 != 0 && items.Length > 0
        AddTextOption("", "")
    endif

    AddHeaderOption("Learn From Current Gear")
    AddHeaderOption("")
    Form[] inventory = thePlayer.GetContainerForms()
    idx = 0
    int equippedCount = 0
    while idx < inventory.Length
        Form item = inventory[idx]
        if thePlayer.IsEquipped(item)
            equippedCount += 1
            ;bndg_BindingGearManager.WriteToConsole("equipped item: " + item)
            toggleLearnItem[idx] = AddTextOption(items[idx].GetName(), "")
        endif
        idx += 1
    endwhile
    
    if equippedCount % 2 != 0 && equippedCount > 0
        AddTextOption("", "")
    endif

    AddHeaderOption("Learn From Equipped Spells / Shout")
    AddHeaderOption("")
    Spell eqSpellLeft = thePlayer.GetEquippedSpell(0)
    Spell eqSpellRight = thePlayer.GetEquippedSpell(1)

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

    toggleLearnLeftHandSpell = AddTextOption("Left Hand Spell", eqSpellLeft.GetName())
    toggleLearnRightHandSpell = AddTextOption("Right Hand Spell", eqSpellRight.GetName())
    toggleLearnShout = AddTextOption("Shout", eqShoutName)
    AddTextOption("", "")

endfunction

bool working

string function GetModifierString(int modifierValue)
    string modifierStr = "None"
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
		StorageUtil.SetStringValue(thePlayer, "binding_gear_slot_name_" + selectedSlot, textStr)
		SetInputOptionValue(option, textStr)
	endIf
endEvent

event OnOptionSelect(int option)

    bool skipOthers = false

    if option == toggleSetLeavesItems
        int leavesItems = StorageUtil.GetIntValue(thePlayer, "binding_gear_slot_leaves_items_" + selectedSlot, 0)
        if leavesItems == 1
            leavesItems = 0
        else
            leavesitems = 1
        endif
        StorageUtil.SetIntValue(thePlayer, "binding_gear_slot_leaves_items_" + selectedSlot, leavesItems)
        SetToggleOptionValue(option, leavesItems)
        skipOthers = true        
    endif

    if option == toggleClearLeftHandSpell
        if ShowMessage("Clear left hand spell?", true, "$Yes", "$No")
            StorageUtil.SetFormValue(thePlayer, "binding_gear_spell_left_" + selectedSlot, none)
            ForcePageReset()
        endif
        skipOthers = true
    endif

    if option == toggleClearRightHandSpell
        if ShowMessage("Clear right hand spell?", true, "$Yes", "$No")
            StorageUtil.SetFormValue(thePlayer, "binding_gear_spell_right_" + selectedSlot, none)
            ForcePageReset()
        endif
        skipOthers = true
    endif

    if option == toggleClearShout
        if ShowMessage("Clear shout?", true, "$Yes", "$No")
            StorageUtil.SetFormValue(thePlayer, "binding_gear_shout_" + selectedSlot, none)
            StorageUtil.SetFormValue(thePlayer, "binding_gear_spell_other_" + selectedSlot, none)
            ForcePageReset()
        endif
        skipOthers = true
    endif

    if option == toggleLearnLeftHandSpell
        if ShowMessage("Learn left hand spell?", true, "$Yes", "$No")
            StorageUtil.SetFormValue(thePlayer, "binding_gear_spell_left_" + selectedSlot, thePlayer.GetEquippedSpell(0))
            ForcePageReset()
        endif
        skipOthers = true
    endif

    if option == toggleLearnRightHandSpell
        if ShowMessage("Learn right hand spell?", true, "$Yes", "$No")
            StorageUtil.SetFormValue(thePlayer, "binding_gear_spell_right_" + selectedSlot, thePlayer.GetEquippedSpell(1))
            ForcePageReset()
        endif
        skipOthers = true
    endif

    if option == toggleLearnShout
        if ShowMessage("Learn shout?", true, "$Yes", "$No")
            StorageUtil.SetFormValue(thePlayer, "binding_gear_shout_" + selectedSlot, thePlayer.GetEquippedShout())
            StorageUtil.SetFormValue(thePlayer, "binding_gear_spell_other_" + selectedSlot, thePlayer.GetEquippedSpell(2))
            ForcePageReset()
        endif
        skipOthers = true
    endif

    if option == toggleUseAnimation
        if main.GetUseAnimation() == 1
            main.SetUseAnimation(0)
            SetToggleOptionValue(option, 0)
        else
            main.SetUseAnimation(1)
            SetToggleOptionValue(option, 1)
        endif
        skipOthers = true
    endif

    if option == toggleDoNotUnequipSpells
        if main.GetDoNotUnequipSpells() == 1
            main.SetDoNotUnequipSpells(0)
            SetToggleOptionValue(option, 0)
        else
            main.SetDoNotUnequipSpells(1)
            SetToggleOptionValue(option, 1)
        endif
        skipOthers = true
    endif

    if option == wheelMenuModifierOption
        int currentModifier = main.GetWheelMenuModifier()
        int newModifier = AdvanceModifierValue(currentModifier)
        main.SetWheelMenuModifier(newModifier)
        SetTextOptionValue(option, GetModifierString(newModifier))
        skipOthers = true
    endif

    if option == toggleLearnSlot && !working && !skipOthers
        working = true
        if ShowMessage("Use worn items to build this slot?", true, "$Yes", "$No")
            LearnWornGear()
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
                int currentModifier = main.GetModifierKey(idx)
                int newModifier = AdvanceModifierValue(currentModifier)
                main.SetModifierKey(idx, newModifier)
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
        while idx < StorageUtil.FormListCount(thePlayer, "binding_gear_items_" + selectedSlot)
            if option == toggleClearItem[idx]
                Form selectedItem = StorageUtil.FormListGet(thePlayer, "binding_gear_items_" + selectedSlot, idx)
                if ShowMessage("Remove " + selectedItem.GetName() + " from set?", true, "$Yes", "$No")
                    StorageUtil.SetIntValue(selectedItem, "binding_gear_slot_" + selectedSlot, 0)
                    StorageUtil.FormListRemoveAt(thePlayer, "binding_gear_items_" + selectedSlot, idx)
                    ForcePageReset()
                    skipOthers = true
                endif
                idx = 50
            endif
            idx += 1
        endwhile
        working = false 
    endif

    if !working && !skipOthers
        working = true
        Form[] inventory = thePlayer.GetContainerForms()
        idx = 0
        while idx < inventory.Length
            if option == toggleLearnItem[idx]
                Form selectedItem = inventory[idx]
                if ShowMessage("Learn " + selectedItem.GetName() + " from set?", true, "$Yes", "$No")
                    StorageUtil.SetIntValue(selectedItem, "binding_gear_slot_" + selectedSlot, 1)
                    StorageUtil.FormListAdd(thePlayer, "binding_gear_items_" + selectedSlot, selectedItem, false)
                    ForcePageReset()
                    skipOthers = true
                endif
                idx = 50
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
            if main.GetWheelMenuHotkey() > 0
                UnregisterForKey(main.GetWheelMenuHotkey())
            endif
            main.SetWheelMenuHotKey(keyCode)
            RegisterForKey(keyCode)
            SetKeyMapOptionValue(wheelMenuKeymapOption, keyCode)
        endif

        idx = 1
        while idx <= bndg_BindingGearManager.GetSlotCount()
            if option == keymapOption[idx]
                if main.GetHotkey(idx) > 0
                    UnregisterForKey(main.GetHotkey(idx))
                endif
                main.SetHotkey(idx, keyCode)
                RegisterForKey(keyCode)
                SetKeyMapOptionValue(keymapOption[idx], keyCode)
            endif
            idx += 1
        endwhile
    endif

endevent

function LearnWornGear()

    Form[] inventory = thePlayer.GetContainerForms()

    StorageUtil.FormListClear(thePlayer, "binding_gear_items_" + selectedSlot)

    idx = 0
	while idx < inventory.Length
		Form item = inventory[idx]
        int currentlyInSlot = StorageUtil.GetIntValue(item, "binding_gear_slot_" + selectedSlot, 0)
        if thePlayer.IsEquipped(item)
            if item.HasKeyword(main.zlib.zad_Lockable) || item.HasKeyword(main.zlib.zad_InventoryDevice)
                bndg_BindingGearManager.WriteToConsole("Item " + item.GetName() + " is a devious device")
            else
                StorageUtil.SetIntValue(item, "binding_gear_slot_" + selectedSlot, 1)
                StorageUtil.FormListAdd(thePlayer, "binding_gear_items_" + selectedSlot, item)
            endif
        Else
            if currentlyInSlot == 1
                StorageUtil.SetIntValue(item, "binding_gear_slot_" + selectedSlot, 0)
            endif
        endif
        idx += 1
    endwhile

    StorageUtil.SetFormValue(thePlayer, "binding_gear_spell_left_" + selectedSlot, thePlayer.GetEquippedSpell(0))
    StorageUtil.SetFormValue(thePlayer, "binding_gear_spell_right_" + selectedSlot, thePlayer.GetEquippedSpell(1))
    StorageUtil.SetFormValue(thePlayer, "binding_gear_shout_" + selectedSlot, thePlayer.GetEquippedShout())
    StorageUtil.SetFormValue(thePlayer, "binding_gear_spell_other_" + selectedSlot, thePlayer.GetEquippedSpell(2))

endfunction




bndg_BindingGearManager property main auto