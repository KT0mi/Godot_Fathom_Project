class_name PlacedPartView
extends Control

var part_data: PartData
var origin_cell: Vector2i
var rot_steps: int = 0
var grid: BuildGridCanvas
var is_ghost := false

var pos_tween : Tween = null
var cashed_cell : Vector2 = Vector2.ZERO

@onready var texture_rect: TextureRect = $TextureRect

# --- Permanent (post-commit), spawned in response to EventBus.part_placed ---
func setup(placed_part: PlacedPart, p_grid: BuildGridCanvas) -> void:
	part_data = placed_part.data
	origin_cell = placed_part.origin
	rot_steps = placed_part.rot_steps
	grid = p_grid
	is_ghost = false
	texture_rect.texture = part_data.sprite
	mouse_filter = MOUSE_FILTER_IGNORE
	modulate = Color.WHITE
	_sync_transform()

# --- Ghost (pre-commit), lives in DragLayer ---
func setup_ghost(p_part_data: PartData, p_grid: BuildGridCanvas) -> void:
	part_data = p_part_data
	grid = p_grid
	rot_steps = 0
	is_ghost = true
	texture_rect.texture = part_data.sprite
	mouse_filter = MOUSE_FILTER_IGNORE
	_sync_transform()

func set_ghost_cell(cell: Vector2i) -> bool:
	origin_cell = cell
	_sync_transform()
	var trial := PlacedPart.new(part_data, origin_cell, rot_steps)
	var valid := RunState.submarine.can_place(trial)
	modulate = Color(0.5, 1.0, 0.5, 0.75) if valid else Color(1.0, 0.4, 0.4, 0.75)
	return valid

func rotate_ghost() -> void:
	rot_steps = (rot_steps + 1) % 4
	set_ghost_cell(origin_cell)   # re-syncs transform + re-validates + re-tints

func _sync_transform() -> void:
	var sync_cell := grid.cell_to_local(origin_cell)
	if cashed_cell != sync_cell:
		if pos_tween:
			pos_tween.kill()
		pos_tween = create_tween()
		pos_tween.set_ease(Tween.EASE_OUT)
		pos_tween.set_trans(Tween.TRANS_EXPO)
		pos_tween.tween_property(self, "position", sync_cell, 0.2)
	#position = grid.cell_to_local(origin_cell)
	rotation = rot_steps * PI / 2.0
