extends Node
##Autoload

##This is a stateless script. This script is a signal hub for general triggers

signal encounter_started(node: MapNode)
signal encounter_resolved(node: MapNode, result: Dictionary)

signal request_confirm_risky_travel(node: MapNode, new_depth: float)

signal part_placed(part: PlacedPart)

signal run_over(reason: String)
