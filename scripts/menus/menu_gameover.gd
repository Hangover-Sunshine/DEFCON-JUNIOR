extends Control

func _on_cont_button_pressed():
	GlobalSignals.emit_signal("reload_level")
##

func _on_leave_button_pressed():
	GlobalSignals.emit_signal("load_scene", "menus/hub_menu")
##
