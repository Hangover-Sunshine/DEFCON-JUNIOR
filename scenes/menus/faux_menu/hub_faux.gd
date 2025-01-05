extends Node2D

@onready var menu_splash = $MenuSplash
@onready var menu_main = $MenuMain
@onready var menu_settings = $MenuSettings
@onready var menu_pregame = $MenuPregame
@onready var back_frame = $BackFrame
@onready var ll_ambiance = $LLAmbiance
@onready var directional_light_2d = $AP/DirectionalLight2D
@onready var post_nuke_light_2 = $AP/PostNuke_Light2

var ready_to_splash = false

func _ready():
	to_splash()
	handle_signals()
	MusicManager.play("ost", "void_theme")

func to_splash():
	menu_splash.visible = true

func handle_signals():
	menu_main.main_to_set.connect(to_set)
	menu_settings.set_to_main.connect(to_main)
	menu_main.main_to_pre.connect(to_pre)

func _input(event):
	if event.is_pressed() and menu_splash.visible == true and ready_to_splash == true:
		menu_splash.visible = false
		to_main()

func _on_ap_animation_finished(anim_name):
	if anim_name == "ToSplash":
		ready_to_splash = true

func to_main():
	menu_main.visible = true
	menu_settings.visible = false

func to_set():
	menu_main.visible = false
	menu_settings.visible = true

func to_pre():
	menu_main.visible = false
	menu_pregame.visible = true
	back_frame.visible = false
	directional_light_2d.visible = false
	post_nuke_light_2.visible = false

