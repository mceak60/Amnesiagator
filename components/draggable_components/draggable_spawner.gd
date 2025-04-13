class_name DraggableSpawner
extends Node

signal ingredient_spawned(ingredient: Ingredient)
signal drink_spawned(drink: Drink)

const INGREDIENT = preload("res://scenes/ingredient/ingredient.tscn")
const DRINK = preload("res://scenes/drink/drink.tscn")
const CUSTOMER = preload("res://scenes/customer/customer.tscn")

@export var shelf: DraggableArea
@export var counter: DraggableArea
@export var seating: DraggableArea

func _ready() -> void:
	var tween := create_tween()
	tween.tween_callback(spawn_ingredient_at.bind(preload("res://data/ingredients/bases/fireball_whiskey.tres"), Vector2i(0, 0)))
	tween.tween_callback(spawn_ingredient_at.bind(preload("res://data/ingredients/bases/frost_vodka.tres"), Vector2i(1, 0)))
	tween.tween_callback(spawn_ingredient_at.bind(preload("res://data/ingredients/bases/berry_brew.tres"), Vector2i(2, 0)))
	tween.tween_callback(spawn_ingredient_at.bind(preload("res://data/ingredients/bases/molten_metal.tres"), Vector2i(3, 0)))
	tween.tween_callback(spawn_ingredient_at.bind(preload("res://data/ingredients/mixers/ice.tres"), Vector2i(0, 1)))
	tween.tween_callback(spawn_ingredient_at.bind(preload("res://data/ingredients/mixers/spark_syrup.tres"), Vector2i(1, 1)))
	tween.tween_callback(spawn_ingredient_at.bind(preload("res://data/ingredients/mixers/bubbly_water.tres"), Vector2i(2, 1)))
	tween.tween_callback(spawn_ingredient_at.bind(preload("res://data/ingredients/mixers/lava_lamp.tres"), Vector2i(3, 1)))
	tween.tween_callback(spawn_ingredient_at.bind(preload("res://data/ingredients/garnishes/stardust_sprinkles.tres"), Vector2i(0, 2)))
	tween.tween_callback(spawn_ingredient_at.bind(preload("res://data/ingredients/garnishes/red_pepper_flakes.tres"), Vector2i(1, 2)))
	tween.tween_callback(spawn_ingredient_at.bind(preload("res://data/ingredients/garnishes/blossom_petals.tres"), Vector2i(2, 2)))
	tween.tween_callback(spawn_ingredient_at.bind(preload("res://data/ingredients/garnishes/hickory.tres"), Vector2i(3, 2)))
	tween.tween_callback(spawn_drink_at.bind(Vector2i(3, 0)))
	#tween.tween_callback(spawn_customer_at.bind(preload("res://data/customers/doug.tres"), Vector2i(1, 0)))
	#tween.tween_callback(spawn_customer_at.bind(preload("res://data/customers/test.tres"), Vector2i(4, 0)))
	#tween.tween_callback(spawn_customer_at.bind(preload("res://data/customers/mark.tres"), Vector2i(4, 0)))


#func get_approved_area(draggable: Draggable) -> DraggableArea:
	#if draggable is Ingredient:
		#return shelf
	#
	#elif draggable is Drink:
		#return counter
	#
	#return null


#func spawn_draggable(draggable: Draggable, ingredient_details: IngredientDetails = null) -> void:
	#var area := get_approved_area(draggable)
	#assert(area, "Unexpected object in the bar.")
	#if area == shelf:
		#spawn_ingredient(ingredient_details)

func spawn_ingredient(ingredient: IngredientDetails) -> void:
	var new_ingredient := INGREDIENT.instantiate()
	var tile := shelf.draggable_grid.get_first_empty_tile()
	shelf.draggable_grid.add_child(new_ingredient)
	shelf.draggable_grid.add_draggable(tile, new_ingredient)
	new_ingredient.global_position = shelf.get_global_from_tile(tile) - Bar.HALF_CELL_SIZE
	new_ingredient.details = ingredient
	ingredient_spawned.emit(new_ingredient)


func spawn_ingredient_at(ingredient: IngredientDetails, tile: Vector2i) -> void:
	var new_ingredient := INGREDIENT.instantiate()
	shelf.draggable_grid.add_child(new_ingredient)
	shelf.draggable_grid.add_draggable(tile, new_ingredient)
	new_ingredient.global_position = shelf.get_global_from_tile(tile) - Bar.HALF_CELL_SIZE
	new_ingredient.details = ingredient
	ingredient_spawned.emit(new_ingredient)


func spawn_drink() -> void:
	var new_drink := DRINK.instantiate()
	var tile := counter.draggable_grid.get_first_empty_tile()
	counter.draggable_grid.add_child(new_drink)
	counter.draggable_grid.add_draggable(tile, new_drink)
	new_drink.global_position = counter.get_global_from_tile(tile) - Bar.HALF_CELL_SIZE
	drink_spawned.emit(new_drink)


func spawn_drink_at(tile: Vector2i) -> void:
	var new_drink := DRINK.instantiate()
	counter.draggable_grid.add_child(new_drink)
	counter.draggable_grid.add_draggable(tile, new_drink)
	new_drink.global_position = counter.get_global_from_tile(tile) - Bar.HALF_CELL_SIZE
	drink_spawned.emit(new_drink)


func spawn_customer(customer: CustomerDetails) -> Customer:
	var new_customer := CUSTOMER.instantiate()
	#var tile := seating.draggable_grid.get_first_empty_tile()
	#seating.draggable_grid.add_child(new_customer)
	#seating.draggable_grid.add_draggable(tile, new_customer)
	#new_customer.global_position = seating.get_global_from_tile(tile) - Bar.HALF_CELL_SIZE
	seating.add_child(new_customer)
	new_customer.global_position = Vector2(152, 228)
	new_customer.enable_collision()
	new_customer.details = customer
	SFX_Handler.trigger_sfx_func(SFX_Handler.SFX_Triggers.CUSTOMER_ENTERED, [new_customer], 1, .5,.25)
	return new_customer


func spawn_customer_at(customer: CustomerDetails, position: Vector2i) -> Customer:
	var new_customer := CUSTOMER.instantiate()
	#seating.draggable_grid.add_child(new_customer)
	#seating.draggable_grid.add_draggable(tile, new_customer)
	#new_customer.global_position = seating.get_global_from_tile(tile) - Bar.HALF_CELL_SIZE
	seating.add_child(new_customer)
	new_customer.global_position = position
	new_customer.enable_collision()
	new_customer.details = customer
	SFX_Handler.trigger_sfx_func(SFX_Handler.SFX_Triggers.CUSTOMER_ENTERED, [new_customer], 1, .5,.25)
	return new_customer
