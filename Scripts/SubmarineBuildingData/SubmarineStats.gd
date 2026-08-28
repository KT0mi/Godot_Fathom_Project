class_name SubmarineStats extends RefCounted

## A snapshot of a SubmarineData's computed stats. Returned by
## SubmarineData.compute_stats() instead of a Dictionary so every field
## gets autocomplete and a typo is a parse error, not a silent bug.
 
var total_weight: float = 0.0
var center_of_mass: Vector2 = Vector2.ZERO
 
## Only the X axis matters for debuffs (per design: vertical balance
## would be too punishing). This is the absolute distance between the
## weight-weighted X center and the unweighted geometric X center —
## 0 means mass is spread evenly along the hull, larger means lopsided.
var horizontal_imbalance: float = 0.0
 
## Additive: parts can carry negative hull_thickness to weaken the hull,
## so this is just a straight sum, not clamped or averaged.
var total_hull_thickness: float = 0.0
 
var part_count: int = 0
 
## Every WeaponPartData currently on the sub, for building the combat
## card pool later.
var weapon_parts: Array[WeaponPartData] = []
