extends Control

@onready var journal_container: PanelContainer = $JournalContainer

enum State {
	HIDDEN,
	SHOWN
}

var current_state: State = State.HIDDEN

func _ready() -> void:
	hide_journal()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("journal"):
		match current_state:
			State.HIDDEN:
				show_journal()
			State.SHOWN:
				hide_journal()

func hide_journal() -> void:
	journal_container.hide()
	current_state = State.HIDDEN

func show_journal() -> void:
	journal_container.show()
	current_state = State.SHOWN
