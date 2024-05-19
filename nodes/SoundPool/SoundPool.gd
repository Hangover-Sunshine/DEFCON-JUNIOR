@tool
extends Node
## A pool for individual sounds in a stereo manner, meant for short sounds. If you have sounds
## that could last a while, then consider using a SoundQueuePool instead.
class_name SoundPool

@export_group("Random Sounds")
## Prevent the same sound from playing twice in a row.
@export var stopRepeatingSounds:bool = false

## The max attempts to try and select a sound in the event one is already playing.
@export var maxAttempts:int = 5

@export_group("Pitch Randomization")
@export var randomizePitch:bool = false
@export var allowPitchReroll:bool = false
@export var pitchRandomization:Vector2 = Vector2(0.8, 1.2)
@export var threshold:float = 0.1

var m_prev_index:int = -1
var m_audio_stream_player:Array[AudioStreamPlayer]
var m_last_pitch:float = 0

func _ready():
	var children = get_children()
	
	for ci in range(get_child_count()):
		if children[ci] is AudioStreamPlayer:
			m_audio_stream_player.append(children[ci])
		else:
			print("Non-AudioStreamPlayer child detected at index %s.", ci)
		##
	##
##

func play_random_sound() -> bool:
	var index:int = randi() % len(m_audio_stream_player)
	var attempts:int = 0
	
	var pitch = 1
	if randomizePitch:
		pitch = randf_range(pitchRandomization.x, pitchRandomization.y)
		if allowPitchReroll:
			while abs(pitch - m_last_pitch) < threshold:
				randomize()
				pitch = randf_range(pitchRandomization.x, pitchRandomization.y)
			##
			m_last_pitch = pitch
		##
	##
	
	if stopRepeatingSounds:
		while (index == m_prev_index or m_audio_stream_player[index].playing) and attempts < maxAttempts:
			attempts += 1
			index = randi() % len(m_audio_stream_player)
		##
		
		if m_audio_stream_player[index].playing == false:
			m_audio_stream_player[index].pitch_scale = pitch
			m_audio_stream_player[index].play()
			m_prev_index = index
			return true
		##
	else:
		while m_audio_stream_player[index].playing and attempts < maxAttempts:
			attempts += 1
			index = randi() % len(m_audio_stream_player)
		##
		
		if m_audio_stream_player[index].playing == false:
			m_audio_stream_player[index].pitch_scale = pitch
			m_audio_stream_player[index].play()
			return true
		##
	##
	
	return false
##

func play_sound(index:int) -> bool:
	var pitch = 1
	if randomizePitch:
		pitch = randf_range(pitchRandomization.x, pitchRandomization.y)
		if allowPitchReroll:
			while abs(pitch - m_last_pitch) < threshold:
				randomize()
				pitch = randf_range(pitchRandomization.x, pitchRandomization.y)
			##
			m_last_pitch = pitch
		##
	##
	
	if m_audio_stream_player[index].playing == false:
		m_audio_stream_player[index].pitch_scale = pitch
		m_audio_stream_player[index].play()
		return true
	##
	
	return false
##
