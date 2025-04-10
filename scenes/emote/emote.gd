@tool
class_name Emote
extends Node2D

enum Emotion {
	BLANK,
	ANGRY,
	LIKE,
	LOVE,
	STAR,
	EXCLAIM1,
	EXCLAIM2,
	EXCLAIM3,
	QUESTION,
	EXCLAIM_QUESTION,
	ELLIPSES,
	ZZZ,
	HAPPY,
	SAD,
	MEH,
	SHOCKED,
	DEAD
}

@export var current_emotion: Emotion: set = set_emote

@onready var emotion_skin: Sprite2D = $Bubble

func _ready():
	set_emote(Emotion.BLANK)

func set_emote(_emotion: Emotion) -> void:
	current_emotion = _emotion
	if not is_node_ready():
		await ready

	var emote_coords: Vector2
	match _emotion:
		Emotion.BLANK:
			emote_coords = Vector2(0, 0)
		Emotion.ANGRY:
			emote_coords = Vector2(1, 0)
		Emotion.LIKE:
			emote_coords = Vector2(2, 0)
		Emotion.LOVE:
			emote_coords = Vector2(3, 0)
		Emotion.STAR:
			emote_coords = Vector2(0, 1)
		Emotion.EXCLAIM1:
			emote_coords = Vector2(1, 1)
		Emotion.EXCLAIM2:
			emote_coords = Vector2(2, 1)
		Emotion.EXCLAIM3:
			emote_coords = Vector2(3, 1)
		Emotion.QUESTION:
			emote_coords = Vector2(0, 2)
		Emotion.EXCLAIM_QUESTION:
			emote_coords = Vector2(1, 2)
		Emotion.ELLIPSES:
			emote_coords = Vector2(2, 2)
		Emotion.ZZZ:
			emote_coords = Vector2(3, 2)
		Emotion.HAPPY:
			emote_coords = Vector2(0, 3)
		Emotion.SAD:
			emote_coords = Vector2(1, 3)
		Emotion.MEH:
			emote_coords = Vector2(2, 3)
		Emotion.SHOCKED:
			emote_coords = Vector2(3, 3)
		Emotion.DEAD:
			emote_coords = Vector2(0, 4)
	
	print(_emotion)
	#print(emote_coords)
	emotion_skin.region_rect.position = emote_coords * Bar.CELL_SIZE
