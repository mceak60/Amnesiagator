extends Control

@onready var journal_container: PanelContainer = $JournalContainer
@onready var button: Button = $Button

enum State {
	HIDDEN,
	SHOWN
}

enum Page {
	CUSTOMERS,
	INGREDIENTS
}

var current_state: State = State.HIDDEN
var current_page: Page = Page.CUSTOMERS

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
	button.hide()
	current_state = State.HIDDEN

func show_journal() -> void:
	journal_container.show()
	button.show()
	current_state = State.SHOWN


func _on_button_pressed() -> void:
	match current_page:
			Page.CUSTOMERS:
				journal_container.get_child(0).hide()
				journal_container.get_child(1).show()
				current_page = Page.INGREDIENTS
			Page.INGREDIENTS:
				journal_container.get_child(1).hide()
				journal_container.get_child(0).show()
				current_page = Page.CUSTOMERS
