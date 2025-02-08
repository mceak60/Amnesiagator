extends Label

@export var enabled: bool = true
@export var target: Area2D

func _ready():
	target.show_debug.connect(update_text)
	target.hide_debug.connect(clear_text)
	DialogueHandler.connect("dialogue_reading", Callable(self, "_on_dialogue_reading"))
	DialogueHandler.connect("dialogue_ready", Callable(self, "_on_dialogue_ready"))
	self.text = ""


func update_text() -> void:
	var label = ""
	if enabled:
		if "details" in target:
			label = str(target)
		else:
			label = array_to_string(target.ingredient_list)
	self.text = label


func clear_text() -> void:
	self.text = ""


func array_to_string(array: Array) -> String:
	var output_string = ""
	for i in range((len(array))):
		if i == 0:
			output_string += str(array[i])
		else:
			output_string += ", " + str(array[i])
	return output_string


func _on_dialogue_reading() -> void:
	enabled = false

func _on_dialogue_ready() -> void:
	enabled = true
