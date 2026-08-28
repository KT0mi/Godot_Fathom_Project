class_name ExplorationMap
extends RefCounted
## Pure data: a branching graph of MapNodes arranged in layers, StS-style.
## No node/scene dependency at all, so it can be unit-tested headless
## same as SubmarineData.

const DEPTH_PER_LAYER := 25.0

const DEFAULT_ENCOUNTER := preload("res://Resources/Encounters/test_encounter.gd")

var nodes: Dictionary = {}          # String id -> MapNode
var layers: Array = []              # Array[Array[String]] — node ids per layer
var current_node_id: String = ""

## Relative odds of each encounter type appearing. Tune freely —
## this is exactly the kind of thing you'll want exposed for balancing.
var type_weights := {
	EncounterData.Type.CREATURE: 4,
	EncounterData.Type.TREASURE: 2,
	EncounterData.Type.CATASTROPHE: 2,
	EncounterData.Type.SHOP: 1,
}

func generate(layer_count: int, min_choices: int, max_choices: int) -> void:
	nodes.clear()
	layers.clear()
	
	var prev_layer_ids: Array[String] = []
	
	for layer_i in layer_count:
		var choice_count := randi_range(min_choices, max_choices)
		var this_layer_ids: Array[String] = []
	
		for i in choice_count:
			var node := MapNode.new()
			node.id = "L%d_N%d" % [layer_i, i]
			node.layer = layer_i
			node.travel_time = randf_range(1.0, 3.0)
			
			var chosen_type := EncounterData.Type.TREASURE #_random_type()
			node.encounter = EncounterDatabase.get_random_encounter(chosen_type)
			
			nodes[node.id] = node
			this_layer_ids.append(node.id)
	
		if not prev_layer_ids.is_empty():
			_connect_layers(prev_layer_ids, this_layer_ids)
	
		layers.append(this_layer_ids)
		prev_layer_ids = this_layer_ids
	
	if not layers.is_empty() and not layers[0].is_empty():
		current_node_id = layers[0][randi() % layers[0].size()]


## Every node in prev_layer gets at least one forward connection, and
## every node in next_layer is reachable from at least one prev node —
## otherwise you can generate dead-end or unreachable nodes.
func _connect_layers(prev_layer_ids: Array[String], next_layer_ids: Array[String]) -> void:
	for prev_id in prev_layer_ids:
		var target: String = next_layer_ids[randi() % next_layer_ids.size()]
		nodes[prev_id].connections.append(target)
	
	for next_id in next_layer_ids:
		var reachable := false
		for prev_id in prev_layer_ids:
			if nodes[prev_id].connections.has(next_id):
				reachable = true
				break
		if not reachable:
			var random_prev: String = prev_layer_ids[randi() % prev_layer_ids.size()]
			nodes[random_prev].connections.append(next_id)


func _random_type() -> EncounterData.Type:
	var total := 0
	for w in type_weights.values():
		total += w
	var roll := randi() % total
	var acc := 0
	for t in type_weights.keys():
		acc += type_weights[t]
		if roll < acc:
			return t
	return EncounterData.Type.CREATURE


func get_available_next_nodes() -> Array[MapNode]:
	if current_node_id == "" or not nodes.has(current_node_id):
		return []
	var current: MapNode = nodes[current_node_id]
	var out: Array[MapNode] = []
	for id in current.connections:
		out.append(nodes[id])
	return out


func commit_to_node(node_id: String) -> void:
	if not nodes.has(node_id):
		push_error("ExplorationMap: unknown node id %s" % node_id)
		return
	current_node_id = node_id
