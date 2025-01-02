class_name IngredientArea
extends TileMapLayer

@export var ingredient_grid: IngredientGrid
@export var tile_highlighter: TileHighlighter2

var bounds: Rect2i


func _ready() -> void:
	bounds = Rect2i(Vector2.ZERO, ingredient_grid.size)


func get_tile_from_global(global: Vector2) -> Vector2i:
	return local_to_map(to_local(global))


func get_global_from_tile(tile: Vector2i) -> Vector2:
	return to_global(map_to_local(tile))


func get_hovered_tile() -> Vector2i:
	return local_to_map(get_local_mouse_position())


func is_tile_in_bounds(tile: Vector2i) -> bool:
	return bounds.has_point(tile)
