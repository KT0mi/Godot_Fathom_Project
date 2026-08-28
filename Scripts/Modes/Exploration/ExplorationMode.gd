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
		btn.text = "Route %d: %s" % [i, option.encounter.encounter_name if option.encounter else "???"]
		btn.pressed.connect(_on_route_chosen.bind(option))
		route_container.add_child(btn)
		i+=1

func _on_route_chosen(node: MapNode) -> void:
	var stats : SubmarineStats = RunState.submarine.compute_stats()
	var travel_days := _calculate_travel_days(node, stats)
	var new_depth := RunState.current_depth + ExplorationMap.DEPTH_PER_LAYER
	
	if new_depth > RunState.max_safe_depth():
		EventBus.request_confirm_risky_travel.emit(node, new_depth)
		return
		
	_commit_travel(node, travel_days, new_depth)
	
func _commit_travel(node: MapNode, travel_days: float, new_depth: float) -> void:
	var cost := ceili(travel_days) * RunState.UPKEEP_PER_DAY
	
	if not RunState.spend_money(cost):
		print("Not Enough Money to travel!")
		return  # UI should already be preventing this by graying out the option
	RunState.advance_days(travel_days)
	RunState.set_depth(new_depth)
	map.commit_to_node(node.id)
	RunState.current_encounter = node.encounter
	
	EventBus.encounter_started.emit(node)
	GameFlow.goto_mode(GameFlow.mode_for_encounter_type(node.get_encounter_type()))

func _calculate_travel_days(node: MapNode, stats: SubmarineStats) -> float:
	return node.travel_time + stats.horizontal_imbalance * RunState.IMBALANCE_DAYS_FACTOR
