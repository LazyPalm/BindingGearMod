Scriptname bndg_ThePlayerAlias extends ReferenceAlias  

Actor thePlayer

event OnInit()
    thePlayer = Game.GetPlayer()
endevent

event OnPlayerLoadGame()
    thePlayer = Game.GetPlayer()
    main.GameLoaded()

endevent

event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)

    if akBaseObject.IsPlayable()
        StorageUtil.FormListAdd(thePlayer, bndg_Data.WornItemsStorageKey(), akBaseObject, true)
        bndg_BindingGearManager.WriteToConsole("gear_worn_items on equip count: " + StorageUtil.FormListCount(thePlayer, "gear_worn_items"))
    endif

endevent

event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)

    if akBaseObject.IsPlayable()
        StorageUtil.FormListRemove(thePlayer, bndg_Data.WornItemsStorageKey(), akBaseObject, false)
        bndg_BindingGearManager.WriteToConsole("gear_worn_items on remove count: " + StorageUtil.FormListCount(thePlayer, "gear_worn_items"))
    endif

endevent

bndg_BindingGearManager property main auto