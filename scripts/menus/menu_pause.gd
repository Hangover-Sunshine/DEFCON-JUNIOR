extends Control

signal pause_to_game
signal pause_to_settings
signal pause_to_main

func _on_cont_button_pressed():
	pause_to_game.emit()

func _on_settings_button_pressed():
	pause_to_settings.emit()

func _on_leave_button_pressed():
	pause_to_main.emit()

func _on_mouse_entered():
	SoundManager.play_varied("common_sfx", "hover", randf_range(0.8, 1.1))
	#$HoverPool.play_random_sound()
##
