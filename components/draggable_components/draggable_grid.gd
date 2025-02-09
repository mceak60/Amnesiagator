class_name DraggableGrid
extends Node2D

signal draggable_grid_changed

@export var size: Vector2i

var draggables: Dictionary


func _ready() -> void:
	for i in size.x:
		for j in size.y:
			draggables[Vector2i(i, j)] = null


func add_draggable(tile: Vector2i, draggable: Node) -> void:
	draggables[tile] = draggable
	draggable_grid_changed.emit()


func remove_draggable(tile: Vector2i) -> void:
	var draggable := draggables[tile] as Node
	
	if not draggable:
		return
	
	draggables[tile] = null
	draggable_grid_changed.emit()


func is_tile_occupied(tile: Vector2i) -> bool:
	return draggables[tile] != null


func is_grid_full() -> bool:
	return draggables.keys().all(is_tile_occupied)


func get_first_empty_tile() -> Vector2i:
	for tile in draggables:
		if not is_tile_occupied(tile):
			return tile

	# no empty tile
	return Vector2i(-1, -1)


func get_all_draggables() -> Array[Draggable]:
	var draggable_array: Array[Draggable] = []
	
	for draggable: Draggable in draggables.values():
		if draggable:
			draggable_array.append(draggable)
	
	return draggable_array
