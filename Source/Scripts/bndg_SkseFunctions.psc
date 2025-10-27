Scriptname bndg_SkseFunctions hidden

function SetGameUid(int uid) global native
function LearnHotKey(int slot, int keyCode, int modifier) global native
int function GetHotkey(int slot) global native
int function GetModifier(int slot) global native
function LearnWornGear(int slot) global native
Form[] function GetSetItems(int slot) global native
Form[] function GetWornGear() global native
function AddSetItem(int slot, Form item) global native
function RemoveSetItem(int slot, Form item) global native
function SetSetName(int slot, string setName) global native
string function GetSetName(int slot) global native
function LearnShout(int slot, Shout selectedShout) global native
function LearnSpell(int slot, int spellSlot, Spell selectedSpell) global native
function ClearShout(int slot) global native
function ClearSpell(int slot, int spellSlot) global native
Shout function GetShout(int slot) global native
Spell function GetSpell(int slot, int spellSlot) global native
;function Dress(int slot) global native
int function GetSetLeavesItems(int slot) global native
function ToggleSetLeavesItems(int slot, bool leavesItems) global native
int function GetShowAnimations() global native
function ToggleAnimations(int toggleOn) global native
function LearnWeapon(int slot, bool mainHand) global native
function LearnAmmo(int slot) global native
Form function GetWeapon(int slot, bool mainHand) global native
Form function GetAmmo(int slot) global native
function ClearWeapon(int slot, bool mainHand) global native
function ClearAmmo(int slot) global native

function DressActorWithItems(Actor act, Form[] items, Form leftHand, Form rightHand, Form ammo, Form voice, bool leavesItems) global native
Form function GetEquippedLeftHand() global native
Form function GetEquippedRightHand() global native
Form function GetEquippedAmmo() global native
Form function GetEquippedVoice() global native
function SetHotkey(int slot, int keycode, int modifier) global native
function SetShowAnimations(int value) global native ;0 - off, 1 - on
int function IsTwoHanded(Weapon item) global native ;takes a weapon

int function DisplayWheelMenuBridge() global ;int[] slots, string[] setNames) global
    bndg_BindingGearManager gear = Quest.GetQuest("bndg_BindingGearManagerQuest") as bndg_BindingGearManager
    ;debug.MessageBox(setNames)
    gear.ShowWheelMenu() ;(slots, setNames)
    return 0
endfunction

int function EquipSetBridge(int slot) global
    ;debug.MessageBox("slot: " + slot)
    bndg_BindingGearManager gear = Quest.GetQuest("bndg_BindingGearManagerQuest") as bndg_BindingGearManager
    gear.EquipSet(slot)
    return 0
endfunction