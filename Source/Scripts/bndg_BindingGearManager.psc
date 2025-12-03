Scriptname bndg_BindingGearManager extends Quest  

Actor thePlayer

;testing?

bool dhlpActive

int gender

int keyCodeLeftControl = 29
int keyCodeRightControl = 157
int keyCodeLeftAlt = 56
int keyCodeRightAlt = 184
int keyCodeLeftShift = 42
int keyCodeRightShift = 54

event OnInit()

    if self.IsRunning()
        GameLoaded()
    endif

endevent

function GameLoaded()

    debug.Notification("Binding Gears loading...")

    thePlayer = Game.GetPlayer()

    if !thePlayer.HasSpell(bndg_WheelMenuSpell)
        thePlayer.AddSpell(bndg_WheelMenuSpell)
    endif

    RegisterForModEvent("dhlp-Suspend", "OnDhlpSuspend")
    RegisterForModEvent("dhlp-Resume", "OnDhlpResume") 

    gender = thePlayer.GetLeveledActorBase().GetSex()
    gearsData.GameLoaded()

    int i = 0
    while i < 9
        bndg_SkseFunctions.SetHotkey(i, StorageUtil.GetIntValue(thePlayer, gearsData.STORAGE_KEY_KEYCODE + i), StorageUtil.GetIntValue(thePlayer, gearsData.STORAGE_KEY_MODIFIER + i))
        i += 1
    endwhile

    bndg_SkseFunctions.ToggleAnimations(StorageUtil.GetIntValue(thePlayer, gearsData.STORAGE_KEY_ANIMATIONS, 0))

endfunction

int function GetSlotCount() global
    return 8
endfunction

function PlayDressAnimation()
    Debug.SendAnimationEvent(thePlayer, "Arrok_Undress_G" + gender)
endfunction

function WriteToConsole(string msg) global
    MiscUtil.PrintConsole("[BNDG]: " + msg)
    Debug.Trace("[BNDG]: " + msg)
endfunction

state DhlpState

    function EquipSet(int slot) 
        MiscUtil.PrintConsole("[BNDG]: EquipSet blocked due to DHLP active")
    endfunction
    
    function ShowWheelMenu()
        MiscUtil.PrintConsole("[BNDG]: ShowWheelMenu blocked due to DHLP active")
    endfunction

endstate

state ModIsBusy

    function EquipSet(int slot) 
        MiscUtil.PrintConsole("[BNDG]: EquipSet blocked due to ModIsBusy active")
    endfunction
    
    function ShowWheelMenu()
        MiscUtil.PrintConsole("[BNDG]: ShowWheelMenu blocked due to ModIsBusy active")
    endfunction

endstate

bool showingWheel = false

function EquipSet(int slot) 

    if !SafeProcess()
        MiscUtil.PrintConsole("[BNDG]: EquipSet blocked due to UI open")
        return
    endif

    GoToState("ModIsBusy")

    ;debug.MessageBox("in EquipSet???")

    int s = slot ; + 1

    Form[] items = StorageUtil.FormListToArray(thePlayer, gearsData.STORAGE_KEY_GEAR + s)
    Form storedLeftHand = StorageUtil.GetFormValue(thePlayer, gearsData.STORAGE_KEY_LEFT_HAND + s)
    Form storedRightHand = StorageUtil.GetFormValue(thePlayer, gearsData.STORAGE_KEY_RIGHT_HAND + s)
    Form storedAmmo = StorageUtil.GetFormValue(thePlayer, gearsData.STORAGE_KEY_AMMO + s)
    Form storedVoice = StorageUtil.GetFormValue(thePlayer, gearsData.STORAGE_KEY_VOICE + s)
    int storedLeaves = StorageUtil.GetIntValue(thePlayer, gearsData.STORAGE_KEY_LEAVES_ITEMS + s)

    ;debug.MessageBox(items)

    Debug.Notification("Equipping outfit " + StorageUtil.GetStringValue(thePlayer, gearsData.STORAGE_KEY_SET_NAME + s, "" + s))

    bndg_SkseFunctions.DressActorWithItems(thePlayer, items, storedLeftHand, storedRightHand, storedAmmo, storedVoice, (storedLeaves == 1));

    ;Utility.Wait(10.0)

    GoToState("")

endfunction

function ShowWheelMenu() ;int[] slots, string[] setNames)

    if !SafeProcess()
        MiscUtil.PrintConsole("[BNDG]: ShowWheelMenu blocked due to UI open")
        return
    endif

    GoToState("ModIsBusy")

    ;debug.MessageBox("show wheel??")

    int idx

    if !showingWheel
        showingWheel = true

        bndg_BindingGearManager.WriteToConsole("Displaying wheel menu")

        UIWheelMenu actionMenu = UIExtensions.GetMenu("UIWheelMenu") as UIWheelMenu
        idx = 0
        while idx < gearsData.SLOT_COUNT ;slots.Length ; bndg_BindingGearManager.GetSlotCount()
            string name = StorageUtil.GetStringValue(thePlayer, gearsData.STORAGE_KEY_SET_NAME + (idx + 1), "inactive") ;setNames[idx]
            ; if name == ""
            ;     name = "Set " + slots[idx]
            ; endif
            if name == "inactive"

            else
                actionMenu.SetPropertyIndexString("optionText", idx, name)
                actionMenu.SetPropertyIndexString("optionLabelText", idx, name)
                actionMenu.SetPropertyIndexBool("optionEnabled", idx, true)
            endif
            idx += 1
        endwhile

        int actionResult = actionMenu.OpenMenu()

        if actionResult >= 0 && actionResult <= bndg_BindingGearManager.GetSlotCount()

            int s = actionResult + 1       

            Form[] items = StorageUtil.FormListToArray(thePlayer, gearsData.STORAGE_KEY_GEAR + s)
            Form storedLeftHand = StorageUtil.GetFormValue(thePlayer, gearsData.STORAGE_KEY_LEFT_HAND + s)
            Form storedRightHand = StorageUtil.GetFormValue(thePlayer, gearsData.STORAGE_KEY_RIGHT_HAND + s)
            Form storedAmmo = StorageUtil.GetFormValue(thePlayer, gearsData.STORAGE_KEY_AMMO + s)
            Form storedVoice = StorageUtil.GetFormValue(thePlayer, gearsData.STORAGE_KEY_VOICE + s)
            int storedLeaves = StorageUtil.GetIntValue(thePlayer, gearsData.STORAGE_KEY_LEAVES_ITEMS + s)

            Debug.Notification("Equipping outfit " + StorageUtil.GetStringValue(thePlayer, gearsData.STORAGE_KEY_SET_NAME + s, "" + s))
            ;debug.MessageBox(items);

            bndg_SkseFunctions.DressActorWithItems(thePlayer, items, storedLeftHand, storedRightHand, storedAmmo, storedVoice, (storedLeaves == 1));
            ;bndg_SkseFunctions.Dress(slots[actionResult])

        endif

        showingWheel = false
    endif

    GoToState("")

endfunction

event OnDhlpSuspend(string eventName, string strArg, float numArg, Form sender)
    bndg_BindingGearManager.WriteToConsole("OnDhlpSuspend sender: " + sender.GetName() + " id: " + sender.GetFormID())
    int dhlpFlag = StorageUtil.GetIntValue(thePlayer, gearsData.STORAGE_KEY_DHLP_BLOCKED, 0)
    if dhlpFlag == 1
        GoToState("DhlpState")
    endif
    dhlpActive = true
endevent

event OnDhlpResume(string eventName, string strArg, float numArg, Form sender)
    bndg_BindingGearManager.WriteToConsole("OnDhlpResume sender: " + sender.GetName() + " id: " + sender.GetFormID())
    GoToState("")
    dhlpActive = false
endevent

bool function GetDhlpActive()
    return dhlpActive
endfunction

function ClearDhlpActive()
    dhlpActive = false
endfunction

Bool function SafeProcess()
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
endfunction

bndg_Data property gearsData auto

Spell property bndg_WheelMenuSpell auto