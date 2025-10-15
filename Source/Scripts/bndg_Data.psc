Scriptname bndg_Data extends Quest conditional

int property GameId auto conditional

function GameLoaded()

    if GameId == 0
        GameId = Utility.RandomInt(100000, 999999)
    endif

	bndg_SkseFunctions.SetGameUid(GameId)

endfunction