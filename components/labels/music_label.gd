extends RichTextLabel

@onready var music_handler = $"../MusicHandler"

func _ready():
	music_handler.track_updated.connect(update_text)
	self.text = ""
	
func update_text() -> void:
	var cur_track = music_handler.get_current_track() + 1
	var cur_track_name = music_handler.get_current_track_name()
	var label = "Track " + str(cur_track) + "\n" + cur_track_name
	self.text = label
