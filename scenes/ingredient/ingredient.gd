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
	
	skin.region_rect.position = Vector2(details.skin_coordinates) * Bar.CELL_SIZE

func get_sfx(trigger: SFX_Handler.SFX_Triggers) -> Array[SFX_Handler.SFX_Categories]:
	var sfx_pool: Array[SFX_Handler.SFX_Categories]
	match trigger:
		SFX_Handler.SFX_Triggers.INGREDIENT_PICKED_UP:
			sfx_pool = details.pickup_sfx
		SFX_Handler.SFX_Triggers.INGREDIENT_DROPPED:
			sfx_pool = details.drop_sfx
		_:
			assert(false, "SFX Error: Ingredient has incorrect trigger")
	
	return sfx_pool

func get_sfx_swapped(ingredient2: Ingredient) -> Array[SFX_Handler.SFX_Categories]:	
	var sfx_pool: Array[SFX_Handler.SFX_Categories]
	sfx_pool = details.pickup_sfx + details.drop_sfx + ingredient2.details.drop_sfx + ingredient2.details.pickup_sfx
	return sfx_pool

func _to_string() -> String:
	return details.name
