class_name MapNode
extends RefCounted
 
enum Type { CREATURE, TREASURE, CATASTROPHE, SHOP }
 
var id: String
var type: Type
var layer: int
var travel_time: float = 1.0  # in days, before submarine modifiers apply
 
## IDs of MapNodes in the next layer this node can lead to. Populated by
## ExplorationMap.generate() — a node with no connections is the end
## of a branch (or the final layer).
var connections: Array[String] = []
 
