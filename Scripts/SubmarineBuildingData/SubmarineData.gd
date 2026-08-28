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
	EventBus.part_placed.emit(part)

func compute_stats() -> SubmarineStats:
	var stats := SubmarineStats.new()
	if parts.is_empty():
		return stats
 
	var weighted_pos := Vector2.ZERO
	var weighted_x_sum := 0.0
	var unweighted_x_sum := 0.0
	var cell_count := 0
 
	for part in parts:
		stats.total_weight += part.data.weight
		stats.total_hull_thickness += part.data.hull_thickness
 
		if part.data is WeaponPartData:
			stats.weapon_parts.append(part.data as WeaponPartData)
 
		for c in part.occupied_cells():
			weighted_pos += Vector2(c) * part.data.weight
			weighted_x_sum += c.x * part.data.weight
			unweighted_x_sum += c.x
			cell_count += 1
 
	stats.part_count = parts.size()
 
	if stats.total_weight > 0.0:
		stats.center_of_mass = weighted_pos / stats.total_weight
 
	if cell_count > 0:
		var geometric_center_x := unweighted_x_sum / cell_count
		stats.horizontal_imbalance = abs(stats.center_of_mass.x - geometric_center_x)
 
	return stats
