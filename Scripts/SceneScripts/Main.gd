extends Control

#UI Scenes
@onready var submarine_ui := $SubmarineUI
@onready var run_data_ui := $RunDataUI

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameFlow.register_container($ModeContainer)
	RunState.start_new_run()
	
	#Init UI
	run_data_ui.setup()
	submarine_ui.setup()
	
	GameFlow.goto_mode(GameFlow.Mode.EXPLORATION)
