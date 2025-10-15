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

    ;debug.MessageBox(akReference)

    ; if akBaseObject.IsPlayable()
    ;     ;debug.MessageBox(StorageUtil.GetIntValue(akBaseObject, "gear_guid", 0))
    ;     StorageUtil.FormListAdd(thePlayer, bndg_Data.WornItemsStorageKey(), akBaseObject, true)
    ;     bndg_BindingGearManager.WriteToConsole("gear_worn_items on equip count: " + StorageUtil.FormListCount(thePlayer, "gear_worn_items"))
    ; endif

endevent

event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)

    ; if akBaseObject.IsPlayable()
    ;     StorageUtil.FormListRemove(thePlayer, bndg_Data.WornItemsStorageKey(), akBaseObject, false)
    ;     bndg_BindingGearManager.WriteToConsole("gear_worn_items on remove count: " + StorageUtil.FormListCount(thePlayer, "gear_worn_items"))
    ; endif

endevent

event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)

    ; if StorageUtil.GetIntValue(akBaseItem, "gear_guid", 0) == 0
    ;     StorageUtil.SetIntValue(akBaseItem, "gear_guid", Utility.RandomInt(1, 9999999))
    ; endif

endevent

event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)

    ;debug.MessageBox("akItemReference: " + akItemReference)

endevent

bndg_BindingGearManager property main auto