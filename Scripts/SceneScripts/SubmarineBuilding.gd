class_name SubmarineBuilding extends Control

@onready var grid: BuildGridCanvas = $BuildGridCanvas
@onready var parts_layer: Control = $BuildGridCanvas/PartsLayer
@onready var palette_container: HBoxContainer = $PaletteFoldableContainer/PaletteScroll/PaletteHBox
@onready var drag_layer: Control = $DragLayer

const SLOT_SCENE := preload("res://Scenes/SubmarineBuidling/PartPaletteSlotUI.tscn")
const PLACED_PART_VIEW_SCENE := preload("res://Scenes/SubmarineBuidling/PlacedPartView.tscn")

var _active_ghost : PlacedPartView

func _ready() -> void: setup()

func setup() -> void:
	_populate_palette()

func _populate_palette() -> void:
	for part_data in PartDatabase.get_all():
		var slot := SLOT_SCENE.instantiate()
		slot.part_data = part_data
		slot.build_ui = self
		palette_container.add_child(slot)

## --- Ghost PlacedParts methods ---
func spawn_ghost(part_data: PartData) -> PlacedPartView:
	var ghost := PLACED_PART_VIEW_SCENE.instantiate()
	drag_layer.add_child(ghost)
	ghost.setup_ghost(part_data, grid)
	_active_ghost = ghost
	return ghost

func drag_ghost(ghost: PlacedPartView, global_pos: Vector2) -> void:
	var cell := grid.local_to_cell(global_pos - grid.global_position)
	ghost.set_ghost_cell(cell)

func commit_or_discard_ghost(ghost: PlacedPartView, global_pos: Vector2) -> void:
	var cell := grid.local_to_cell(global_pos - grid.global_position)
	var trial := PlacedPart.new(ghost.part_data, cell, ghost.rot_steps)
	if RunState.submarine.can_place(trial):
		RunState.submarine.place(trial)   # emits EventBus.part_placed
	ghost.queue_free()
	_active_ghost = null

func _unhandled_input(event: InputEvent) -> void:
	if _active_ghost and event.is_action_pressed("rotate_part"):
		_active_ghost.rotate_ghost()
