extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameFlow.register_container($ModeContainer)
	RunState.start_new_run()
	GameFlow.goto_mode(GameFlow.Mode.EXPLORATION)
