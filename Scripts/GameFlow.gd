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
	Mode.MISC : "",
}

func register_container(container: Node) -> void:
	mode_container = container

func goto_mode(mode: Mode) -> void:
	if mode_container == null:
		push_error("GameFlow: mode_container not registered — did Main.tscn call register_container()?")
		return
 
	for child in mode_container.get_children():
		child.queue_free()
 
	current_mode = mode
 
	if not mode_scene_paths.has(mode):
		push_warning("GameFlow: no scene registered yet for mode %s" % Mode.keys()[mode])
		return
 
	var scene: PackedScene = load(mode_scene_paths[mode])
	var instance := scene.instantiate()
	mode_container.add_child(instance)
