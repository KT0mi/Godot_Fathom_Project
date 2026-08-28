extends Control

@onready var route_container : HBoxContainer = $RouteContainer

var map: ExplorationMap

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	map = ExplorationMap.new()
	map.generate(6, 2, 3)
	_refresh_available_nodes()
	print("Starting Exploration!")
	EventBus.encounter_resolved.connect(func(n):
		_refresh_available_nodes())

func _refresh_available_nodes() -> void:
	for c in route_container.get_children(): c.queue_free()
	var options := map.get_available_next_nodes()
	
	var i := 1
	for option in options:
		var btn := Button.new()
		btn.text = "Route %d: %s" % [i, str(option.type)]
		btn.pressed.connect(_on_route_chosen.bind(option))
		route_container.add_child(btn)
		i+=1

func _on_route_chosen(node: MapNode) -> void:
	var stats : SubmarineStats = RunState.submarine.compute_stats()
	var new_depth := RunState.current_depth + ExplorationMap.DEPTH_PER_LAYER
	
	if new_depth > RunState.max_safe_depth():
		EventBus.request_confirm_risky_travel.emit(node, new_depth)
		return
		
	_commit_travel(node, stats, new_depth)
	
func _commit_travel(node: MapNode, stats: SubmarineStats, new_depth: float) -> void:
	var cost := _calculate_travel(node, stats)
 
	if not RunState.spend_money(cost):
		return  # UI should already be preventing this by graying out the option
 
	RunState.set_depth(new_depth)
	map.commit_to_node(node.id)
 
	EventBus.encounter_started.emit(node)
	#GameFlow.goto_mode(_mode_for_node_type(node.type))
	#DEBUG
	EventBus.encounter_resolved.emit(node)


func _calculate_travel(node: MapNode, stats: SubmarineStats) -> int:
	var base_cost := stats.part_count * 5
	var imbalance_penalty := int(stats.horizontal_imbalance)
	return base_cost + imbalance_penalty

#Don't like it
func _mode_for_node_type(type: MapNode.Type) -> GameFlow.Mode:
	match type:
		MapNode.Type.CREATURE:
			return GameFlow.Mode.COMBAT
		MapNode.Type.TREASURE:
			return GameFlow.Mode.MISC
		MapNode.Type.CATASTROPHE:
			return GameFlow.Mode.MISC
		MapNode.Type.SHOP:
			return GameFlow.Mode.SHOP
	return GameFlow.Mode.EXPLORATION
