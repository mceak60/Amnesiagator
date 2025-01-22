class_name DraggableMover
extends Node

@onready var puzzle_handler = %PuzzleHandler
signal submit_drink(drink: Drink)
signal submit_drink_to(drink: Drink, customer: Customer)
@export var draggable_areas: Array[DraggableArea]

func _ready() -> void:
	var ingredients := get_tree().get_nodes_in_group("ingredients")
	for ingredient: Draggable in ingredients:
		setup_ingredient(ingredient)
		
	var drinks := get_tree().get_nodes_in_group("drinks")
	for drink: Draggable in drinks:
		setup_drink(drink)


func setup_ingredient(ingredient: Ingredient) -> void:
	setup_draggable(ingredient)
	ingredient.drag_and_drop.dropped.connect(_on_ingredient_dropped.bind(ingredient))

func setup_drink(drink: Drink) -> void:
	setup_draggable(drink)
	drink.drag_and_drop.dropped.connect(_on_drink_dropped.bind(drink))

func setup_draggable(draggable: Draggable) -> void:
	draggable.drag_and_drop.drag_started.connect(_on_draggable_drag_started.bind(draggable))
	draggable.drag_and_drop.drag_canceled.connect(_on_draggable_drag_canceled.bind(draggable))


func _set_highlighters(enabled: bool) -> void:
	for draggable_area: DraggableArea in draggable_areas:
		draggable_area.tile_highlighter.enabled = enabled


func _get_draggable_area_for_position(global: Vector2) -> int:
	var dropped_area_index := -1
	
	for i in draggable_areas.size():
		var tile := draggable_areas[i].get_tile_from_global(global)
		if draggable_areas[i].is_tile_in_bounds(tile):
			dropped_area_index = i
	
	return dropped_area_index


func _reset_draggable_to_starting_position(starting_position: Vector2, draggable: Draggable) -> void:
	var i := _get_draggable_area_for_position(starting_position)
	var tile := draggable_areas[i].get_tile_from_global(starting_position)
	
	draggable.reset_after_dragging(starting_position)
	draggable_areas[i].draggable_grid.add_draggable(tile, draggable)


func _move_draggable(draggable: Draggable, draggable_area: DraggableArea, tile: Vector2i) -> void:
	draggable_area.draggable_grid.add_draggable(tile, draggable)
	draggable.global_position = draggable_area.get_global_from_tile(tile) - Bar.HALF_CELL_SIZE
	draggable.reparent(draggable_area.draggable_grid)


func _on_draggable_drag_started(draggable: Draggable) -> void:
	_set_highlighters(true)
	
	var i := _get_draggable_area_for_position(draggable.global_position)
	if i > -1:
		var tile := draggable_areas[i].get_tile_from_global(draggable.global_position)
		draggable_areas[i].draggable_grid.remove_draggable(tile)
		if draggable is Ingredient:
			SFX_Handler.trigger_sfx_func(SFX_Handler.SFX_Triggers.INGREDIENT_PICKED_UP, [draggable], 1, .5,.25)
		if draggable is Drink:
			SFX_Handler.trigger_sfx_func(SFX_Handler.SFX_Triggers.DRINK_PICKED_UP, [draggable], 1, .5,.25)

func _on_draggable_drag_canceled(starting_position: Vector2, draggable: Draggable) -> void:
	_set_highlighters(false)
	_reset_draggable_to_starting_position(starting_position, draggable)


func _on_ingredient_dropped(starting_position: Vector2, ingredient: Ingredient) -> void:
	var drop_area_index := _get_draggable_area_for_position(ingredient.get_global_mouse_position())
	if drop_area_index == 0:
		SFX_Handler.trigger_sfx_func(SFX_Handler.SFX_Triggers.INGREDIENT_DROPPED, [ingredient], 1, .5,.25)
		on_draggable_dropped(starting_position, ingredient, drop_area_index)
		return
		
	elif drop_area_index == 1:
		var tile := draggable_areas[drop_area_index].get_hovered_tile()
		if draggable_areas[drop_area_index].draggable_grid.is_tile_occupied(tile):
			var drink: Draggable = draggable_areas[drop_area_index].draggable_grid.draggables[tile]
			SFX_Handler.trigger_sfx_func(SFX_Handler.SFX_Triggers.INGREDIENT_ADDED_TO_DRINK, [ingredient, drink], 1, .5,.25)
			drink.ingredient_list.append(ingredient)
			drink.debug_label.update_text()
			for attribute in ingredient.details.attribute_list:
				drink.attribute_list[attribute] += ingredient.details.attribute_list[attribute]
			
		_reset_draggable_to_starting_position(starting_position, ingredient)
		return
	
	_reset_draggable_to_starting_position(starting_position, ingredient)

func _on_drink_dropped(starting_position: Vector2, drink: Drink) -> void:
	var drop_area_index := _get_draggable_area_for_position(drink.get_global_mouse_position())
	if drop_area_index == 1:
		SFX_Handler.trigger_sfx_func(SFX_Handler.SFX_Triggers.DRINK_DROPPED, [drink], 1, .5,.25)
		on_draggable_dropped(starting_position, drink, drop_area_index)
		return
	
	elif drop_area_index == 2:
		drink.empty()
		SFX_Handler.trigger_sfx_func(SFX_Handler.SFX_Triggers.DRINK_TRASHED, [drink], 1, .5,.25)
		_reset_draggable_to_starting_position(starting_position, drink)
		return
	
	elif drop_area_index == 3:
		
		print("Submitted drink" + str(drink))
		submit_drink.emit(drink)
		
		_reset_draggable_to_starting_position(starting_position, drink)
		return
	
	elif drop_area_index == 4:
		var tile := draggable_areas[drop_area_index].get_hovered_tile()
		if draggable_areas[drop_area_index].draggable_grid.is_tile_occupied(tile):
			var customer: Customer = draggable_areas[drop_area_index].draggable_grid.draggables[tile]
			print("Gave " + str(customer) + " drink: " + str(drink))
			submit_drink_to.emit(drink, customer)
			drink.empty()
			
		_reset_draggable_to_starting_position(starting_position, drink)
		return
			
			
	_reset_draggable_to_starting_position(starting_position, drink)


func on_draggable_dropped(starting_position: Vector2, draggable: Draggable, drop_area_index: int) -> void:
	_set_highlighters(false)

	var old_area_index := _get_draggable_area_for_position(starting_position)
	var old_area := draggable_areas[old_area_index]
	var old_tile := old_area.get_tile_from_global(starting_position)
	var new_area := draggable_areas[drop_area_index]
	var new_tile := new_area.get_hovered_tile()
	
	# swap draggables if we have to
	if new_area.draggable_grid.is_tile_occupied(new_tile):
		var old_draggable: Draggable = new_area.draggable_grid.draggables[new_tile]
		if draggable is Ingredient and old_draggable is Ingredient:
			SFX_Handler.trigger_sfx_func(SFX_Handler.SFX_Triggers.INGREDIENT_SWAPPED, [draggable, old_draggable], 1, .5,.25)
		new_area.draggable_grid.remove_draggable(new_tile)
		_move_draggable(old_draggable, old_area, old_tile)
	
	_move_draggable(draggable, new_area, new_tile)
