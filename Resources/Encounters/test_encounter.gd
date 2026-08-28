extends MiscEncounterData

func  _init() -> void:
	encounter_name = "Test Encounter"
	type = EncounterData.Type.TREASURE
	description = "Test Encounter for debugging"
	
func apply() -> void:
	print("Resolved encounter!")
	EventBus.encounter_resolved.emit(self, {})
