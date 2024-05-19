extends Node

var playlist:Array[AudioStreamPlayer] = []
var names_to_ids:Dictionary = {}

var prev_play:int = -1
var curr_play:int = -1

var change_tracks:bool = false

func _ready():
	var children = get_children()
	
	for ci in range(get_child_count()):
		if children[ci] is AudioStreamPlayer:
			names_to_ids[children[ci].name] = len(playlist)
			playlist.append(children[ci])
		else:
			print("Non-AudioStreamPlayer child detected at index %s.", ci)
		##
	##
##

func play_by_id(i:int):
	if curr_play != -1:
		if i == 1:
			playlist[i].volume_db = -80
			playlist[curr_play].fade_out(15)
		else:
			playlist[curr_play].fade_out(1)
		##
	##
	
	curr_play = i
	
	if curr_play == 1:
		playlist[curr_play].fade_in(15)
	else:
		playlist[curr_play].fade_in(1)
	##
##

func current_song() -> String:
	if curr_play == -1:
		return "none"
	##
	return names_to_ids.find_key(curr_play)
##

func play(song_name:String):
	if song_name in names_to_ids.keys():
		print(song_name, " is ID ", names_to_ids[song_name])
		play_by_id(names_to_ids[song_name])
	##
##

func stop_playing():
	playlist[curr_play].stop()
	curr_play = -1
##

func _finished_fade_out(song):
	song.stop()
##
