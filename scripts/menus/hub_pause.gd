extends Node2D

@onready var menu_pause = $MenuPause
@onready var menu_settings = $MenuSettings
@onready var animplayer = $HubPause_AnimPlayer

func _ready():
	handle_signals()

func handle_signals():
	menu_pause.pause_to_game.connect(to_game)
	menu_pause.pause_to_settings.connect(to_settings)
	menu_settings.settings_to_main.connect(to_pause)
	menu_pause.pause_to_main.connect(to_load)
	GlobalSignals.connect("scene_loaded", to_free)

func to_game():
	get_parent().get_parent().unpause_pause()

func to_pause():
	animplayer.play("ToPause")

func to_settings():
	animplayer.play("ToSettings")

func to_load():
	MusicManager.stop(1.0)
	GlobalSignals.emit_signal("load_scene", "menus/hub_menu")
##

func to_free(scene_name):
	self.queue_free()
	
