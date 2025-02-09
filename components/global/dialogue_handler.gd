extends Node

signal dialogue_ready
signal dialogue_reading
signal dialogue_finished

enum State {
	READY,
	READING,
	FINISHED
}

var current_state: State = State.READY

func change_state(next_state: State) -> void:
	current_state = next_state
	match current_state:
		State.READY:
			print("Changing state to: READY")
			dialogue_ready.emit()
		State.READING:
			print("Changing state to: READING")
			dialogue_reading.emit()
		State.FINISHED:
			print("Changing state to: FINISHED")
			dialogue_finished.emit()
