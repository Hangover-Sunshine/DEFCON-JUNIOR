extends Control

@onready var exit_button = $Main_MC/Main_VBox/Button_HBox/Button_VBox/Exit_Button

signal main_to_set
signal main_to_pre

func _on_start_button_pressed():
	main_to_pre.emit()
	MusicManager.play("ost", "LLAmbience", 1.0)
	MusicManager.set_volume(-28)

func _on_settings_button_pressed():
	main_to_set.emit()

func _on_exit_button_pressed():
	exit_button.visible = false

func _on_mouse_entered():
	SoundManager.play_varied("common_sfx", "hover", randf_range(0.8, 1.1))
##
