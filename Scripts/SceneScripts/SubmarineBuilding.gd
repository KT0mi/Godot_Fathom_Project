class_name SubmarineBuilding extends Control

@onready var grid: BuildGridCanvas = $BuildGridCanvas
@onready var parts_layer: Control = $BuildGridCanvas/PartsLayer
@onready var palette_container: HBoxContainer = $PaletteFoldableContainer/PaletteScroll/PaletteHBox
@onready var drag_layer: Control = $DragLayer

const SLOT_SCENE := preload("res://Scenes/SubmarineBuidling/PartPaletteSlotUI.tscn")
const PLACED_PART_VIEW_SCENE := preload("res://Scenes/SubmarineBuidling/PlacedPartView.tscn")

func setup() -> void:
	_populate_palette()

func _populate_palette() -> void:
	for part_data in PartDatabase.get_all():
		var slot := SLOT_SCENE.instantiate()
		slot.part_data = part_data
		slot.build_ui = self
		palette_container.add_child(slot)
