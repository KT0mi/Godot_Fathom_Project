class_name MapNode
extends RefCounted
 
var id: String
var layer: int
var travel_time: float = 1.0  # in days, before submarine modifiers apply
## IDs of MapNodes in the next layer this node can lead to. Populated by
## ExplorationMap.generate() — a node with no connections is the end
## of a branch (or the final layer).
var connections: Array[String] = [] 

var encounter : EncounterData

func get_encounter_type() -> EncounterData.Type:
	if encounter == null:
		push_warning("MapNode %s has no encounter assigned" % id)
		return EncounterData.Type.TREASURE
	return encounter.type
