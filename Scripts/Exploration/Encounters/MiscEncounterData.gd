class_name MiscEncounterData extends EncounterData
## Base for every "Misc" encounter (Treasure and Catastrophe both live
## here now that they share one Mode). Each specific encounter is its
## own tiny script extending this one — override apply() with whatever
## self-contained effect it has. Keep apply() self-contained: read/write
## RunState directly, don't reach into UI. MiscMode's script calls
## apply() once, then shows description/splash_art and a continue button.
 
func apply() -> void:
	push_warning("MiscEncounterData.apply() not overridden for '%s'" % encounter_name)
 
