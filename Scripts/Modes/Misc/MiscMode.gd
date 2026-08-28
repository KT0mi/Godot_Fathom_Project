extends Control


func _ready() -> void:
	var encounter := RunState.current_encounter as MiscEncounterData
	if encounter == null:
		push_error("MiscMode: RunState.current_encounter is not a MiscEncounterData")
		return
 
	encounter.apply()
	# TODO: show encounter.splash_art / encounter.description / encounter.encounter_name
 
 
func _on_continue() -> void:
	EventBus.encounter_resolved.emit(RunState.current_encounter)
	RunState.current_encounter = null
	GameFlow.goto_mode(GameFlow.Mode.EXPLORATION)
 
