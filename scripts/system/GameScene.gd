extends Node2D

@onready var pause_canvas_layer = $PauseCanvasLayer
@onready var game_over_canvas_layer = $GameOverCanvasLayer
@onready var flash_canvas_layer = $FlashCanvasLayer

var player_lost:bool = false
var player_won:bool = false

var curr_level:int = 0
var game = null

func _ready():
	GlobalSignals.connect("scene_loaded", to_free)
	GlobalSignals.connect("level_complete", _level_complete)
	GlobalSignals.connect("player_died", _player_died)
	GlobalSignals.connect("reload_level", reset)
	
	game = $GameRoot
	game.curr_level = curr_level
	game.load_level()
##

func _process(_delta):
	if player_lost:
		if flash_canvas_layer.in_black and game_over_canvas_layer.visible == false:
			game_over_canvas_layer.visible = true
			flash_canvas_layer.fade_out()
		##
		if flash_canvas_layer.done_fade_out:
			game_over_canvas_layer.layer = 2
		##
	##
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
	
	game_over_canvas_layer.layer = 1
	flash_canvas_layer.fade_in()
	#game.load_level()
	
	player_lost = false
	player_won = false
##

func _level_complete():
	var curr_level = $GameRoot.curr_level
##

func _player_died():
	get_tree().paused = true
	flash_canvas_layer.visible = true
	flash_canvas_layer.flash()
	player_lost = true
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
