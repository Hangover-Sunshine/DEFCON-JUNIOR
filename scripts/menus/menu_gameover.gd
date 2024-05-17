extends Control

func _ready():
	get_tree().paused = false
##

func _on_cont_button_pressed():
	GlobalSignals.emit_signal("load_scene", "GameScene")
##

func _on_leave_button_pressed():
	GlobalSignals.emit_signal("load_scene", "menus/hub_menu")
##
