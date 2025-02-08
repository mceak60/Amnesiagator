# Objects that have a Debug Label and an Outline Highlighter

@tool
class_name Interactable
extends Area2D

@onready var debug_label: Label = $DebugLabel
@onready var outline_highlighter: OutlineHighlighter = $OutlineHighlighter

signal show_debug
signal hide_debug

func _on_mouse_entered() -> void:
	outline_highlighter.highlight()
	z_index = 1
	show_debug.emit()

func _on_mouse_exited() -> void:
	outline_highlighter.clear_highlight()
	z_index = 0
	hide_debug.emit()
