@tool
class_name Draggable
extends Area2D


@onready var debug_label: Label = $DebugLabel
@onready var drag_and_drop: DragAndDrop = $DragAndDrop
@onready var velocity_based_rotation: VelocityBasedRotation = $VelocityBasedRotation
@onready var outline_highlighter: OutlineHighlighter = $OutlineHighlighter

signal show_debug
signal hide_debug

func _ready() -> void:
	if not Engine.is_editor_hint():
		drag_and_drop.drag_started.connect(_on_drag_started)
		drag_and_drop.drag_canceled.connect(_on_drag_canceled)


func reset_after_dragging(starting_position: Vector2) -> void:
	velocity_based_rotation.enabled = false
	global_position = starting_position


func _on_drag_started() -> void:
	velocity_based_rotation.enabled = true


func _on_drag_canceled(starting_position: Vector2) -> void:
	reset_after_dragging(starting_position)


func _on_mouse_entered() -> void:
	if drag_and_drop.dragging:
		return
	
	outline_highlighter.highlight()
	z_index = 1
	
	show_debug.emit()


func _on_mouse_exited() -> void:
	if drag_and_drop.dragging:
		return
	
	outline_highlighter.clear_highlight()
	z_index = 0
	
	hide_debug.emit()
