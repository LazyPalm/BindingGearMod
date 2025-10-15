Scriptname bndg_BindingGearManager extends Quest  

Actor thePlayer

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

function ShowWheelMenu(int[] slots, string[] setNames)

    int idx

    if !showingWheel
        showingWheel = true

        bndg_BindingGearManager.WriteToConsole("Displaying wheel menu")

        UIWheelMenu actionMenu = UIExtensions.GetMenu("UIWheelMenu") as UIWheelMenu
        idx = 0
        while idx < slots.Length ; bndg_BindingGearManager.GetSlotCount()
            string name = setNames[idx]
            if name == ""
                name = "Set " + slots[idx]
            endif
            actionMenu.SetPropertyIndexString("optionText", slots[idx] - 1, name)
            actionMenu.SetPropertyIndexString("optionLabelText", slots[idx] - 1, name)
            actionMenu.SetPropertyIndexBool("optionEnabled", slots[idx] - 1, true)
            idx += 1
        endwhile

        int actionResult = actionMenu.OpenMenu()

        if actionResult >= 0 && actionResult <= bndg_BindingGearManager.GetSlotCount()
            bndg_SkseFunctions.Dress(slots[actionResult])
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