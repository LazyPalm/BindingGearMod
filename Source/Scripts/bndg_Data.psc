Scriptname bndg_Data extends Quest conditional

int property GameId auto conditional
string property JsonFileName auto conditional

int[] slotMaskArray
string[] slotNameArray
int[] slotProtectionArray
string[] slotFriendlyName

int[] function GetSlotMasks()
    return slotMaskArray
endfunction

string function WornItemsStorageKey() global
    return "gear_worn_items"
endfunction

function GameLoaded()

    if GameId == 0
        GameId = Utility.RandomInt(100000, 999999)
        JsonFileName = "binding_gear_" + GameId + ".json"
    endif

	if slotNameArray.Length != 27
		slotNameArray = new string[27]
		slotNameArray[0] = "kSlotMaskHead"
		slotNameArray[1] = "kSlotMaskHair"
		slotNameArray[2] = "kSlotMaskBody"
		slotNameArray[3] = "kSlotMaskHands"
		slotNameArray[4] = "kSlotMaskForearms"
		slotNameArray[5] = "kSlotMaskAmulet"
		slotNameArray[6] = "kSlotMaskRing"
		slotNameArray[7] = "kSlotMaskFeet"
		slotNameArray[8] = "kSlotMaskCalves"
		slotNameArray[9] = "kSlotMaskShield"
		slotNameArray[10] = "kSlotMaskTail"
		slotNameArray[11] = "kSlotMaskLongHair"
		slotNameArray[12] = "kSlotMaskCirclet"
		slotNameArray[13] = "kSlotMaskEars"
		slotNameArray[14] = "kSlotMaskFaceMouth"
		slotNameArray[15] = "kSlotMaskNeck"
		slotNameArray[16] = "kSlotMaskChestPrimary"
		slotNameArray[17] = "kSlotMaskBack"
		slotNameArray[18] = "kSlotMaskPelvisPrimary"
		slotNameArray[19] = "kSlotMaskPelvisSecondary"
		slotNameArray[20] = "kSlotMaskLegPrimary"
		slotNameArray[21] = "kSlotMaskLegSecondary"
		slotNameArray[22] = "kSlotMaskJewelry"
		slotNameArray[23] = "kSlotMaskChestSecondary"
		slotNameArray[24] = "kSlotMaskShoulder"
		slotNameArray[25] = "kSlotMaskArmSecondary"
		slotNameArray[26] = "kSlotMaskArmPrimary"
	endif

	if slotMaskArray.Length != 27
		slotMaskArray = new int[27]
		slotMaskArray[0] = 0x00000001  ;30
		slotMaskArray[1] = 0x00000002  ;31
		slotMaskArray[2] = 0x00000004  ;32
		slotMaskArray[3] = 0x00000008  ;33
		slotMaskArray[4] = 0x00000010  ;34
		slotMaskArray[5] = 0x00000020  ;35
		slotMaskArray[6] = 0x00000040  ;36
		slotMaskArray[7] = 0x00000080  ;37
		slotMaskArray[8] = 0x00000100  ;38
		slotMaskArray[9] = 0x00000200  ;SHIELD
		slotMaskArray[10] = 0x00000400  ;TAIL
		slotMaskArray[11] = 0x00000800  ;LongHair
		slotMaskArray[12] = 0x00001000  ;42
		slotMaskArray[13] = 0x00002000  ;43
		slotMaskArray[14] = 0x00004000 ;44
		slotMaskArray[15] = 0x00008000 ;45
		slotMaskArray[16] = 0x00010000 ;46
		slotMaskArray[17] = 0x00020000 ;47
		slotMaskArray[18] = 0x00080000 ;49
		slotMaskArray[19] = 0x00400000 ;52
		slotMaskArray[20] = 0x00800000 ;53
		slotMaskArray[21] = 0x01000000 ;54
		slotMaskArray[22] = 0x02000000 ;55
		slotMaskArray[23] = 0x04000000 ;56
		slotMaskArray[24] = 0x08000000 ;57
		slotMaskArray[25] = 0x10000000 ;58
		slotMaskArray[26] = 0x20000000 ;59
	endif

	if slotFriendlyName.Length != 27
		slotFriendlyName = new string[27]
		slotFriendlyName[0] = "Slot Mask Head - 30"
		slotFriendlyName[1] = "Slot Mask Hair - 31"
		slotFriendlyName[2] = "Slot Mask Body - 32"
		slotFriendlyName[3] = "Slot Mask Hands - 33"
		slotFriendlyName[4] = "Slot Mask Forearms - 34"
		slotFriendlyName[5] = "Slot Mask Amulet - 35"
		slotFriendlyName[6] = "Slot Mask Ring - 36"
		slotFriendlyName[7] = "Slot Mask Feet - 37"
		slotFriendlyName[8] = "Slot Mask Calves - 38"
		slotFriendlyName[9] = "Slot Mask Shield - 39"
		slotFriendlyName[10] = "Slot Mask Tail - 40"
		slotFriendlyName[11] = "Slot Mask Long Hair - 41"
		slotFriendlyName[12] = "Slot Mask Circlet - 42"
		slotFriendlyName[13] = "Slot Mask Ears - 43"
		slotFriendlyName[14] = "Slot Mask Face Mouth - 44"
		slotFriendlyName[15] = "Slot Mask Neck - 45"
		slotFriendlyName[16] = "Slot Mask Chest Primary - 46"
		slotFriendlyName[17] = "Slot Mask Back - 47"
		slotFriendlyName[18] = "Slot Mask Pelvis Primary - 49"
		slotFriendlyName[19] = "Slot Mask Pelvis Secondary - 52"
		slotFriendlyName[20] = "Slot Mask Leg Primary - 53"
		slotFriendlyName[21] = "Slot Mask Leg Secondary - 54"
		slotFriendlyName[22] = "Slot Mask Jewelry - 55"
		slotFriendlyName[23] = "Slot Mask Chest Secondary - 56"
		slotFriendlyName[24] = "Slot Mask Shoulder - 57"
		slotFriendlyName[25] = "Slot Mask Arm Secondary - 58"
		slotFriendlyName[26] = "Slot Mask Arm Primary - 59"
	endif

endfunction