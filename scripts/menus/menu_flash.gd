extends CanvasLayer

@onready var animation_player = $AnimationPlayer

var flashed:bool = false

func flash():
	animation_player.play("flash")
##

func _on_animation_player_animation_finished(_anim_name):
	flashed = true
##
