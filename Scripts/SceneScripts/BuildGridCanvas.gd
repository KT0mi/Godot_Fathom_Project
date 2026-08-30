class_name BuildGridCanvas
extends Control

@export var cell_size : int = 64
@export var grid_dimensions : Vector2i = Vector2i(64, 64)

var pan_offset: Vector2 = Vector2.ZERO
var _panning := false
var _resetting := false
var _pan_start_mouse: Vector2
var _pan_start_offset: Vector2

@onready var parts_layer : Control = $PartsLayer

const PLACED_PART_VIEW_SCENE := preload("res://Scenes/SubmarineBuidling/PlacedPartView.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	clip_contents = true
	pan_offset = size / 2.0 - Vector2(grid_dimensions) * cell_size / 2
	_apply_pan()
	EventBus.part_placed.connect(_on_part_placed)

func _on_part_placed(part: PlacedPart) -> void:
	var view := PLACED_PART_VIEW_SCENE.instantiate()
	parts_layer.add_child(view)
	view.setup(part, self)

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.keycode == Key.KEY_R and not _resetting:
		_resetting = true
		reset_panning()

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_MIDDLE:
		_panning = event.pressed
		_pan_start_mouse = event.global_position
		_pan_start_offset = pan_offset
	elif event is InputEventMouseMotion and _panning:
		pan_offset = _pan_start_offset + (event.global_position - _pan_start_mouse)
		_apply_pan()

func reset_panning() -> void:
	var to_value := size / 2.0 - Vector2(grid_dimensions) * cell_size / 2
	_apply_pan()
	
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_method(_apply_reset, pan_offset, to_value, 1)
	await tween.finished
	_resetting = false

func _apply_reset(offset) -> void:
	pan_offset = offset
	_apply_pan()

func _apply_pan() -> void:
	parts_layer.position = pan_offset
	queue_redraw()

func _draw() -> void:
	# Only the visible window gets drawn, so grid_dimensions can be huge
	# without costing more per frame.
	var top_left := local_to_cell(Vector2.ZERO)
	var bottom_right := local_to_cell(size)
	for x in range(max(top_left.x, 0), min(bottom_right.x + 1, grid_dimensions.x)):
		for y in range(max(top_left.y, 0), min(bottom_right.y + 1, grid_dimensions.y)):
			var rect := Rect2(cell_to_local(Vector2i(x, y)), Vector2(cell_size, cell_size))
			draw_rect(rect, Color(1, 1, 1, 0.08), false, 1.0)

func local_to_cell(local_pos: Vector2) -> Vector2i:
	var p := local_pos - pan_offset
	return Vector2i(floori(p.x / cell_size), floori(p.y / cell_size))

func cell_to_local(cell: Vector2i) -> Vector2:
	return pan_offset + Vector2(cell) * cell_size
