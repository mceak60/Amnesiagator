@tool
class_name Drink
extends Draggable

@export var ingredient_list: Array[Ingredient]

#SK 1/16 - HIGH PRIORITY - We really need to make the attribute list a constant somewhere, otherwise it has to be updated across all classes when one attribute is added.
var attribute_list = {
	"Heat": 0,
	"Cold": 0,
	"Fruity": 0,
	"Metallic": 0,
	"Electricity": 0,
	"Fizzy": 0,
	"Weird": 0,
	"Sweet": 0,
	"Flora": 0,
	"Earthy": 0,
	"Sleepy": 0,
	"Boring": 0,
}

@onready var skin: Sprite2D = $Visuals/Skin

@export_category("Visuals")
@export var skin_coordinates: Vector2i: set = set_skin

func set_skin(coords: Vector2i) -> void:
	skin_coordinates = coords
	
	if coords == null:
		return
	
	if not is_node_ready():
		await ready
	
	skin.region_rect.position = Vector2(skin_coordinates) * Bar.CELL_SIZE

func get_ingredient_list() -> Array[Ingredient]:
	return ingredient_list

func get_attribute_list() -> Dictionary:
	return attribute_list

func get_ingredient_names() -> Array[String]:
	var name_list: Array[String] = []
	for ingredient in ingredient_list:
		name_list.append(ingredient.details.name)
		
	return name_list

func has_ingredient(ingredient: String) -> bool:
	return get_ingredient_names().has(ingredient)

func has_attribute(attribute: String) -> bool:
	return attribute_list[attribute] > 0 
	
func num_of_attribute(attribute: String) -> int:
	if has_attribute(attribute):
		return attribute_list[attribute]
	else:
		return 0

func num_total_attributes() -> int:
	var sum := 0 
	for attr in attribute_list:
		sum += attribute_list[attr]
	return sum

func num_total_ingredients() -> int:
	return get_ingredient_names().size()

func contains_n_from_attribute_list(n: int, attr_list: Array[String]) -> bool:
	var sum := 0
	for attr in attr_list:
		if has_attribute(attr):
			sum +=1
	return (sum == n)

func contains_n_from_ingredient_list(n: int, ingred_list: Array[String]) -> bool:
	var sum := 0
	for ingredient in ingred_list:
		if has_ingredient(ingredient):
			sum +=1
	return (sum == n)

func equals_sole_ingredient(ingred: String) -> bool:
	if num_total_ingredients() == 1 && has_ingredient(ingred):
		return true
	else:
		return false

func get_attributes_matched(attr_list: Array[String]) -> Array[String]:
	var out : Array[String] = []
	for attr in attr_list:
		if has_attribute(attr):
			out.append(attr)
	return out

func get_ingredients_matched(ingred_list: Array[String]) -> Array[String]:
	var out : Array[String] = []
	for ingred in ingred_list:
		if has_ingredient(ingred):
			out.append(ingred)
	return out

func get_sfx(_trigger: SFX_Handler.SFX_Triggers) -> Array[SFX_Handler.SFX_Categories]:
	# Currently static
	return [SFX_Handler.SFX_Categories.THUD, SFX_Handler.SFX_Categories.SLOSH, SFX_Handler.SFX_Categories.CLINK]

func get_sfx_ingredient_added(ingredient: Ingredient) -> Array[SFX_Handler.SFX_Categories]:
	# Currently does not interact with current drink, but it could
	return ingredient.details.add_to_drink_sfx

func _on_mouse_entered() -> void:
	if drag_and_drop.dragging:
		return
	
	outline_highlighter.highlight()
	z_index = 3
	
	show_debug.emit()
	
func _on_mouse_exited() -> void:
	if drag_and_drop.dragging:
		return
	
	outline_highlighter.clear_highlight()
	z_index = 3
	
	hide_debug.emit()

func empty() -> void:
	ingredient_list.clear()
	for attribute in attribute_list:
		attribute_list[attribute] = 0

func _to_string() -> String:
	return str(attribute_list)
