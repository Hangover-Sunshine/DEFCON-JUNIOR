extends CanvasLayer

@onready var animation_player = $AnimationPlayer

var flashed:bool = false

func flash():
	animation_player.play("flash")
	$ColorRect.mouse_filter = Control.MOUSE_FILTER_STOP
##

func fade_out():
	animation_player.play("fade_out")
	$ColorRect.mouse_filter = Control.MOUSE_FILTER_PASS
##

func fade_in():
	animation_player.play_backwards("fade_out")
##

func _on_animation_player_animation_finished(anim_name):
	flashed = true
##
