extends Node2D

@onready var pause_canvas_layer = $PauseCanvasLayer

func _input(event):
	if event.is_action_pressed("pause"):
		get_tree().paused = !get_tree().paused
		pause_canvas_layer.visible = get_tree().paused
	##
##
