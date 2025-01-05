extends Control

signal set_to_main

func _on_back_button_pressed():
	set_to_main.emit()

func _on_back_button_mouse_entered():
	SoundManager.play_varied("common_sfx", "hover", randf_range(0.7, 0.9))
