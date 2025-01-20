extends AudioStreamPlayer

@export var track_list : Array[AudioStream]
var name_list : Array[String]

var current_track := 0
var first_click = true

signal track_updated 

func _ready() -> void:
	var music_button = $"../MusicButton"
	music_button.pressed.connect(play_next_track)
	var name_list_tmp = track_list.map(func(track): return track.resource_path.get_file().get_basename())
	name_list.assign(name_list_tmp)

func get_current_track() -> int:
	return current_track

func get_current_track_name() -> String:
	return name_list[current_track]
	
func increment_track() -> void:
	if current_track == 11:
		current_track = 0
	else:
		current_track += 1 

func play_track(track_num: int) -> void:
	stop()
	stream = track_list[track_num]
	play()

func randomize_track() -> void:
	var rng = RandomNumberGenerator.new()
	current_track = rng.randi_range(0, track_list.size()-1)
	
func play_next_track() -> void:
	if first_click:
		randomize_track()
		first_click = false
	
	play_track(current_track)
	track_updated.emit()
	increment_track()
