class_name IngredientMover
extends Node

@export var ingredient_areas: Array[IngredientArea]


func _ready() -> void:
	var ingredients := get_tree().get_nodes_in_group("ingredients")
	for ingredient: Ingredient in ingredients:
		setup_ingredient(ingredient)


func setup_ingredient(ingredient: Ingredient) -> void:
	ingredient.drag_and_drop.drag_started.connect(_on_ingredient_drag_started.bind(ingredient))
	ingredient.drag_and_drop.drag_canceled.connect(_on_ingredient_drag_canceled.bind(ingredient))
	ingredient.drag_and_drop.dropped.connect(_on_ingredient_dropped.bind(ingredient))


func _set_highlighters(enabled: bool) -> void:
	for ingredient_area: IngredientArea in ingredient_areas:
		ingredient_area.tile_highlighter.enabled = enabled


func _get_ingredient_area_for_position(global: Vector2) -> int:
	var dropped_area_index := -1
	
	for i in ingredient_areas.size():
		var tile := ingredient_areas[i].get_tile_from_global(global)
		if ingredient_areas[i].is_tile_in_bounds(tile):
			dropped_area_index = i
	
	return dropped_area_index


func _reset_ingredient_to_starting_position(starting_position: Vector2, ingredient: Ingredient) -> void:
	var i := _get_ingredient_area_for_position(starting_position)
	var tile := ingredient_areas[i].get_tile_from_global(starting_position)
	
	ingredient.reset_after_dragging(starting_position)
	ingredient_areas[i].ingredient_grid.add_ingredient(tile, ingredient)


func _move_ingredient(ingredient: Ingredient, ingredient_area: IngredientArea, tile: Vector2i) -> void:
	ingredient_area.ingredient_grid.add_ingredient(tile, ingredient)
	ingredient.global_position = ingredient_area.get_global_from_tile(tile) - Arena.HALF_CELL_SIZE
	ingredient.reparent(ingredient_area.ingredient_grid)


func _on_ingredient_drag_started(ingredient: Ingredient) -> void:
	_set_highlighters(true)
	
	var i := _get_ingredient_area_for_position(ingredient.global_position)
	if i > -1:
		var tile := ingredient_areas[i].get_tile_from_global(ingredient.global_position)
		ingredient_areas[i].ingredient_grid.remove_ingredient(tile)


func _on_ingredient_drag_canceled(starting_position: Vector2, ingredient: Ingredient) -> void:
	_set_highlighters(false)
	_reset_ingredient_to_starting_position(starting_position, ingredient)


func _on_ingredient_dropped(starting_position: Vector2, ingredient: Ingredient) -> void:
	_set_highlighters(false)

	var old_area_index := _get_ingredient_area_for_position(starting_position)
	var drop_area_index := _get_ingredient_area_for_position(ingredient.get_global_mouse_position())
	
	if drop_area_index == -1:
		_reset_ingredient_to_starting_position(starting_position, ingredient)
		return

	var old_area := ingredient_areas[old_area_index]
	var old_tile := old_area.get_tile_from_global(starting_position)
	var new_area := ingredient_areas[drop_area_index]
	var new_tile := new_area.get_hovered_tile()
	
	# swap ingredients if we have to
	if new_area.ingredient_grid.is_tile_occupied(new_tile):
		var old_ingredient: Ingredient = new_area.ingredient_grid.ingredients[new_tile]
		new_area.ingredient_grid.remove_ingredient(new_tile)
		_move_ingredient(old_ingredient, old_area, old_tile)
	
	_move_ingredient(ingredient, new_area, new_tile)
