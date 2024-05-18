extends CanvasLayer

@onready var animation_player = $AnimationPlayer

var flashed:bool = false

func flash():
	animation_player.play("flash")
##

func player_dead_flash():
	animation_player.play("player_dead")
##

func no_flash_flash():
	animation_player.play("no_flash")
##

func _on_animation_player_animation_finished(anim_name):
	flashed = true
##
