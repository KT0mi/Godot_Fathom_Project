class_name EncounterData extends Resource
## Base class for every designed encounter. A MapNode holds ONE of these
## (or a subclass) rather than owning a bare type enum — the specific
## encounter (art, description, effect) IS the data, not something
## looked up separately from a type.
 
enum Type { CREATURE, TREASURE, CATASTROPHE, SHOP }
 
@export var encounter_name: String = ""
@export var type: Type = Type.TREASURE
@export var description: String = ""
