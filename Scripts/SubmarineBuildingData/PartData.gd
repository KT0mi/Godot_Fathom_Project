class_name PartData extends Resource

@export var part_name: String
@export var part_description: String

@export var weight: float
@export var hull_thickness: float
@export var cost: int

@export var footprint : Array[Vector2i] = [Vector2i.ZERO]
@export var connectors: Array[PartConnector] = []

@export var sprite: Texture2D
