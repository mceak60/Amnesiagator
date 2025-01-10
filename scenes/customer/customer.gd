@tool
class_name Customer
extends Draggable

@export var details: CustomerDetails: set = set_details
@onready var skin: Sprite2D = $Visuals/Skin

func set_details(value: CustomerDetails) -> void:
	details = value
	
	if value == null:
		return
	
	if not is_node_ready():
		await ready
	
	skin.region_rect.position = Vector2(details.skin_coordinates) * Arena.CELL_SIZE

func _on_mouse_entered() -> void:
	outline_highlighter.highlight()
	z_index = 1


func _on_mouse_exited() -> void:
	outline_highlighter.clear_highlight()
	z_index = 0

func _to_string() -> String:
	return details.name
