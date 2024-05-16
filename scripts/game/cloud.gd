extends Node2D

var speed:float

var target:Vector2

func setup(nearness):
	match nearness:
		0:
			$CloseCloud.visible = true
			speed = 400
		1:
			$FarCloud.visible = true
			speed = 250
		##
	##
##

func _process(delta):
	pass
##

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
##
