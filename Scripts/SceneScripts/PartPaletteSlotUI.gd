class_name PartPaletteSlotUI
extends Control

@export var part_data: PartData
var build_ui: SubmarineBuilding   # injected by whoever instances the slot
var _ghost: PlacedPartView

@onready var icon: TextureRect = $Margin/VBoxContainer/Icon
@onready var drag: Draggable = $Draggable

func _ready() -> void:
	icon.texture = part_data.sprite
	drag.drag_started.connect(func(_p): _ghost = build_ui.spawn_ghost(part_data))
	drag.dragging.connect(func(pos): if _ghost: build_ui.drag_ghost(_ghost, pos))
	drag.drag_ended.connect(func(pos): if _ghost: build_ui.commit_or_discard_ghost(_ghost, pos); _ghost = null)
