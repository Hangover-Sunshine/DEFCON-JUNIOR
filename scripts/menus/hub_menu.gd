extends Node2D

@onready var menu_splash = $MenuSplash
@onready var menu_main = $MenuMain
@onready var menu_pregame = $MenuPregame
@onready var menu_settings = $MenuSettings
@onready var animplayer = $HubMenu_AnimPlayer
@onready var menu_warning = $MenuWarning

var to_main_ready = false
var to_splash_ready = false

var to_power_selection = false

func _ready():
	handle_signals()
	
	if FileAccess.file_exists("user://level.save"):
		var file = FileAccess.open("user://level.save", FileAccess.READ)
		var json_string = file.get_as_text()
		var json = JSON.new()
		var res = json.parse(json_string)
		if res != OK:
			print("error on:", json.get_error_message(), " on line ", json.get_error_line())
			return
		##
		to_power_selection = !json.get_data()["selected"]
	##
##

func _input(event):
	if event.is_pressed() and menu_warning.visible == true and to_splash_ready == true:
		animplayer.play("ToSplash")
		if GlobalPlaylist.current_song() != "MainTheme":
			GlobalPlaylist.play("MainTheme")
		##
	elif event.is_pressed() and to_main_ready == true and menu_splash.visible == true:
		animplayer.play("ToMain")

func _on_hub_menu_anim_player_animation_finished(anim_name):
	if anim_name == "ToWarning":
		to_splash_ready = true
	elif anim_name == "ToSplash":
		to_main_ready = true
	
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
	if to_power_selection:
		GlobalPlaylist.stop_playing()
		GlobalSignals.emit_signal("load_scene", "menus/menu_cards")
	else:
		GlobalSignals.emit_signal("load_scene", "GameScene")
	##
##

func to_free(_scene_name):
	self.queue_free()
