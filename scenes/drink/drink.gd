class_name Drink
extends Draggable

@export var ingredient_list: Array[Ingredient]
@export var INCREMENT_SIZE: int

var attribute_list = Dictionary().merged(Definitions.DEFAULT_ATTRIBUTES)

var max_capacity: int = 10
var current_capacity: int = 0

@onready var skin: Sprite2D = $Visuals/Skin
@onready var drink_visual: Sprite2D = $Visuals/DrinkLevel


@export_category("Visuals")
@export var drink_level: Vector2i: set = set_drink_level

func set_drink_level(coords: Vector2i) -> void:
	drink_level = coords
	if coords == null:
		return
	
	if not is_node_ready():
		await ready
	
	drink_visual.region_rect.position = Vector2(drink_level) * Bar.CELL_SIZE

func add_level(ingredient: Ingredient) -> void:
	drink_level.x = drink_level.x + INCREMENT_SIZE
	current_capacity += INCREMENT_SIZE
	pass

func can_add_more() -> bool:
	return current_capacity < max_capacity

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
			sum += 1
	return (sum == n)

func contains_n_from_ingredient_list(n: int, ingred_list: Array[String]) -> bool:
	var sum := 0
	for ingredient in ingred_list:
		if has_ingredient(ingredient):
			sum += 1
	return (sum == n)

func equals_sole_ingredient(ingred: String) -> bool:
	if num_total_ingredients() == 1 && has_ingredient(ingred):
		return true
	else:
		return false

func get_attributes_matched(attr_list: Array[String]) -> Array[String]:
	var out: Array[String] = []
	for attr in attr_list:
		if has_attribute(attr):
			out.append(attr)
	return out

func get_ingredients_matched(ingred_list: Array[String]) -> Array[String]:
	var out: Array[String] = []
	for ingred in ingred_list:
		if has_ingredient(ingred):
			out.append(ingred)
	return out

func priority_list_has(priority_list: Array, quality: String) -> bool:
	var has = false
	for index in priority_list:
		if index.has(quality):
			has = true
	
	return has

func get_attribute_priority_list() -> Array:
	var priority_list: Array = []
	
	while priority_list.size() < attribute_list.size():
		var max_list: Array[String] = []
		var max_count = 0
		for attribute in attribute_list:
			if attribute_list[attribute] > max_count && !priority_list_has(priority_list, attribute):
				max_list.clear()
				max_list.append(attribute)
				max_count = attribute_list[attribute]
			
			elif attribute_list[attribute] == max_count && !priority_list_has(priority_list, attribute):
				max_list.append(attribute)
			
		priority_list.append(max_list)
	return priority_list
	

func get_ingredient_priority_list() -> Array:
	var priority_list: Array = []
	var ingredient_dict: Dictionary
	for ingredient in ingredient_list:
		var ingredient_name = ingredient.details.name
		if ingredient_dict.has(ingredient_name):
			ingredient_dict[ingredient_name] += 1
		else:
			ingredient_dict[ingredient_name] = 1
	
	while priority_list.size() < ingredient_dict.size():
		var max_list: Array[String] = []
		var max_count = 0
		for ingredient in ingredient_dict:
			if ingredient_dict[ingredient] > max_count && !priority_list_has(priority_list, ingredient):
				max_list.clear()
				max_list.append(ingredient)
				max_count = ingredient_dict[ingredient]
			
			elif ingredient_dict[ingredient] == max_count && !priority_list_has(priority_list, ingredient):
				max_list.append(ingredient)
			
		priority_list.append(max_list)
	return priority_list
	
	
func get_combo_priority_list() -> Array:
	var priority_list: Array = []
	var ingredient_dict: Dictionary
	for ingredient in ingredient_list:
		var ingredient_name = ingredient.details.name
		if ingredient_dict.has(ingredient_name):
			ingredient_dict[ingredient_name] += 1
		else:
			ingredient_dict[ingredient_name] = 1
			
	var combo_dict = attribute_list.merged(ingredient_dict)
	#print("Combo_dict " + str(combo_dict))
	
	while priority_list.size() < combo_dict.size():
		var max_list: Array[String] = []
		var max_count = 1
		for item in combo_dict:
			#print(item + ":" + str(combo_dict[item]) + " " + str(priority_list_has(priority_list, item)))
			if combo_dict[item] > max_count && !priority_list_has(priority_list, item):
				#print("New max: " + item)
				max_list.clear()
				max_list.append(item)
				max_count = combo_dict[item]
			
			elif combo_dict[item] == max_count && !priority_list_has(priority_list, item):
				#print("Equal to: " + item)
				max_list.append(item)
			
		#print("Max: " + str(max))
		priority_list.append(max_list)
		#print("cleared max: " + str(max))
	return priority_list

func get_priority_of(priority_list: Array, quality: String) -> int:
	var priority_val: int = 99
	var index = 0
	for index_array in priority_list:
		if index_array.has(quality):
			priority_val = index
		index += 1
	
	return priority_val

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
