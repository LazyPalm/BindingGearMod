Scriptname bndg_WheelMenuMagicEffectScript extends activemagiceffect  

event OnEffectStart(Actor akTarget, Actor akCaster)
    bndg_BindingGearManager gear = Quest.GetQuest("bndg_BindingGearManagerQuest") as bndg_BindingGearManager
    gear.ShowWheelMenu()
endevent