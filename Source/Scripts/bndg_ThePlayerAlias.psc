Scriptname bndg_ThePlayerAlias extends ReferenceAlias  

event OnInit()

endevent

event OnPlayerLoadGame()
    main.GameLoaded()

endevent

bndg_BindingGearManager property main auto