extends Node2D

func _ready():
	GlobalSignals.connect("spawn_bullet", _spawn_bullet)
##

func _spawn_bullet(projectile):
	add_child(projectile)
##
