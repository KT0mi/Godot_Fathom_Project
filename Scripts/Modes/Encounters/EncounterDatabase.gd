extends Node
##Autoload
##
## Scans the folders below at startup and pools every EncounterData
## (.gd) found by type.
 
const ENCOUNTER_DIRS := {
	EncounterData.Type.CREATURE: "res://Resources/Encounters/Creature/",
	EncounterData.Type.TREASURE: "res://Resources/Encounters/Treasure/",
	EncounterData.Type.CATASTROPHE: "res://Resources/Encounters/Catastrophe/",
	EncounterData.Type.SHOP: "res://Resources/Encounters/Shop/",
}
 
var _pools: Dictionary = {}  # EncounterData.Type -> Array[EncounterData]
 
 
func _ready() -> void:
	for type in ENCOUNTER_DIRS.keys():
		_pools[type] = _load_all(ENCOUNTER_DIRS[type])
 
 
func _load_all(dir_path: String) -> Array[EncounterData]:
	var out: Array[EncounterData] = []
	var dir := DirAccess.open(dir_path)
	if dir == null:
		push_warning("EncounterDatabase: folder not found: %s" % dir_path)
		return out
 
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if file_name.ends_with(".gd"):
			var res := load(dir_path + file_name)
			if res is EncounterData:
				out.append(res)
				print("DIAGONOSTIC: Appended %s to encounter database." % (dir_path + file_name))
			else:
				push_warning("EncounterDatabase: %s is not an EncounterData" % file_name)
		file_name = dir.get_next()
	dir.list_dir_end()
 
	return out
 
 
## Signature matches Callable expectations for ExplorationMap.generate() —
## pass EncounterDatabase.get_random_encounter directly as the resolver.
func get_random_encounter(type: EncounterData.Type) -> EncounterData:
	if not _pools.has(type) or _pools[type].is_empty():
		push_warning("EncounterDatabase: no encounters registered for type %s" % EncounterData.Type.keys()[type])
		return null
	var pool: Array[EncounterData] = _pools[type]
	return pool[randi() % pool.size()]
