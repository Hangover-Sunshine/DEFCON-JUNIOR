extends Node2D

@onready var menu_splash = $MenuSplash
@onready var menu_main = $MenuMain
@onready var menu_pregame = $MenuPregame
@onready var menu_settings = $MenuSettings
@onready var animplayer = $HubMenu_AnimPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	handle_signals()

func _input(event):
	if event.is_pressed() and menu_splash.visible == true:
		to_main()

func handle_signals():
	menu_main.main_to_pregame.connect(to_pregame)
	menu_main.main_to_settings.connect(to_settings)
	menu_main.main_to_exit.connect(to_exit)
	menu_pregame.pregame_to_main.connect(to_main)
	menu_pregame.pregame_to_game.connect(to_load)
	menu_settings.settings_to_main.connect(to_main)
	GlobalSignals.connect("scene_loaded", to_free)

func to_main():
	animplayer.play("ToMain")

func to_pregame():
	animplayer.play("ToPregame")

func to_settings():
	animplayer.play("ToSettings")

func to_exit():
	get_tree().quit()

func to_load():
	GlobalSignals.emit_signal("load_scene", "DummySceneA")

func to_free(scene_name):
	self.queue_free()
