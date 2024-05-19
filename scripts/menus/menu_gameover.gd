extends Control

func _ready():
	get_tree().paused = false
	GlobalSignals.connect("scene_loaded", _scene_loaded)
##

func _scene_loaded(scene_name):
	if scene_name != name:
		self.queue_free()
	##
##

func _on_cont_button_pressed():
	GlobalSignals.emit_signal("load_scene", "GameScene")
##

func _on_leave_button_pressed():
	GlobalSignals.emit_signal("load_scene", "menus/hub_menu")
##
