extends Node
##Autoload
##
##Swaps the active mode scene into a container scene that is registered on startup

enum Mode {NONE, EXPLORATION, COMBAT, SHOP, MISC}

var current_mode : Mode = Mode.NONE
var mode_container : Node = null

var mode_scene_paths := {
	Mode.EXPLORATION : "res://Scenes/ModeScenes/ExplorationMode.tscn",
	Mode.COMBAT : "",
	Mode.SHOP : "",
	Mode.MISC : "res://Scenes/ModeScenes/MiscMode.tscn",
}

## Which Mode handles a given encounter type. Lives here rather than in
## ExplorationMode since GameFlow already owns the Mode enum — anywhere
## that has an EncounterData.Type and needs a Mode should ask here.
const ENCOUNTER_TYPE_TO_MODE := {
	EncounterData.Type.CREATURE: Mode.COMBAT,
	EncounterData.Type.TREASURE: Mode.MISC,
	EncounterData.Type.CATASTROPHE: Mode.MISC,
	EncounterData.Type.SHOP: Mode.SHOP,
}

func mode_for_encounter_type(type: EncounterData.Type) -> Mode:
	return ENCOUNTER_TYPE_TO_MODE.get(type, Mode.EXPLORATION)

func register_container(container: Node) -> void:
	mode_container = container

func goto_mode(mode: Mode) -> void:
	if mode_container == null:
		push_error("GameFlow: mode_container not registered — did Main.tscn call register_container()?")
		return
 
	for child in mode_container.get_children():
		child.queue_free()
 
	current_mode = mode
 
	if not mode_scene_paths.has(mode) or mode_scene_paths[mode] == "":
		push_warning("GameFlow: no scene registered yet for mode %s" % Mode.keys()[mode])
		return
 
	var scene: PackedScene = load(mode_scene_paths[mode])
	var instance := scene.instantiate()
	mode_container.add_child(instance)
