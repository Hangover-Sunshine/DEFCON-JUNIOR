extends Node2D

@onready var pause_canvas_layer = $PauseCanvasLayer

func _ready():
	GlobalSignals.connect("scene_loaded", to_free)
##

func _input(event):
	if event.is_action_pressed("pause"):
		unpause_pause()
		$PauseCanvasLayer/HubPause.to_pause()
	##
##

func unpause_pause():
	get_tree().paused = !get_tree().paused
	pause_canvas_layer.visible = get_tree().paused
##

func to_free(scene_name):
	if scene_name != name:
		self.queue_free()
	##
##
