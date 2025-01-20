class_name SFX_Handler
extends Node

# signal sfx(sfx: String)
# signal sfx_random(sfx: String, random_pitch_variance: float, random_volume_offset: float)
# signal sfx_random_repeated(sfx: String, n_times: float, rrandom_pitch_variance: float, random_volume_offset: float)
# signal sfx_repeated(sfx: String, n_times: float)

enum SFX_Triggers {
	INGREDIENT_PICKED_UP,
	INGREDIENT_DROPPED,
	INGREDIENT_SWAPPED,
	INGREDIENT_ADDED_TO_DRINK,
	DRINK_PICKED_UP,
	DRINK_FULL,
	DRINK_DROPPED,
	DRINK_SERVED,
	DRINK_TRASHED,
	CUSTOMER_ENTERED,
	CUSTOMER_FEEDBACK,
	CUSTOMER_LEFT,
	GOLD_ADDED,
	JUKEBOX_TURNED_ON,
	JUKEBOX_TURNED_OFF,
}

const SFX_VOLUME = .4

enum SFX_Categories {
	BOTTLE_CAP,
	CLINK,
	FIZZ,
	GLUGGLE,
	ICE,
	JAR,
	SCRAPE,
	SLOSH,
	SPIN,
	THUD,
	TRIPLE_TAP,
	UNCORK
}

var sfx_dict := {}
var sfx_folders := []

signal trigger_sfx(trigger: SFX_Triggers, items: Array, n_times: int, rand_pitch_variance: float, rand_volume_offset: float)

func _ready() -> void:
	self.trigger_sfx.connect(trigger_sfx_func)
	
	sfx_folders = SFX_Categories.keys().map(func(val: String): return val.to_lower())
	print(sfx_folders)
	
	var loaded_sfx_files := sfx_folders.map(_load_sfx_files)
	for i in range(loaded_sfx_files.size()):
		sfx_dict[sfx_folders[i]] = loaded_sfx_files[i]

	#for x in sfx_dict.keys():
		#print(x)
		#print(sfx_dict[x])

func _load_sfx_files(subfolder: String) -> AudioStreamRandomizer:
	var audio_stream_random = AudioStreamRandomizer.new()

	for file_path in DirAccess.get_files_at("res://assets/sfx/" + subfolder + "/"):  
		# print(file_path)
		if file_path.get_extension() == "wav":  
			audio_stream_random.add_stream(-1, load("res://assets/sfx/" + subfolder + "/" + file_path))
	
	audio_stream_random.playback_mode = AudioStreamRandomizer.PLAYBACK_RANDOM
	return audio_stream_random
	
	#audio_stream_random.set_random_pitch(.1)
	#audio_stream_random.set_random_volume_offset_db(.5)
	
	#for x in range(10):
	#	play_R(audio_stream_random, linear_to_db(.2))

func play_sfx_audio_stream(stream: AudioStreamRandomizer, volume_db: float = 0.0, pitch_scale: float = 1.0) -> void:
	var audio_stream_player := AudioStreamPlayer.new()
	
	self.add_child(audio_stream_player)
	audio_stream_player.bus = "Effects"
	audio_stream_player.stream = stream
	audio_stream_player.volume_db = volume_db
	audio_stream_player.pitch_scale = pitch_scale
	audio_stream_player.play()
	audio_stream_player.finished.connect(audio_stream_player.queue_free)

func play_sfx_with_random(sfx_category: SFX_Categories, rand_pitch: float, rand_vol: float) -> void:
	var rand_sfx_stream = sfx_dict[sfx_category]
	rand_sfx_stream.set_random_pitch(rand_pitch)
	rand_sfx_stream.set_random_pitch(rand_vol)
	play_sfx_audio_stream(rand_sfx_stream, linear_to_db(SFX_VOLUME))
 
func trigger_sfx_func(trigger: SFX_Triggers, items: Array = [], n_times: int = 1, rand_pitch_variance: float = 1.0, rand_volume_offset: float = 0.0) -> void:
	# Assert sfx_params are correct
	check_sfx_params(n_times, rand_pitch_variance, rand_volume_offset)
	check_sfx_input_items(trigger, items)
	var sfx_to_play: SFX_Categories

	match trigger:
		SFX_Triggers.INGREDIENT_PICKED_UP:
			pass
		SFX_Triggers.INGREDIENT_DROPPED:
			pass
		SFX_Triggers.INGREDIENT_SWAPPED:
			pass
		SFX_Triggers.INGREDIENT_ADDED_TO_DRINK:
			pass
		SFX_Triggers.DRINK_PICKED_UP:
			pass
		SFX_Triggers.DRINK_FULL:
			pass
		SFX_Triggers.DRINK_DROPPED:
			pass
		SFX_Triggers.DRINK_SERVED:
			pass
		SFX_Triggers.DRINK_TRASHED:
			pass
		SFX_Triggers.CUSTOMER_ENTERED:
			pass
		SFX_Triggers.CUSTOMER_FEEDBACK:
			pass
		SFX_Triggers.CUSTOMER_LEFT:
			pass
		SFX_Triggers.GOLD_ADDED:
			pass
		SFX_Triggers.JUKEBOX_TURNED_ON:
			pass
		SFX_Triggers.JUKEBOX_TURNED_OFF:
			pass
		var result:
			assert(false,"SFX Error: Unknown trigger" + str(result))

	pass

func check_sfx_params(n_times: int, rand_pitch_variance: float, rand_volume_offset: float) -> void:	
	assert(n_times > 0, "SFX Error: N_Times < 0")
	assert(rand_pitch_variance >= 0 && rand_pitch_variance <= 1, "SFX Error: Random_Pitch_Variance not between 0 and 1")
	assert(rand_volume_offset >= 0 && rand_volume_offset <= 1, "SFX Error: Random_Pitch_Variance not between 0 and 1")

func check_sfx_input_items(trigger: SFX_Triggers, items: Array) -> void:
	var test: bool
	match trigger:
		SFX_Triggers.INGREDIENT_PICKED_UP:
			test = (items[0] is Ingredient && items.size() == 1)
			assert_sfx_input_items(test, trigger, items)		
		SFX_Triggers.INGREDIENT_DROPPED:
			test = (items[0] is Ingredient && items.size() == 1)
			assert_sfx_input_items(test, trigger, items)		
		SFX_Triggers.INGREDIENT_SWAPPED:
			test = (items[0] is Ingredient && items.size() == 1)
			assert_sfx_input_items(test, trigger, items)		
		SFX_Triggers.INGREDIENT_ADDED_TO_DRINK:
			test = (items[0] is Ingredient && items[1] is Drink && items.size() == 2)
			assert_sfx_input_items(test, trigger, items)		
		SFX_Triggers.DRINK_PICKED_UP:
			test = (items[0] is Drink && items.size() == 1)
			assert_sfx_input_items(test, trigger, items)		
		SFX_Triggers.DRINK_FULL:
			test = (items[0] is Drink && items.size() == 1)
			assert_sfx_input_items(test, trigger, items)		
		SFX_Triggers.DRINK_DROPPED:
			test = (items[0] is Drink && items.size() == 1)
			assert_sfx_input_items(test, trigger, items)		
		SFX_Triggers.DRINK_SERVED:
			test = (items[0] is Drink && items[1] is Customer && items.size() == 2)
			assert_sfx_input_items(test, trigger, items)		
		SFX_Triggers.DRINK_TRASHED:
			test = (items[0] is Drink && items.size() == 1)
			assert_sfx_input_items(test, trigger, items)		
		SFX_Triggers.CUSTOMER_ENTERED:
			test = (items[0] is Customer && items.size() == 1)
			assert_sfx_input_items(test, trigger, items)		
		SFX_Triggers.CUSTOMER_FEEDBACK:
			test = (items[0] is Customer && items[1] is Puzzle.Result && items.size() == 2)
			assert_sfx_input_items(test, trigger, items)		
		SFX_Triggers.CUSTOMER_LEFT:
			test = (items[0] is Customer && items.size() == 1)
			assert_sfx_input_items(test, trigger, items)		
		SFX_Triggers.GOLD_ADDED:
			test = (items == [])
			assert_sfx_input_items(test, trigger, items)		
		SFX_Triggers.JUKEBOX_TURNED_ON:
			test = (items == [])
			assert_sfx_input_items(test, trigger, items)		
		SFX_Triggers.JUKEBOX_TURNED_OFF:
			test = (items == [])
			assert_sfx_input_items(test, trigger, items)		
		var result:
			assert(false,"SFX Error: Unknown trigger" + str(result))

func assert_sfx_input_items(cond: bool, trigger: SFX_Triggers, items: Array) -> void:
	assert(cond, "SFX Error: Passed invalid items " + str(items) + " for trigger " + str(trigger))
