extends Control

signal settings_to_main
# Called when the node enters the scene tree for the first time.

func _on_back_button_pressed():
	settings_to_main.emit()
