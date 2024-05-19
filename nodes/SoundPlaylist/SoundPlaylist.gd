@tool
extends Node
class_name SoundPlaylist

var m_audio_stream_player:Array[AudioStreamPlayer]

var curr_played:int = 0

func _ready():
	var children = get_children()
	
	for ci in range(get_child_count()):
		if children[ci] is AudioStreamPlayer:
			m_audio_stream_player.append(children[ci])
		else:
			print("Non-AudioStreamPlayer2D child detected at index %s.", ci)
		##
	##
##

func play_at(i):
	if i > m_audio_stream_player.size():
		return
	##
	curr_played = i
	m_audio_stream_player[i].play()
##

func raise_db(vol):
	m_audio_stream_player[curr_played].volume_db = vol
##
