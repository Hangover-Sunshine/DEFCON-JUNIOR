extends Control

var bus = null

var loaded_in:bool = false

func _ready():
	loaded_in = true
	get_tree().paused = false
	GlobalSignals.connect("scene_loaded", _scene_loaded)
	bus = AudioServer.get_bus_index("Music")
##

func _scene_loaded(scene_name):
	if scene_name != name:
		if AudioServer.get_bus_effect_count(bus) > 0:
			AudioServer.remove_bus_effect(bus, 0)
		##
		
		self.queue_free()
	##
##

func _on_cont_button_pressed():
	loaded_in = false
	AudioServer.remove_bus_effect(bus, 0)
	GlobalSignals.emit_signal("load_scene", "GameScene")
##

func _on_leave_button_pressed():
	loaded_in = false
	GlobalSignals.emit_signal("load_scene", "menus/hub_menu")
	MusicManager.stop(1.0)
##

func _on_mouse_entered():
	SoundManager.play_varied("common_sfx", "hover", randf_range(0.8, 1.1))
##
