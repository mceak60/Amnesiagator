extends Node

var sfx_folders = ["bottle_cap", "clink", "fizz", "gluggle", "ice", "jar", "scrape", "slosh", "spin", "thud", "triple_tap", "uncork"]

var sfx_dict = {
	"bottle_cap" : null,
	"clink" : null,
	"fizz" : null,
	"gluggle" : null,
	"ice" : null,
	"jar" : null,
	"scrape" : null,
	"slosh" : null,
	"spin" : null,
	"thud" : null,
	"triple_tap" : null,
	"uncork" : null
} 

func _ready() -> void:
	SignalBus.sfx.connect(play_sfx)
	SignalBus.sfx_random.connect(play_sfx_random)
	SignalBus.sfx_repeated.connect(play_sfx_repeated)
	SignalBus.sfx_random_repeated.connect(play_sfx_random_repeated)
	var loaded_sfx_files := sfx_folders.map(_load_sfx_files)
	for i in range(loaded_sfx_files.size()):
		sfx_dict[sfx_folders[i]] = loaded_sfx_files[i]

	for x in sfx_dict.keys():
		print(x)
		print(sfx_dict[x])
		#play_sfx(x)
		#await get_tree().create_timer(3).timeout

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

func play_sfx(sfx_name: String) -> void:
	play_sfx_audio_stream(sfx_dict[sfx_name], linear_to_db(SignalBus.SFX_VOLUME))

func play_sfx_random(sfx_name: String, rand_pitch: float, rand_vol: float) -> void:
	var rand_sfx_stream = sfx_dict[sfx_name]
	rand_sfx_stream.set_random_pitch(rand_pitch)
	rand_sfx_stream.set_random_pitch(rand_vol)
	play_sfx_audio_stream(rand_sfx_stream, linear_to_db(SignalBus.SFX_VOLUME))

func play_sfx_repeated(sfx_name: String, n_times: int) -> void:
	for i in range(n_times):
		play_sfx(sfx_name)

func play_sfx_random_repeated(sfx_name: String, n_times: int, rand_pitch: float, rand_vol: float) -> void:
	for i in range(n_times):
		play_sfx_random(sfx_name, rand_pitch, rand_vol)
