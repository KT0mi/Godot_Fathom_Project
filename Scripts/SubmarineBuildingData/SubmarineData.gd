class_name SubmarineData extends RefCounted

var cells: Dictionary = {} #Vector2i -> PlacedPart
var parts: Array[PlacedPart] = []

func can_place(part: PlacedPart) -> bool:
	var occupied := part.occupied_cells()
	
	for c in occupied:
		if cells.has(c):
			return false
	
	#Might need to think better on this
	if parts.is_empty():
		return true
	
	for conn in part.world_space_connectors():
		var neighbor_cell:Vector2i= conn.cell + conn.dir
		if not cells.has(neighbor_cell):
			continue
		var neighbor: PlacedPart = cells[neighbor_cell]
		for n_conn in neighbor.world_space_connectors():
			if n_conn.cell == neighbor_cell and n_conn.dir == -conn.dir:
				return true #Found matching connector
	
	return false

##Add part to the world grid
func place(part: PlacedPart) -> void:
	for c in part.occupied_cells():
		cells[c] = part
	parts.append(part)

func compute_stats() -> Dictionary:
	var total_weight := 0.0
	var weighted_pos := Vector2.ZERO
	var total_thickness := 0.0
	
	for part in parts:
		total_weight += part.data.weight
		for c in part.occupied_cells():
			weighted_pos += Vector2(c.x, 0) * part.data.weight
		total_thickness += part.data.hull_thickness
		
	var center_of_mass := Vector2.ZERO
	if total_weight > 0.0:
		center_of_mass = weighted_pos / total_weight
	
	return {
		"total_weight": total_weight,
		"center_of_mass": center_of_mass,
		"total_thickness": total_thickness,
		"part_count": parts.size()
	}
