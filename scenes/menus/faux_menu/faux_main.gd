extends Control

@onready var exit_button = $Main_MC/Main_VBox/Button_HBox/Button_VBox/Exit_Button

signal main_to_set
signal main_to_pre

func _on_start_button_pressed():
	main_to_pre.emit()
	GlobalPlaylist.stop_playing()
	$"../LLAmbiance".volume_db = -28
	$"../LLAmbiance".play()

func _on_settings_button_pressed():
	main_to_set.emit()

func _on_exit_button_pressed():
	exit_button.visible = false
