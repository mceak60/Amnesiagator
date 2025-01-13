extends RichTextLabel

func _ready():
	var music_handler = get_parent()
	music_handler.track_updated.connect(update_text)
	self.text = ""
	
func update_text() -> void:
	var cur_track = get_parent().current_track + 1
	var cur_track_name = get_parent().current_track_name
	var label = "Track " + str(cur_track) + "\n" + cur_track_name
	self.text = label
