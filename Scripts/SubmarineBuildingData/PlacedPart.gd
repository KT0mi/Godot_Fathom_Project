class_name PlacedPart extends RefCounted
#Placed Part is a data structure that refers to the cells that the part occupies,
#if it has valid connectors, etc. to be referenced directly by the submarine
#data and used by the ui to check if a cell is valid, etc.

var data: PartData
var origin: Vector2i
var rot_steps: int = 0 #0-3 90º degree steps

func _init(p_data: PartData = null, p_origin: Vector2i = Vector2i.ZERO, p_rot_steps: int = 0) -> void:
	data = p_data
	origin = p_origin
	rot_steps = ((p_rot_steps % 4) + 4) % 4

## Every grid cell this part occupies, in WORLD/grid space —
## rotated, then offset by this instance's origin.
func occupied_cells() -> Array[Vector2i]:
	var out: Array[Vector2i] = []
	for c in data.footprint:
		out.append(origin + _rotate(c, rot_steps))
	return out

##Returns every connector of this part in world/grid space,
##Returns {"cell":Vector2i, "dir":Vector2i}
## "cell" is the grid cell the port sits on.
## "dir" is the world-space direction that port faces (still a unit vector).
func world_space_connectors() -> Array[Dictionary]:
	var out: Array[Dictionary] = []
	for conn in data.connectors:
		var world_cell := origin + _rotate(conn.cell, rot_steps)
		var world_dir := _rotate(conn.direction, rot_steps)
		out.append({"cell":world_cell, "dir": world_dir})
	return out

func _rotate(cell: Vector2i, rotation_steps: int) -> Vector2i:
	var result := cell
	var n := ((rotation_steps % 4) + 4) % 4
	for i in n:
		result = Vector2i(-result.y, result.x)
	return result
