extends CanvasLayer

@onready var animation_player = $AnimationPlayer

var in_black:bool = false
var done_fade_out:bool = false

func flash():
	in_black = false
	done_fade_out = false
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
	if anim_name == "flash":
		animation_player.play("fade_to_black")
	elif anim_name == "fade_to_black":
		in_black = true
	elif anim_name == "fade_out":
		done_fade_out = true
	##
##
