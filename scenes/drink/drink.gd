@tool
class_name Drink
extends Draggable

@export var details : DrinkDetails : set = set_details

@onready var skin: Sprite2D = $Visuals/Skin


func set_details(value: DrinkDetails) -> void:
	details = value
	
	if value == null:
		return
	
	if not is_node_ready():
		await ready
	
	skin.region_rect.position = Vector2(details.skin_coordinates) * Arena.CELL_SIZE
