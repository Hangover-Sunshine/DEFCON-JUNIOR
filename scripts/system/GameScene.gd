extends Node2D

@onready var pause_canvas_layer = $PauseCanvasLayer
@onready var flash_canvas_layer = $FlashCanvasLayer

var player_lost:bool = false
var player_won:bool = false

var curr_level:int = 0

func _ready():
	print('entered')
	GlobalSignals.connect("scene_loaded", to_free)
	GlobalSignals.connect("level_complete", _level_complete)
	GlobalSignals.connect("player_died", _player_died)
	GlobalSignals.connect("reload_level", reset)
	
	if FileAccess.file_exists("user://data.save"):
		var file = FileAccess.open("user://data.save", FileAccess.READ)
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
	#if player_lost:
		#if flash_canvas_layer.in_black and game_over_canvas_layer.visible == false:
			#game_over_canvas_layer.visible = true
			#flash_canvas_layer.fade_out()
		###
		#if flash_canvas_layer.done_fade_out:
			#game_over_canvas_layer.layer = 2
		##
	##
	pass
##

func _input(event):
	if event.is_action_pressed("pause"):
		unpause_pause()
		$PauseCanvasLayer/HubPause.to_pause()
	##
##

func reset():
	if player_won:
		$GameRoot.curr_level += 1
	##
	
	get_tree().paused = false
	GlobalSignals.emit_signal("load_scene", "GameScene")
##

func _level_complete():
	$GameRoot.curr_level += 1
	save_game()
##

func _player_died():
	get_tree().paused = true
	flash_canvas_layer.visible = true
	flash_canvas_layer.flash()
	player_lost = true
	save_game()
	print("here")
	GlobalSignals.emit_signal("load_scene", "menus/menu_gameover")
##

func save_game():
	var json_dump = $GameRoot.get_data()
	var save_file = FileAccess.open("user://data.save", FileAccess.WRITE)
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
