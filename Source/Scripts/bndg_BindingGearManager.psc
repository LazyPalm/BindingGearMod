Scriptname bndg_BindingGearManager extends Quest  

Actor thePlayer

bool dhlpActive

int[] hotkeys
int[] modifierKeys

int wheelMenuHotkey
int wheelMenuModifier

int idx
bool processInput
int usingSlot
int changeToSlot
bool changingGear
int useAnimation
int gender
int doNotUnequipSpells

bool modifierLeftControl
bool modifierRightControl
bool modifierLeftAlt
bool modifierRightAlt
bool modifierLeftShift
bool modifierRightShift

int keyCodeLeftControl = 29
int keyCodeRightControl = 157
int keyCodeLeftAlt = 56
int keyCodeRightAlt = 184
int keyCodeLeftShift = 42
int keyCodeRightShift = 54

int modiferKeyCurrentlyPressed = 0

event OnInit()

    ;defaults
    hotkeys = new int[10]
    modifierKeys = new int[10]
    thePlayer = Game.GetPlayer()

    RegisterForModEvent("dhlp-Suspend", "OnDhlpSuspend")
    RegisterForModEvent("dhlp-Resume", "OnDhlpResume") 

    GameLoaded()

endevent

bool working = false

event OnKeyUp(Int KeyCode, Float HoldTime)	

    if keyCode == keyCodeLeftControl || keyCode == keyCodeRightControl || keyCode == keyCodeLeftAlt || keyCode == keyCodeRightAlt || keyCode == keyCodeLeftShift || keyCode == keyCodeRightShift
        modiferKeyCurrentlyPressed = 0    
    endif

    if !working
        working = true
	    ProcessKeyUp(KeyCode, HoldTime)
        working = False
    else 
        ;debug.Notification("busy....")
    endif

endevent

event OnKeyDown(int KeyCode)

    If keyCode == keyCodeLeftControl
        bndg_BindingGearManager.WriteToConsole("keyCodeLeftControl pressed...")
        modiferKeyCurrentlyPressed = keyCodeLeftControl
    ElseIf keyCode == keyCodeRightControl
        bndg_BindingGearManager.WriteToConsole("keyCodeRightControl pressed...")
        modiferKeyCurrentlyPressed = keyCodeRightControl
    ElseIf keyCode == keyCodeLeftAlt
        bndg_BindingGearManager.WriteToConsole("keyCodeLeftAlt pressed...")
        modiferKeyCurrentlyPressed = keyCodeLeftAlt
    ElseIf keyCode == keyCodeRightAlt
        bndg_BindingGearManager.WriteToConsole("keyCodeRightAlt pressed...")
        modiferKeyCurrentlyPressed = keyCodeRightAlt
    ElseIf keyCode == keyCodeLeftShift
        bndg_BindingGearManager.WriteToConsole("keyCodeLeftShift pressed...")
        modiferKeyCurrentlyPressed = keyCodeLeftShift
    ElseIf keyCode == keyCodeRightShift
        bndg_BindingGearManager.WriteToConsole("keyCodeRightShift pressed...")
        modiferKeyCurrentlyPressed = keyCodeRightShift 
    
    endif

    ;ProcessKey(KeyCode, 0.0)
endevent

function GameLoaded()
    gender = thePlayer.GetLeveledActorBase().GetSex()
    gearsData.GameLoaded()

    UnregisterForKey(keyCodeLeftControl)
    UnregisterForKey(keyCodeRightControl)
    UnregisterForKey(keyCodeLeftAlt)
    UnregisterForKey(keyCodeRightAlt)
    UnregisterForKey(keyCodeLeftShift)
    UnregisterForKey(keyCodeRightShift)

    RegisterForKey(keyCodeLeftControl)
    RegisterForKey(keyCodeRightControl)
    RegisterForKey(keyCodeLeftAlt)
    RegisterForKey(keyCodeRightAlt)
    RegisterForKey(keyCodeLeftShift)
    RegisterForKey(keyCodeRightShift)

    modiferKeyCurrentlyPressed = 0

    ;debug.MessageBox("gear loaded: " + gender)
endfunction

int function GetSlotCount() global
    return 8
endfunction

int function GetHotkey(int slot)
    bndg_BindingGearManager.WriteToConsole("GetHotkey slot: " + slot + " value: " + hotkeys[slot])
    return hotkeys[slot]
endfunction

function SetHotkey(int slot, int keyCode) 
    hotkeys[slot] = keyCode
    bndg_BindingGearManager.WriteToConsole("SetHotkey slot: " + slot + " keycode: " + keyCode + " value: " + hotkeys[slot])
endfunction

int function GetModifierKey(int slot)
    bndg_BindingGearManager.WriteToConsole("GetModifierKey slot: " + slot + " value: " + modifierKeys[slot])
    return modifierKeys[slot]
endfunction

function SetModifierKey(int slot, int keyCode) 
    modifierKeys[slot] = keyCode
    bndg_BindingGearManager.WriteToConsole("SetModifierKey slot: " + slot + " keycode: " + keyCode + " value: " + modifierKeys[slot])
endfunction

int function GetWheelMenuHotkey()
    return wheelMenuHotkey
endfunction

int function GetWheelMenuModifier()
    return wheelMenuModifier
endfunction

function SetWheelMenuHotKey(int keyCode)
    wheelMenuHotkey = keyCode
endfunction

function SetWheelMenuModifier(int keyCode)
    wheelMenuModifier = keyCode
endfunction

function SetUseAnimation(int useAnim)
    useAnimation = useAnim
endfunction

int function GetUseAnimation()
    return useAnimation
endfunction

function SetDoNotUnequipSpells(int flag)
    doNotUnequipSpells = flag
endfunction

int function GetDoNotUnequipSpells()
    return doNotUnequipSpells
endfunction

function WriteToConsole(string msg) global
    MiscUtil.PrintConsole("[BNDG]: " + msg)
    Debug.Trace("[BNDG]: " + msg)
endfunction

; state ProcessingKeyState

;     function ProcessKeyUp(int keyCode, float holdTime)  
;         bndg_BindingGearManager.WriteToConsole("ProcessKey - in ProcessingKeyState")
;         debug.Notification("ProcessKey - in ProcessingKeyState")
;     endfunction

; endstate

function ProcessKeyUp(int keyCode, float holdTime)   

    int i = 1
    while i <= 8
        if keyCode == hotkeys[i] && ((modifierKeys[i] == 0 && modiferKeyCurrentlyPressed == 0) || (modifierKeys[i] == modiferKeyCurrentlyPressed))
            StartGearChange(i)
            i = 100 ;break
        endif
        i += 1
    endwhile

    if keyCode == wheelMenuHotkey && ((wheelMenuModifier == 0 && modiferKeyCurrentlyPressed == 0) || (wheelMenuModifier == modiferKeyCurrentlyPressed))
        ShowWheelMenu()
    endif

endfunction

; function ProcessKeyRETIRED(int keyCode, float holdTime)   

;     GoToState("ProcessingKeyState")

;     bool bLeftControPressed = Input.IsKeyPressed(keyCodeLeftControl)
;     bool bRightControlPressed = Input.IsKeyPressed(keyCodeRightControl)
;     bool bLeftAltPressed = Input.IsKeyPressed(keyCodeLeftAlt)
;     bool bRightAltPressed = Input.IsKeyPressed(keyCodeRightAlt)
;     bool bLeftShiftPressed = Input.IsKeyPressed(keyCodeLeftShift)
;     bool bRightShiftPressed = Input.IsKeyPressed(keyCodeRightShift)
;     bool modifiersPressed = (bLeftControPressed || bRightControlPressed || bLeftAltPressed || bRightAltPressed || bLeftShiftPressed || bRightShiftPressed)

;     bndg_BindingGearManager.WriteToConsole("ProcessKey - In no state - keycode: " + keyCode + " modifiers: " + modifiersPressed)
;     ;bndg_BindingGearManager.WriteToConsole("ProcessInput keyCode: " + keyCode)
;     if !processInput && !changingGear && SafeProcess()
;         processInput = true
;         if (keyCode == wheelMenuHotkey && Input.IsKeyPressed(wheelMenuModifier)) || (keyCode == wheelMenuHotkey && wheelMenuModifier == 0 && !modifiersPressed)
;             ShowWheelMenu()
;         else
;             idx = 1
;             while idx <= bndg_BindingGearManager.GetSlotCount()
;                 if keyCode == hotkeys[idx]
;                     if ((modifierKeys[idx] == 0 && !modifiersPressed) || Input.IsKeyPressed(modifierKeys[idx]))
;                         bndg_BindingGearManager.WriteToConsole("use slot: " + idx)
;                         if !changingGear
;                             changeToSlot = idx
;                             debug.MessageBox("in keypress")
;                             changingGear = true                            
;                             ChangeGear()
;                         endif
;                     endif
;                 endif
;                 idx += 1
;             endwhile
;         endif
;         processInput = false
;     endif

;     GoToState("")

; endfunction

state DhlpState
    ; function ProcessKeyUp(int keyCode, float holdTime)

    ;     ;TODO - this needs to looks for the hotkey and modifiers - goes off on any key now

    ;     ;debug.Notification("<font color='#ff0000'>Gear changes suspended with DHLP event running.</font>")
    ;     bndg_BindingGearManager.WriteToConsole("ProcessKey - In DHLP suspended state")

    ; endfunction
endstate

bool showingWheel = false

function ShowWheelMenu()

    if !showingWheel
        showingWheel = true

        bndg_BindingGearManager.WriteToConsole("Displaying wheel menu")

        UIWheelMenu actionMenu = UIExtensions.GetMenu("UIWheelMenu") as UIWheelMenu
        idx = 0
        while idx < bndg_BindingGearManager.GetSlotCount()
            int itemCount = JsonUtil.FormListCount(gearsData.JsonFileName, "binding_gear_items_" + (idx + 1))
            string slotName = JsonUtil.GetStringValue(gearsData.JsonFileName, "binding_gear_slot_name_" + (idx + 1), "")
            bool enabled = true
            if (itemCount == 0 && slotName == "")
                enabled = false 
            endif
            if slotName == ""
                slotName = "Set " + (idx + 1)
            endif
            if !enabled
                slotName = ""
            endif
            actionMenu.SetPropertyIndexString("optionText", idx, slotName)
            actionMenu.SetPropertyIndexString("optionLabelText", idx, slotName)
            actionMenu.SetPropertyIndexBool("optionEnabled", idx, enabled)
            idx += 1
        endwhile

        int actionResult = actionMenu.OpenMenu()

        if actionResult >= 0 && actionResult <= bndg_BindingGearManager.GetSlotCount()
            StartGearChange(actionResult + 1)
        endif

        ; idx = 0
        ; while idx < bndg_BindingGearManager.GetSlotCount()
        ;     if actionResult == idx
        ;         changeToSlot = idx + 1
        ;         if !changingGear
        ;             changingGear = true
        ;             ;debug.MessageBox("in wheel")
        ;             ChangeGear()

        ;         endif
        ;     endif
        ;     idx += 1
        ; endwhile

        showingWheel = false
    endif

endfunction

bool changeGearWorking = false

function StartGearChange(int slot)
    changeToSlot = slot
    ChangeGear()
endfunction

Keyword heavyBondageKeyword
function ChangeGear()

    if changeGearWorking
        debug.MessageBox("already working...")
        return
    endif

    if dhlpActive
        
    endif

    if heavyBondageKeyword == none
        heavyBondageKeyword = Keyword.GetKeyword("zad_DeviousHeavyBondage")
    endif
    if thePlayer.WornHasKeyword(heavyBondageKeyword)
        debug.MessageBox("Your bound hands prevent outfit changes")
        return
    endif

    changeGearWorking = true

    ;thePlayer.SheatheWeapon()

    if thePlayer.IsWeaponDrawn()
        Input.TapKey(19)
        Utility.Wait(1.0)
    endif

    ;debug.Notification("change gear")

    bndg_BindingGearManager.WriteToConsole("change gear to set: " + changeToSlot)

    bool equip

    ;if changeToSlot != usingSlot
    bndg_BindingGearManager.WriteToConsole("OnUpdate - changing gear - changeToSlot: " + changeToSlot + " usingSLot: " + usingSlot)

    if thePlayer.WornHasKeyword(zlib.zad_DeviousHeavyBondage)

        debug.Notification("<font color='#ff0000'>Your bound hands prevent equpping set " + changeToSlot + " items.</font>")

        changeToSlot = usingSlot ;revert this back

    else

        string slotName = JsonUtil.GetStringValue(gearsData.JsonFileName, "binding_gear_slot_name_" + changeToSlot, "")
        if slotName != ""
            slotName = " (" + slotName + ")"
        endif

        debug.Notification("<font color='#ff0000'>Equipping set " + changeToSlot + slotName + " items.</font>")

        ; bool wearningDdItems = thePlayer.WornHasKeyword(zlib.zad_Lockable)
        ; bndg_BindingGearManager.WriteToConsole("wearning dd items: " + wearningDdItems)

        ;Form[] items = StorageUtil.FormListToArray(thePlayer, "binding_gear_items_" + changeToSlot)

        Form leftHandSpell = JsonUtil.GetFormValue(gearsData.JsonFileName, "binding_gear_spell_left_" + changeToSlot)
        Form rightHandSpell = JsonUtil.GetFormValue(gearsData.JsonFileName, "binding_gear_spell_right_" + changeToSlot)
        Form shoutSpell = JsonUtil.GetFormValue(gearsData.JsonFileName, "binding_gear_shout_" + changeToSlot)
        Form otherSpell = JsonUtil.GetFormValue(gearsData.JsonFileName, "binding_gear_spell_other_" + changeToSlot)

        if doNotUnequipSpells == 0
            Spell eqSpellLeft = thePlayer.GetEquippedSpell(0)
            Spell eqSpellRight = thePlayer.GetEquippedSpell(1)
            Shout eqShout = thePlayer.GetEquippedShout()
            Spell eqOtherSpell = thePlayer.GetEquippedSpell(2)

            if eqSpellLeft
                thePlayer.UnequipSpell(eqSpellLeft, 0)
            endif

            if eqSpellRight
                thePlayer.UnequipSpell(eqSpellRight, 1)
            endif

            if eqShout
                thePlayer.UnequipShout(eqShout)
            endif

            if eqOtherSpell
                thePlayer.UnequipSpell(eqOtherSpell, 2)
            endif
        endif

        if leftHandSpell
            thePlayer.EquipSpell(leftHandSpell as Spell, 0)
        endif

        if rightHandSpell
            thePlayer.EquipSpell(rightHandSpell as Spell, 1)
        endif

        if shoutSpell
            thePlayer.EquipShout(shoutSpell as Shout)
        endif

        if otherSpell
            thePlayer.EquipSpell(otherSpell as Spell, 2)
        endif

        Form[] items = JsonUtil.FormListToArray(gearsData.JsonFileName, "binding_gear_items_" + changeToSlot)

        WriteToConsole("items to add: " + items)
 
        bool playedAnimiation = false

        if items.Length > 0

            idx = 0
            while idx < items.Length
                Form item = items[idx]

                ;WriteToConsole("add test - item: " + item.GetName() + " total: " + items.Length + " idx: " + idx)

                if item != none
                    WriteToConsole("adding item: " + item)
                    if thePlayer.GetItemCount(item) > 0
                        if !thePlayer.IsEquipped(item) && item.IsPlayable()

                            if useAnimation == 1 && !playedAnimiation
                                if item.HasKeywordString("ArmorCuirass") || item.HasKeywordString("ClothingBody")
                                    Debug.SendAnimationEvent(thePlayer, "Arrok_Undress_G" + gender)
                                    playedAnimiation = true
                                endif
                            endif

                            ;StorageUtil.SetIntValue(item, "binding_gear_added_set", changeToSlot)
                            thePlayer.EquipItem(item, false, true)
                            Utility.Wait(0.05)
                        endif
                    endif
                    ; equip = true
                    ; if wearningDdItems
                    ;     if item as Armor
                    ;         int slotMask = (item as Armor).GetSlotMask() ;NOTE - need the item slot, not the mask - but inventory keyword check fixed this anyway
                    ;         Armor ddItem = thePlayer.GetEquippedArmorInSlot(slotMask)
                    ;         bndg_BindingGearManager.WriteToConsole("slot mask: " + slotMask + " item: " + item.GetName() +  " ddItem: " + ddItem)
                    ;         if ddItem
                    ;             bndg_BindingGearManager.WriteToConsole("dd item blocked slot: " + slotMask + " item: " + item.GetName())
                    ;             equip = false                            
                    ;         endif
                    ;     endif
                    ; endif
                    ; if equip
                    ;     thePlayer.EquipItem(item, false, true)
                    ; endif
                endif
                idx = idx + 1
            endwhile
        endif

        int leavesItems = JsonUtil.GetIntValue(gearsData.JsonFileName, "binding_gear_slot_leaves_items_" + changeToSlot, 0)

        if leavesItems == 0

            Form[] inventory = StorageUtil.FormListToArray(thePlayer, bndg_Data.WornItemsStorageKey())
            idx = 0
            while idx < inventory.Length
                Form item = inventory[idx]
                if item.HasKeyword(zlib.zad_Lockable) || item.HasKeyword(zlib.zad_InventoryDevice)
                    bndg_BindingGearManager.WriteToConsole(item.GetName() + " is a devious item and can't be removed")
                else

                    if !JsonUtil.FormListHas(gearsData.JsonFileName, "binding_gear_items_" + changeToSlot, item)
                        if useAnimation == 1 && !playedAnimiation
                            if item.HasKeywordString("ArmorCuirass") || item.HasKeywordString("ClothingBody")
                                Debug.SendAnimationEvent(thePlayer, "Arrok_Undress_G" + gender)
                                playedAnimiation = true
                            endif
                        endif
                        thePlayer.UnequipItem(item, false, true)
                        Utility.Wait(0.05)
                    endif

                    ; int addedBy = StorageUtil.GetIntValue(item, "binding_gear_added_set", 0)
                    ; ;ebug.MessageBox("item: " + item.GetName() + " added: " + addedBy)
                    ; if addedBy != changeToSlot
                    ;     if useAnimation == 1 && !playedAnimiation
                    ;         if item.HasKeywordString("ArmorCuirass") || item.HasKeywordString("ClothingBody")
                    ;             Debug.SendAnimationEvent(thePlayer, "Arrok_Undress_G" + gender)
                    ;             playedAnimiation = true
                    ;         endif
                    ;     endif
                    ;     thePlayer.UnequipItem(item, false, true)
                    ;     Utility.Wait(0.05)
                    ; endif
                    ; int addSet = StorageUtil.GetIntValue(item, "binding_gear_slot_" + changeToSlot, 0)
                    ; int removeSet = StorageUtil.GetIntValue(item, "binding_gear_slot_" + usingSlot, 0)
                    ; bndg_BindingGearManager.WriteToConsole("cleanup inventory - item: " + item.GetName() + " addSet: " + addSet + " removeSet: " + removeSet)
                    ; if (removeSet == 1 && addSet == 0) || (removeSet == 0 && addSet == 0)
                    ;     if !playedAnimiation && useAnimation == 1
                    ;         Debug.SendAnimationEvent(thePlayer, "Arrok_Undress_G" + gender)
                    ;         playedAnimiation = true
                    ;     endif
                    ;     thePlayer.UnequipItem(item, false, true)
                    ;     Utility.Wait(0.05)
                    ; endif
                endif

                idx += 1
            endwhile

            ;array cleanup code - this should not happen, but will keep the array not clean if it does
            inventory = StorageUtil.FormListToArray(thePlayer, bndg_Data.WornItemsStorageKey())
            idx = 0
            while idx < inventory.Length
                Form item = inventory[idx]
                if !thePlayer.IsEquipped(item)
                    StorageUtil.FormListRemove(thePlayer, bndg_Data.WornItemsStorageKey(), item)
                    ;debug.Notification("cleaning up: " + item)
                    bndg_BindingGearManager.WriteToConsole("worn items storage - cleaning up: " + item)
                endif
                idx += 1
            endwhile

            ; Form[] inventory = StorageUtil.FormListToArray(thePlayer, bndg_Data.WornItemsStorageKey())
            ; idx = 0
            ; while idx < inventory.Length
            ;     Form item = inventory[idx]
            ;     if item.HasKeyword(zlib.zad_Lockable) || item.HasKeyword(zlib.zad_InventoryDevice)
            ;         bndg_BindingGearManager.WriteToConsole(item.GetName() + " is a devious item and can't be removed")
            ;     else
            ;         int addSet = StorageUtil.GetIntValue(item, "binding_gear_slot_" + changeToSlot, 0)
            ;         int removeSet = StorageUtil.GetIntValue(item, "binding_gear_slot_" + usingSlot, 0)
            ;         bndg_BindingGearManager.WriteToConsole("cleanup inventory - item: " + item.GetName() + " addSet: " + addSet + " removeSet: " + removeSet)
            ;         if (removeSet == 1 && addSet == 0) || (removeSet == 0 && addSet == 0)
            ;             if !playedAnimiation && useAnimation == 1
            ;                 Debug.SendAnimationEvent(thePlayer, "Arrok_Undress_G" + gender)
            ;                 playedAnimiation = true
            ;             endif
            ;             thePlayer.UnequipItem(item, false, true)
            ;             Utility.Wait(0.05)
            ;         endif
            ;     endif
            ;     idx += 1
            ; endwhile


            ; Form[] inventory = thePlayer.GetContainerForms()
            ; idx = 0
            ; while idx < inventory.Length
            ;     Form item = inventory[idx]
            ;     if thePlayer.IsEquipped(item) && item.IsPlayable()
            ;         if item.HasKeyword(zlib.zad_Lockable) || item.HasKeyword(zlib.zad_InventoryDevice)
            ;             bndg_BindingGearManager.WriteToConsole(item.GetName() + " is a devious item and can't be removed")
            ;         else
            ;             int addSet = StorageUtil.GetIntValue(item, "binding_gear_slot_" + changeToSlot, 0)
            ;             int removeSet = StorageUtil.GetIntValue(item, "binding_gear_slot_" + usingSlot, 0)
            ;             bndg_BindingGearManager.WriteToConsole("cleanup inventory - item: " + item.GetName() + " addSet: " + addSet + " removeSet: " + removeSet)
            ;             if (removeSet == 1 && addSet == 0) || (removeSet == 0 && addSet == 0)
            ;                 if !playedAnimiation && useAnimation == 1
            ;                     Debug.SendAnimationEvent(thePlayer, "Arrok_Undress_G" + gender)
            ;                     playedAnimiation = true
            ;                 endif
            ;                 thePlayer.UnequipItem(item, false, true)
            ;                 Utility.Wait(0.05)
            ;             endif
            ;         endif
            ;     endif
            ;     idx += 1
            ; endwhile
        endif

        ; Form leftHandSpell = JsonUtil.GetFormValue(gearsData.JsonFileName, "binding_gear_spell_left_" + changeToSlot)
        ; Form rightHandSpell = JsonUtil.GetFormValue(gearsData.JsonFileName, "binding_gear_spell_right_" + changeToSlot)
        ; Form shoutSpell = JsonUtil.GetFormValue(gearsData.JsonFileName, "binding_gear_shout_" + changeToSlot)
        ; Form otherSpell = JsonUtil.GetFormValue(gearsData.JsonFileName, "binding_gear_spell_other_" + changeToSlot)

        ; if doNotUnequipSpells == 0
        ;     Spell eqSpellLeft = thePlayer.GetEquippedSpell(0)
        ;     Spell eqSpellRight = thePlayer.GetEquippedSpell(1)
        ;     Shout eqShout = thePlayer.GetEquippedShout()
        ;     Spell eqOtherSpell = thePlayer.GetEquippedSpell(2)

        ;     if eqSpellLeft
        ;         thePlayer.UnequipSpell(eqSpellLeft, 0)
        ;     endif

        ;     if eqSpellRight
        ;         thePlayer.UnequipSpell(eqSpellRight, 1)
        ;     endif

        ;     if eqShout
        ;         thePlayer.UnequipShout(eqShout)
        ;     endif

        ;     if eqOtherSpell
        ;         thePlayer.UnequipSpell(eqOtherSpell, 2)
        ;     endif
        ; endif

        ; if leftHandSpell
        ;     thePlayer.EquipSpell(leftHandSpell as Spell, 0)
        ; endif

        ; if rightHandSpell
        ;     thePlayer.EquipSpell(rightHandSpell as Spell, 1)
        ; endif

        ; if shoutSpell
        ;     thePlayer.EquipShout(shoutSpell as Shout)
        ; endif

        ; if otherSpell
        ;     thePlayer.EquipSpell(otherSpell as Spell, 2)
        ; endif

        usingSlot = changeToSlot

    endif

    changingGear = false

    changeGearWorking = false

    ;endif

endfunction

event OnDhlpSuspend(string eventName, string strArg, float numArg, Form sender)
    bndg_BindingGearManager.WriteToConsole("OnDhlpSuspend sender: " + sender.GetName() + " id: " + sender.GetFormID())
    GoToState("DhlpState")
    dhlpActive = true
endevent

event OnDhlpResume(string eventName, string strArg, float numArg, Form sender)
    bndg_BindingGearManager.WriteToConsole("OnDhlpResume sender: " + sender.GetName() + " id: " + sender.GetFormID())
    GoToState("")
    dhlpActive = false
endevent

bool Function SafeProcess()
    ;this code provided by IsharaMeradin on nexus
	If (!Utility.IsInMenuMode()) \
	&& (!UI.IsMenuOpen("Dialogue Menu")) \
	&& (!UI.IsMenuOpen("Console")) \
	&& (!UI.IsMenuOpen("Crafting Menu")) \
	&& (!UI.IsMenuOpen("MessageBoxMenu")) \
	&& (!UI.IsMenuOpen("ContainerMenu")) \
	&& (!UI.IsTextInputEnabled())
		;IsInMenuMode to block when game is paused with menus open
		;Dialogue Menu check to block when dialog is open
		;Console check to block when console is open - console does not trigger IsInMenuMode and thus needs its own check
		;Crafting Menu check to block when crafting menus are open - game is not paused so IsInMenuMode does not work
		;MessageBoxMenu check to block when message boxes are open - while they pause the game, they do not trigger IsInMenuMode
		;ContainerMenu check to block when containers are accessed - while they pause the game, they do not trigger IsInMenuMode
		;IsTextInputEnabled check to block when editable text fields are open
		Return True
	Else
		Return False
	EndIf
EndFunction

zadLibs property zlib auto

bndg_Data property gearsData auto