class_name IngredientDetails
extends Resource

enum Quality {CHEAP, AVERAGE, EXQUISITE}

const QUALITY_COLORS := {
	Quality.CHEAP: Color("124a2e"),
	Quality.AVERAGE: Color("1c527c"),
	Quality.EXQUISITE: Color("ab0979"),
}

@export var name: String

@export_category("Data")
@export var quality: Quality
@export var gold_cost := 1
@export var trait_list: Array[String]

@export_category("Visuals")
@export var skin_coordinates: Vector2i


func _to_string() -> String:
	return name
