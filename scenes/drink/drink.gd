@tool
class_name Drink
extends Draggable

@export var ingredient_list : Array[Ingredient]
var attribute_list = {
	"Heat": 0,
	"Cold" : 0,
	"Fruity" : 0,
	"Metallic" : 0,
	"Electricity" : 0,
	"Fizzy" : 0,
	"Weird" : 0,
	"Sweet" : 0,
	"Flora" : 0,
	"Earthy" : 0,
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

func get_ingredient_names() -> Array[String]:
	var name_list: Array[String] = []
	for ingredient in ingredient_list:
		name_list.append(ingredient.details.name)
		
	return name_list

func _to_string() -> String:
	return name
