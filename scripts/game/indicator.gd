extends Node2D

@onready var animation_player = $AnimationPlayer

func play_flash():
	animation_player.play("flash")
##

func set_playspeed(speed):
	animation_player.speed_scale = speed
##

func hide_indicator():
	animation_player.play("hide", 1)
##

func show_indicator():
	animation_player.play("show", 1)
##

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "show":
		play_flash()
	##
	
	if anim_name == "hide":
		visible = false
	##
##
