extends Button

func _ready():
	var music_button = Button.new()
	music_button.text = "♫"
	var input_color := Color(0,0,0,0)
	set_stylebox_color("normal", input_color)
	
	
func set_stylebox_color(style_box_type: String, color: Color):
	var stylebox_theme: StyleBoxFlat = self.get_theme_stylebox(style_box_type)
	stylebox_theme.bg_color = color
	stylebox_theme.border_color = color
	self.add_theme_stylebox_override(style_box_type, stylebox_theme)
	self.add_theme_stylebox_override("focus", stylebox_theme)
