extends Node

signal dialogue_ready
signal dialogue_reading
signal dialogue_finished

enum State {
	READY,
	READING,
	FINISHED
}
