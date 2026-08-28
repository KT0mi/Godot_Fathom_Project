extends Control

@onready var money_label : Label = $VBoxContainer/MoneyLabel
@onready var current_depth_label : Label = $VBoxContainer/CurrentDepthLabel
@onready var days_elapsed_label : Label = $VBoxContainer/DaysElapsedLabel

var _money_buffer : int = 0
var _depth_buffer : int = 0
var _days_buffer : int = 0

var _money_tween : Tween = null
var _depth_tween : Tween = null
var _days_tween : Tween = null


func setup() -> void:
	print("Run Data UI Setup.")
	RunState.money_changed.connect(_refresh_money)
	RunState.depth_changed.connect(_refresh_depth)
	RunState.days_elapsed_changed.connect(_refresh_days)
	
	RunState.money_changed.emit(RunState.money)
	RunState.depth_changed.emit(RunState.current_depth)
	RunState.days_elapsed_changed.emit(RunState.total_days_elapsed)
	
func _refresh_money(new_amount: int) -> void:
	if _money_tween != null:
		await _money_tween.finished
	_money_tween = get_tree().create_tween()
	_money_tween.set_trans(Tween.TRANS_EXPO)
	_money_tween.tween_method(_update_value.bind(money_label, "Money: "), _money_buffer, new_amount, 1)
	#Update Buffer
	_money_buffer = new_amount
	
func _refresh_depth(new_amount: int) -> void:
	if _depth_tween != null:
		await _depth_tween.finished
	_depth_tween = get_tree().create_tween()
	_depth_tween.set_trans(Tween.TRANS_EXPO)
	_depth_tween.tween_method(_update_value.bind(current_depth_label, "Current Depth: "), _depth_buffer, new_amount, 1)
	#Update Buffer
	_depth_buffer = new_amount
	
func _refresh_days(new_amount: int) -> void:
	if _days_tween != null:
		await _days_tween.finished
	_days_tween = get_tree().create_tween()
	_days_tween.set_trans(Tween.TRANS_EXPO)
	_days_tween.tween_method(_update_value.bind(days_elapsed_label, "Days Elapsed: "), _days_buffer, new_amount, 1)
	#Update Buffer
	_days_buffer = new_amount

func _update_value(value: int, label: Label, full_text : String) -> void:
	label.text = full_text + str(value)
