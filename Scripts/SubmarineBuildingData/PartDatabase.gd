# Scripts/SubmarineBuildingData/PartDatabase.gd
extends Node
## Autoload

const PARTS_DIR := "res://Resources/Parts/"

var all_parts: Array[PartData] = []

func _ready() -> void:
	_load_all()

func _load_all() -> void:
	all_parts.clear()
	var dir := DirAccess.open(PARTS_DIR)
	if dir == null:
		push_error("PartDatabase: couldn't open %s" % PARTS_DIR)
		return
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".tres"):
			var res := load(PARTS_DIR + file_name)
			if res is PartData:
				print("DIAGONOSTIC: Added new part %s to part database." % (PARTS_DIR + file_name))
				all_parts.append(res)
			else:
				push_warning("PartDatabase: %s is not a PartData" % file_name)
		file_name = dir.get_next()
	dir.list_dir_end()

func get_all() -> Array[PartData]:
	return all_parts
