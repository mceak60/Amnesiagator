extends Node2D

@export var track_list : Array[AudioStream]
var current_track := 0
var current_track_name := "None"
var first_click = true

signal track_updated 

func _ready() -> void:
	var music_button = get_node("MusicButton")
	music_button.pressed.connect(play_next_track)

func play_next_track() -> void:
	if first_click:
		pass
		var rng = RandomNumberGenerator.new()
		current_track = rng.randi_range(1, 11)
		first_click = false
	
	stop()
	stream = track_list[current_track]
	play()
	current_track_name = stream.resource_path.get_file().get_basename()
	track_updated.emit()
	if current_track == 11:
		current_track = 0
	else:
		current_track += 1 
