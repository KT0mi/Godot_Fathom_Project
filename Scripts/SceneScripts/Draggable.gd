class_name Draggable extends Node
##Draggable Component to add to ui objects
##Like Parts and Cards

signal drag_started(at_global_pos: Vector2)
signal dragging(global_pos: Vector2)
signal drag_ended(global_pos: Vector2)

@export var button_mask: MouseButton = MOUSE_BUTTON_LEFT
@export var drag_threshold_px: float = 4.0

var _control: Control
var _pressed := false
var _drag_active := false
var _press_pos: Vector2

func _ready() -> void:
	_control = get_parent() as Control
	assert(_control, "Draggable must be a child of a Control")
	_control.gui_input.connect(_on_gui_input)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == button_mask:
		if event.pressed:
			_pressed = true
			_press_pos = event.global_position
			_control.accept_event()
		else:
			if _drag_active:
				drag_ended.emit(event.global_position)
			_pressed = false
			_drag_active = false
	elif event is InputEventMouseMotion and _pressed:
		if not _drag_active and event.global_position.distance_to(_press_pos) >= drag_threshold_px:
			_drag_active = true
			drag_started.emit(_press_pos)
		if _drag_active:
			dragging.emit(event.global_position)
