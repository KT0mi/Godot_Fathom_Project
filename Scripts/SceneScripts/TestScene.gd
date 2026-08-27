extends Control

@onready var lbl : Label = $Label 
@onready var btn : Button = $Button
@onready var xbox : SpinBox = $XBox
@onready var ybox : SpinBox = $YBox
var part : PartData = preload("res://Resources/Parts/TestPart1x1.tres")
var sub : SubmarineData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sub = SubmarineData.new()
	btn.pressed.connect(_on_btn_pressed)
	_refresh()

func _on_btn_pressed() -> void:
	var placed_part := PlacedPart.new(
		part,
		Vector2i(int(xbox.value), int(ybox.value)),
		0
	)
	if sub.can_place(placed_part):
		sub.place(placed_part)
	else:
		print("Cannot place part!")
	_refresh()


func _refresh() -> void:
	var grid = ""
	for y in range(3):
		for x in range(3):
			grid += "X" if sub.cells.has(Vector2i(x,y)) else "O"
		grid += "\n"
	
	lbl.text = \
		"Total Weight: " + str(sub.compute_stats().get("total_weight")) + "\n" + \
		"Center of Mass: " + str(sub.compute_stats().get("center_of_mass")) + "\n" + \
		"Total Hull Thickness: " + str(sub.compute_stats().get("total_thickness")) + "\n" + \
		"Number of Parts: " + str(sub.compute_stats().get("part_count")) + "\n" + \
		grid
