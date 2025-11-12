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

    thePlayer = Game.GetPlayer()

    RegisterForModEvent("dhlp-Suspend", "OnDhlpSuspend")
    RegisterForModEvent("dhlp-Resume", "OnDhlpResume") 

    GameLoaded()

endevent

function GameLoaded()
    gender = thePlayer.GetLeveledActorBase().GetSex()
    gearsData.GameLoaded()

    int i = 0
    while i < 9
        bndg_SkseFunctions.SetHotkey(i, StorageUtil.GetIntValue(thePlayer, gearsData.STORAGE_KEY_KEYCODE + i), StorageUtil.GetIntValue(thePlayer, gearsData.STORAGE_KEY_MODIFIER + i))
        i += 1
    endwhile

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

endstate

bool showingWheel = false

function EquipSet(int slot) 

    int s = slot ; + 1

    Form[] items = StorageUtil.FormListToArray(thePlayer, gearsData.STORAGE_KEY_GEAR + s)
    Form storedLeftHand = StorageUtil.GetFormValue(thePlayer, gearsData.STORAGE_KEY_LEFT_HAND + s)
    Form storedRightHand = StorageUtil.GetFormValue(thePlayer, gearsData.STORAGE_KEY_RIGHT_HAND + s)
    Form storedAmmo = StorageUtil.GetFormValue(thePlayer, gearsData.STORAGE_KEY_AMMO + s)
    Form storedVoice = StorageUtil.GetFormValue(thePlayer, gearsData.STORAGE_KEY_VOICE + s)
    int storedLeaves = StorageUtil.GetIntValue(thePlayer, gearsData.STORAGE_KEY_LEAVES_ITEMS + s)

    ;debug.MessageBox(storedLeaves)

    Debug.Notification("Equipping outfit " + StorageUtil.GetStringValue(thePlayer, gearsData.STORAGE_KEY_SET_NAME + s, "" + s))

    bndg_SkseFunctions.DressActorWithItems(thePlayer, items, storedLeftHand, storedRightHand, storedAmmo, storedVoice, (storedLeaves == 1));

endfunction

function ShowWheelMenu() ;int[] slots, string[] setNames)

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

bndg_Data property gearsData auto