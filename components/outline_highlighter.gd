class_name OutlineHighlighter
extends Node

@export var visuals: CanvasGroup
@export var outline_color: Color
@export var enabled: bool = true
@export_range(1, 10) var outline_thickness: int


func _ready() -> void:
	DialogueHandler.connect("dialogue_reading", Callable(self, "_on_dialogue_reading"))
	DialogueHandler.connect("dialogue_ready", Callable(self, "_on_dialogue_ready"))
	visuals.material.set_shader_parameter("line_color", outline_color)


func clear_highlight() -> void:
	visuals.material.set_shader_parameter("line_thickness", 0)


func highlight() -> void:
	if enabled:
		visuals.material.set_shader_parameter("line_thickness", outline_thickness)


func _on_dialogue_reading() -> void:
	enabled = false

func _on_dialogue_ready() -> void:
	enabled = true
