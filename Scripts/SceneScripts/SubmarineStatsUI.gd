extends Control

@onready var weight_ctr : FoldableContainer = $SubmarineStatsContainer/HSSContainer/Weight
@onready var weight_imbalance_label : Label = $SubmarineStatsContainer/HSSContainer/Weight/HWContainer/WeightImbalanceLabel
@onready var added_travel_label : Label = $SubmarineStatsContainer/HSSContainer/Weight/HWContainer/AddedTravelTimeLabel

@onready var hull_thickness_ctr : FoldableContainer = $SubmarineStatsContainer/HSSContainer/HullThickness
@onready var depth_danger_level_label : Label = $SubmarineStatsContainer/HSSContainer/HullThickness/HHTContainer/DepthDangerLevelLabel
@onready var max_depth_label : Label = $SubmarineStatsContainer/HSSContainer/HullThickness/HHTContainer/MaxDepthLabel

@onready var part_count_ctr : FoldableContainer = $SubmarineStatsContainer/HSSContainer/PartCount
@onready var base_attack_label : Label = $SubmarineStatsContainer/HSSContainer/PartCount/HPCContainer/BaseAttackLabel
@onready var base_armor_label : Label = $SubmarineStatsContainer/HSSContainer/PartCount/HPCContainer/BaseArmorLabel

##TODO
##Placeholder grid for immediate submarine grid visualization
var sub_grid : Dictionary[Vector2i, ColorRect]
@onready var grid_container : GridContainer = $SubmarineStatsContainer/HSSContainer/GridContainer

func setup() -> void:
	populate_grid()
	refresh()
	EventBus.part_placed.connect(func(c): 
		print("Placed Part and refreshed ui")
		refresh())

func populate_grid() -> void:
	var grid_size := grid_container.columns
	for x in range(grid_size):
		for y in range(grid_size):
			var cr := ColorRect.new()
			cr.custom_minimum_size = Vector2(32,32)
			cr.color = Color.WHITE
			grid_container.add_child(cr)
			sub_grid[Vector2i(x,y)] = cr

func refresh() -> void:
	var stats := RunState.submarine.compute_stats()
	print("SubmarineStatsUI: Refreshed.")
	
	#Refresh Weight Data:
	weight_ctr.title = "Weight: " + str(stats.total_weight)
	weight_imbalance_label.text = "Weight Imbalance: " + str(stats.horizontal_imbalance)
	added_travel_label.text = "Added Travel Time: " + str(stats.horizontal_imbalance * RunState.IMBALANCE_DAYS_FACTOR)
	
	#Refresh Hull Thickness Data:
	hull_thickness_ctr.title = "Hull Thickness: " + str(stats.total_hull_thickness)
	depth_danger_level_label.text = "Depth Danger Level: "
	max_depth_label.text = "Max Depth: " + str(RunState.max_safe_depth())
	
	#Refresh Part Count Data:
	part_count_ctr.title = "Total Parts: " + str(stats.part_count)
	base_attack_label.text = "Base Attack: "
	base_armor_label.text = "Base Armor: "
	
	#Refresh Grid
	refresh_grid()

func refresh_grid() -> void:
	var grid_size := grid_container.columns
	var curr_grid := RunState.submarine.cells
	for x in range(grid_size):
		for y in range(grid_size):
			if curr_grid.has(Vector2i(x,y)):
				sub_grid[Vector2i(x,y)].color = Color.BLACK
			else:
				sub_grid[Vector2i(x,y)].color = Color.WHITE
