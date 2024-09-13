extends Node2D

@onready var pause_canvas_layer = $PauseCanvasLayer
@onready var flash_canvas_layer = $FlashCanvasLayer

var bus = null

var player_lost:bool = false
var player_won:bool = false
var next_scene:bool = false

var curr_level:int = 0
var player_left_save:bool = false
var stop_pause:bool = false

func _ready():
	GlobalSignals.connect("scene_loaded", to_free)
	GlobalSignals.connect("level_complete", _level_complete)
	GlobalSignals.connect("player_died", _player_died)
	GlobalSignals.connect("scene_loaded", _scene_loaded)
	
	if FileAccess.file_exists("user://level.save"):
		var file = FileAccess.open("user://level.save", FileAccess.READ)
		var json_string = file.get_as_text()
		var json = JSON.new()
		var res = json.parse(json_string)
		if res != OK:
			print("error on:", json.get_error_message(), " on line ", json.get_error_line())
			return
		##
		curr_level = json.get_data()["level"]
		player_left_save = json.get_data()["player_left"]
	##
	
	bus = AudioServer.get_bus_index("Music")
	
	$GameRoot.curr_level = curr_level
	$GameRoot.load_level()
	$GameRoot.late_ready()
##

func _process(_delta):
	if flash_canvas_layer.flashed and next_scene == false:
		if player_lost:
			GlobalSignals.emit_signal("load_scene", "menus/menu_gameover")
		##
		if player_won:
			if curr_level == 6:
				GlobalSignals.emit_signal("load_scene", "menus/faux_menu/hub_faux")
			else:
				GlobalSignals.emit_signal("load_scene", "menus/menu_cutscene")
			##
		##
		next_scene = true
	##
##

func _input(event):
	if event.is_action_pressed("pause") and stop_pause == false:
		unpause_pause()
		$PauseCanvasLayer/HubPause.to_pause()
	##
	
	if Input.is_action_just_pressed("escape") and GlobalSettings.os_type == "Web":
		GlobalSettings.FullScreen = false
	##
##

func _level_complete():
	get_tree().paused = true
	flash_canvas_layer.visible = true
	if GlobalSettings.FlashesOff:
		flash_canvas_layer.no_flash_flash()
	else:
		flash_canvas_layer.flash()
	##
	player_won = true
	save_game()
##

func _player_died():
	get_tree().paused = true
	flash_canvas_layer.visible = true
	if GlobalSettings.FlashesOff:
		flash_canvas_layer.no_flash_flash()
	else:
		flash_canvas_layer.player_dead_flash()
	##
	player_lost = true
	save_game()
	AudioServer.add_bus_effect(bus, AudioEffectLowPassFilter.new())
	if GlobalPlaylist.current_song() != "MainTheme":
		GlobalPlaylist.play("MainTheme")
	##
##

func _scene_loaded(scene_name):
	if scene_name != name:
		if AudioServer.get_bus_effect_count(bus) > 0 and player_lost == false:
			AudioServer.remove_bus_effect(bus, 0)
		##
		queue_free()
	##
##

func save_game():
	var json_dump = $GameRoot.get_data()
	json_dump["player_left"] = player_left_save
	json_dump = JSON.stringify(json_dump)
	var save_file = FileAccess.open("user://level.save", FileAccess.WRITE)
	if save_file == null:
		printerr("SOMETHING WENT HORRIBLY WRONG SAVING!")
		return
	##
	save_file.store_string(json_dump)
	
	json_dump = $GameRoot.get_player_data()
	save_file = FileAccess.open("user://player.save", FileAccess.WRITE)
	if save_file == null:
		printerr("SOMETHING WENT HORRIBLY WRONG SAVING!")
		return
	##
	save_file.store_string(json_dump)
##

func unpause_pause():
	get_tree().paused = !get_tree().paused
	pause_canvas_layer.visible = get_tree().paused
	
	if get_tree().paused:
		# apply filter
		AudioServer.add_bus_effect(bus, AudioEffectLowPassFilter.new())
	else:
		# remove filter
		AudioServer.remove_bus_effect(bus, 0)
	##
##

func to_free(scene_name):
	if scene_name != name:
		self.queue_free()
	##
##
