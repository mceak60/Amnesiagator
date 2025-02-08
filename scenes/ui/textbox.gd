extends CanvasLayer

const CHAR_READ_RATE = 0.05

@onready var textbox_container: MarginContainer = $TextboxContainer
@onready var text_label: Label = $TextboxContainer/MarginContainer/HBoxContainer/Text
@onready var end_symbol: Label = $TextboxContainer/MarginContainer/HBoxContainer/End
@onready var tween = get_tree().create_tween()

enum State {
	READY,
	READING,
	FINISHED
}


var current_state = State.READY
var text_queue = []


func _ready() -> void:
	if not is_node_ready():
		await ready
	print("Starting State: READY")
	hide_textbox()


func _process(_delta: float) -> void:
	match current_state:
		State.READY:
			if !text_queue.is_empty():
				display_text()
		State.READING:
			if Input.is_action_just_pressed("ui_accept"):
				tween.kill()
				text_label.visible_characters = -1
				end_symbol.text = "↵"
				change_state(State.FINISHED)
		State.FINISHED:
			if Input.is_action_just_pressed("ui_accept"):
				change_state(State.READY)
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
	change_state(State.READING)
	show_textbox()
	tween.tween_property(text_label, "visible_characters", len(next_text), len(next_text) * CHAR_READ_RATE).from(0).finished
	tween.connect("finished", on_tween_finished)
	end_symbol.text = ". . ."


func on_tween_finished():
	end_symbol.text = "↵"
	change_state(State.FINISHED)

func change_state(next_state: State) -> void:
	current_state = next_state
	match current_state:
		State.READY:
			print("Changing state to: READY")
			DialogueHandler.emit_signal("dialogue_ready")
		State.READING:
			print("Changing state to: READING")
			DialogueHandler.emit_signal("dialogue_reading")
		State.FINISHED:
			print("Changing state to: FINISHED")
			DialogueHandler.emit_signal("dialogue_finished")
