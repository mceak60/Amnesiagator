extends Node

# 0 - 1 global value for sound effect volume
const SFX_VOLUME = .4

signal sfx(sfx: String)
signal sfx_random(sfx: String, random_pitch_variance: float, random_volume_offset: float)
signal sfx_random_repeated(sfx: String, n_times: float, rrandom_pitch_variance: float, random_volume_offset: float)
signal sfx_repeated(sfx: String, n_times: float)
