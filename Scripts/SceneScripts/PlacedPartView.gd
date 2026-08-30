class_name PlacedPartView
extends Control

func setup(placed_part: PlacedPart, grid: BuildGridCanvas) -> void:
	$TextureRect.texture = placed_part.data.sprite
	position = grid.cell_to_local(placed_part.origin)
	rotation = placed_part.rot_steps * PI / 2.0
	mouse_filter = MOUSE_FILTER_IGNORE  # it's decorative now, not interactive
