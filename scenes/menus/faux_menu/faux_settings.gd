extends Control

signal set_to_main

func _on_back_button_pressed():
	set_to_main.emit()
