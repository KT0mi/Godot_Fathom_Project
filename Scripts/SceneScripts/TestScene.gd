extends Control

@onready var lbl : Label = $Label 
@onready var btn : Button = $Button
@onready var xbox : SpinBox = $XBox
@onready var ybox : SpinBox = $YBox
var part : PartData = preload("res://Resources/Parts/TestPart1x1.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	btn.pressed.connect(_on_btn_pressed)
	_refresh()

func _on_btn_pressed() -> void:
	var placed_part := PlacedPart.new(
		part,
		Vector2i(int(xbox.value), int(ybox.value)),
		0
	)
	if RunState.submarine.can_place(placed_part):
		RunState.submarine.place(placed_part)
	else:
		print("Cannot place part!")
	_refresh()


func _refresh() -> void:
	var grid = ""
	var stats = RunState.submarine.compute_stats()
	for y in range(3):
		for x in range(3):
			grid += "X" if RunState.submarine.cells.has(Vector2i(x,y)) else "O"
		grid += "\n"
	
	lbl.text = \
		"Total Weight: " + str(stats.total_weight) + "\n" + \
		"Horizontal Imbalance: " + str(stats.horizontal_imbalance) + "\n" + \
		"Total Hull Thickness: " + str(stats.total_hull_thickness) + "\n" + \
		"Number of Parts: " + str(stats.part_count) + "\n" + \
		"Money: " + str(RunState.money) + "\n" + \
		grid
