extends Node2D

@onready var pause_canvas_layer = $PauseCanvasLayer
@onready var flash_canvas_layer = $FlashCanvasLayer

var player_lost:bool = false
var player_won:bool = false
var next_scene:bool = false

var curr_level:int = 0

func _ready():
	GlobalSignals.connect("scene_loaded", to_free)
	GlobalSignals.connect("level_complete", _level_complete)
	GlobalSignals.connect("player_died", _player_died)
	
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
	##
	
	$GameRoot.curr_level = curr_level
	$GameRoot.load_level()
##

func _process(_delta):
	if flash_canvas_layer.flashed and next_scene == false:
		if player_lost:
			GlobalSignals.emit_signal("load_scene", "menus/menu_gameover")
		##
		if player_won:
			GlobalSignals.emit_signal("load_scene", "menus/menu_cutscene")
		##
		next_scene = true
	##
##

func _input(event):
	if event.is_action_pressed("pause"):
		unpause_pause()
		$PauseCanvasLayer/HubPause.to_pause()
	##
##

func _level_complete():
	get_tree().paused = true
	#$GameRoot.curr_level += 1
	flash_canvas_layer.visible = true
	flash_canvas_layer.flash()
	player_won = true
	save_game()
##

func _player_died():
	get_tree().paused = true
	flash_canvas_layer.visible = true
	flash_canvas_layer.flash()
	player_lost = true
	save_game()
##

func save_game():
	var json_dump = $GameRoot.get_data()
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
##

func to_free(scene_name):
	if scene_name != name:
		self.queue_free()
	##
##
