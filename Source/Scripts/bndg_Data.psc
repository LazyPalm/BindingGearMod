Scriptname bndg_Data extends Quest conditional

int property GameId auto conditional

string property STORAGE_KEY_GEAR = "gear_set_" autoReadOnly
string property STORAGE_KEY_LEFT_HAND = "gear_left_" autoReadOnly
string property STORAGE_KEY_RIGHT_HAND = "gear_right_" autoReadOnly
string property STORAGE_KEY_AMMO = "gear_ammo_" autoReadOnly
string property STORAGE_KEY_VOICE = "gear_voice_" autoReadOnly
string property STORAGE_KEY_SET_NAME = "gear_name_" autoReadOnly
string property STORAGE_KEY_LEAVES_ITEMS = "gear_leaves_" autoReadOnly
string property STORAGE_KEY_ACTIVE = "gear_active_" autoReadOnly

string property STORAGE_KEY_KEYCODE = "gear_key_" autoReadOnly 
string property STORAGE_KEY_MODIFIER = "gear_mod_" autoReadOnly

string property STORAGE_KEY_ANIMATIONS = "gear_anmiations" autoReadOnly
string property STORAGE_KEY_DHLP_BLOCKED = "gear_dhlp" autoReadOnly

int property SLOT_COUNT = 8 autoReadOnly

function GameLoaded()

    if GameId == 0
        GameId = Utility.RandomInt(100000, 999999)
    endif

	bndg_SkseFunctions.SetGameUid(GameId)

endfunction

; Form[] function GetGear(Actor act, int set)

; endfunction