@tool
class_name Drink
extends Draggable

@export var ingredient_list : Array[Ingredient]
var attribute_list = {
	"Hot": 0,
	"Cold" : 0,
	"Tangy" : 0
}

@onready var skin: Sprite2D = $Visuals/Skin


@export_category("Visuals")
@export var skin_coordinates: Vector2i : set = set_skin

func set_skin(coords: Vector2i) -> void:
	skin_coordinates = coords
	
	if coords == null:
		return
	
	if not is_node_ready():
		await ready
	
	skin.region_rect.position = Vector2(skin_coordinates) * Arena.CELL_SIZE



func _to_string() -> String:
	return name
