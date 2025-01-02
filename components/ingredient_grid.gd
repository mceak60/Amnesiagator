class_name IngredientGrid
extends Node2D

signal ingredient_grid_changed

@export var size: Vector2i

var ingredients: Dictionary


func _ready() -> void:
	for i in size.x:
		for j in size.y:
			ingredients[Vector2i(i, j)] = null


func add_ingredient(tile: Vector2i, ingredient: Node) -> void:
	ingredients[tile] = ingredient
	ingredient_grid_changed.emit()


func remove_ingredient(tile: Vector2i) -> void:
	var ingredient := ingredients[tile] as Node
	
	if not ingredient:
		return
	
	ingredients[tile] = null
	ingredient_grid_changed.emit()


func is_tile_occupied(tile: Vector2i) -> bool:
	return ingredients[tile] != null


func is_grid_full() -> bool:
	return ingredients.keys().all(is_tile_occupied)


func get_first_empty_tile() -> Vector2i:
	for tile in ingredients:
		if not is_tile_occupied(tile):
			return tile

	# no empty tile
	return Vector2i(-1, -1)


func get_all_ingredients() -> Array[Ingredient]:
	var ingredient_array: Array[Ingredient] = []
	
	for ingredient: Ingredient in ingredients.values():
		if ingredient:
			ingredient_array.append(ingredient)
	
	return ingredient_array
