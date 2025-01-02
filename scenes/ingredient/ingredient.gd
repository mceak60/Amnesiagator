@tool
class_name Ingredient
extends Draggable

@export var details : IngredientDetails : set = set_details

@onready var skin: Sprite2D = $Visuals/Skin

func set_details(value: IngredientDetails) -> void:
	details = value
	
	if value == null:
		return
	
	if not is_node_ready():
		await ready
	
	skin.region_rect.position = Vector2(details.skin_coordinates) * Arena.CELL_SIZE
