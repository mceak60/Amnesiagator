class_name TileHighlighter2
extends Node

@export var enabled: bool = true : set = _set_enabled
@export var draggable_area: DraggableArea
@export var highlight_layer: TileMapLayer
@export var tile: Vector2i

@onready var source_id := draggable_area.tile_set.get_source_id(0)


func _process(_delta: float) -> void:
	if not enabled:
		return

	var selected_tile := draggable_area.get_hovered_tile()
	
	if not draggable_area.is_tile_in_bounds(selected_tile):
		highlight_layer.clear()
		return

	_update_tile(selected_tile)


func _set_enabled(new_value: bool) -> void:
	enabled = new_value
	
	if not enabled and draggable_area:
		highlight_layer.clear()


func _update_tile(selected_tile: Vector2i) -> void:
	highlight_layer.clear()
	highlight_layer.set_cell(selected_tile, source_id, tile)
