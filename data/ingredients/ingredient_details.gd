class_name IngredientDetails
extends Resource

enum Quality {CHEAP, AVERAGE, EXQUISITE}

enum Ingredient_Type {BASE, MIXER, GARNISH}

const DEFAULT_ATTRIBUTES := {
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
	"Sleepy" : 0,
	"Boring" : 0,
}

const QUALITY_COLORS := {
	Quality.CHEAP: Color("124a2e"),
	Quality.AVERAGE: Color("1c527c"),
	Quality.EXQUISITE: Color("ab0979"),
}


@export var name: String

@export_category("Data")
@export var quality: Quality
@export var ingredient_type: Ingredient_Type
@export var gold_cost := 1
@export var attribute_list: Dictionary = DEFAULT_ATTRIBUTES

@export_category("Visuals")
@export var skin_coordinates: Vector2i

# Each ingredient may have multiple sound effects (randomly chosen)
@export_category("Sound Effects")
@export var pickup_sfx: Array[SFX_Handler.SFX_Categories]
@export var drop_sfx: Array[SFX_Handler.SFX_Categories]
@export var add_to_drink_sfx: Array[SFX_Handler.SFX_Categories]

func _to_string() -> String:
	return name
