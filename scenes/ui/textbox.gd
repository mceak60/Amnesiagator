extends Control

const CHAR_READ_RATE = 0.05

@onready var textbox_container: MarginContainer = $TextboxContainer
@onready var text_label: Label = $TextboxContainer/MarginContainer/HBoxContainer/Text
@onready var end_symbol: RichTextLabel = $TextboxContainer/MarginContainer/HBoxContainer/End
@onready var tween = get_tree().create_tween()


var text_queue = []
var state = DialogueHandler.State


func _ready() -> void:
	hide_textbox()


func _process(_delta: float) -> void:
	match DialogueHandler.current_state:
		state.READY:
			if !text_queue.is_empty():
				display_text()
		state.READING:
			if Input.is_action_just_pressed("ui_accept"):
				tween.kill()
				text_label.visible_characters = -1
				end_symbol.text = "[wave]↵[wave]"
				DialogueHandler.change_state(state.FINISHED)
		state.FINISHED:
			if Input.is_action_just_pressed("ui_accept"):
				DialogueHandler.change_state(state.READY)
				hide_textbox()


func queue_text(next_text: String):
	text_queue.push_back(next_text)


func hide_textbox() -> void:
	text_label.text = ""
	textbox_container.hide()


func show_textbox() -> void:
	textbox_container.show()


func display_text() -> void:
	tween = get_tree().create_tween()
	var next_text = text_queue.pop_front()
	text_label.text = next_text
	DialogueHandler.change_state(state.READING)
	show_textbox()
	tween.tween_property(text_label, "visible_characters", len(next_text), len(next_text) * CHAR_READ_RATE).from(0).finished
	tween.connect("finished", on_tween_finished)
	end_symbol.text = "[wave]. . .[wave]"


func on_tween_finished():
	end_symbol.text = "[wave]↵[wave]"
	DialogueHandler.change_state(state.FINISHED)
