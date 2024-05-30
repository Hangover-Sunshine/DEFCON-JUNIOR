extends Control

signal pregame_to_game
signal pregame_to_main

@onready var ap_controls = $AP_Controls



func _ready():
	if GlobalSettings.os_type == "Web":
		ap_controls.play("Flash_Web")

func _on_tutorial_button_pressed():
	pregame_to_game.emit()

func _on_back_button_pressed():
	pregame_to_main.emit()

func _on_mouse_entered():
	$HoverPool.play_random_sound()
##
