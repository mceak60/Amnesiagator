@tool
class_name Customer
extends Interactable

signal customer_clicked(customer: Customer)

@export var details: CustomerDetails: set = set_details
@onready var skin: Sprite2D = $Visuals/Skin
var hovered: bool = false
@onready var emote: Node2D = $Emote

func set_details(value: CustomerDetails) -> void:
	details = value
	
	if value == null:
		return
	
	if not is_node_ready():
		await ready
	
	skin.region_rect.position = Vector2(details.skin_coordinates) * Bar.CELL_SIZE


func get_sfx(_trigger: SFX_Handler.SFX_Triggers) -> Array[SFX_Handler.SFX_Categories]:
	# Currently static
	return [SFX_Handler.SFX_Categories.SIT, SFX_Handler.SFX_Categories.KNOCK]


func get_sfx_drink_served(_drink: Drink) -> Array[SFX_Handler.SFX_Categories]:
	# Currently does not interact with current drink, but it could
	return [SFX_Handler.SFX_Categories.SIP, SFX_Handler.SFX_Categories.BURP]


func get_sfx_feedback(_feedback: Puzzle.Result) -> Array[SFX_Handler.SFX_Categories]:
	# Currently static
	return [SFX_Handler.SFX_Categories.SHAKE, SFX_Handler.SFX_Categories.BURP]

func set_emotion(result: Puzzle.Result) -> void:
	if result == Puzzle.Result.GREAT_SUCCESS:
		emote.set_emote(Emote.Emotion.LOVE)
	elif result == Puzzle.Result.SUCCESS:
		emote.set_emote(Emote.Emotion.LIKE)
	elif result == Puzzle.Result.EHHH:
		emote.set_emote(Emote.Emotion.QUESTION)
	elif result == Puzzle.Result.FAILURE:
		emote.set_emote(Emote.Emotion.ANGRY)
	emote.show()


func _on_mouse_entered() -> void:
	outline_highlighter.highlight()
	hovered = true
	z_index = 1
	show_debug.emit()


func _on_mouse_exited() -> void:
	outline_highlighter.clear_highlight()
	hovered = false
	z_index = 0
	hide_debug.emit()


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("select"):
		customer_clicked.emit(self)


func _to_string() -> String:
	return details.name
