extends Node
##Autoload
##
##Holds Data that persists for the duration of a run

signal money_changed(new_amount: int)
signal depth_changed(new_depth: int)
signal days_elapsed_changed(new_total: float)
signal run_started

const STARTING_MONEY := 100
const DEPTH_PER_THICKNESS_UNIT:= 100.0
const UPKEEP_PER_DAY := 1
const DIFFICULTY_PER_DAY := 0.01

var submarine: SubmarineData = SubmarineData.new()
var money : int = STARTING_MONEY
var current_depth : float = 0.0
var total_days_elapsed : int = 0

var current_encounter : EncounterData = null

func start_new_run() -> void:
	submarine = SubmarineData.new()
	money = STARTING_MONEY
	current_depth = 0.0
	total_days_elapsed = 0.0
	current_encounter = null
	run_started.emit()
	money_changed.emit(money)
	depth_changed.emit(current_depth)
	days_elapsed_changed.emit(total_days_elapsed)


func add_money(amount: int) -> void:
	money += amount
	money_changed.emit(money)

func spend_money(amount: int) -> bool:
	if amount > money:
		return false
	money -= amount
	money_changed.emit(money)
	return true

func set_depth(new_depth: float) -> void:
	current_depth = new_depth
	depth_changed.emit(current_depth)

func advance_days(days: float) -> void:
	total_days_elapsed += days
	days_elapsed_changed.emit(total_days_elapsed)

func get_difficulty_multiplier() -> float:
	return 1.0 + total_days_elapsed * DIFFICULTY_PER_DAY

## The deepest this submarine can safely go, given its current hull stats.
## Exploration checks route depth against this BEFORE committing travel.
func max_safe_depth() -> float:
	var stats: SubmarineStats = submarine.compute_stats()
	return stats.total_hull_thickness * DEPTH_PER_THICKNESS_UNIT
