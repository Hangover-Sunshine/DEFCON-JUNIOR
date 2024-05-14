extends Node2D

var initial_pos:Array

func _ready():
	initial_pos = get_children()
	GlobalSignals.connect("rand_point_request", get_random_position)
##

func get_random_position(missile:Missile):
	var idx = randi() % len(initial_pos)
	var pos:Vector2 = initial_pos[idx].global_position
	
	if idx == 0 or idx == 2:
		pos.y += randf_range(-250, 250)
	else:
		pos.x += randf_range(-250, 250)
	##
	
	missile.global_position = pos
##

func get_random_horobj_start(object):
	var idx = [0, 1, 2][randi() % 2]
	
	var pos:Vector2 = initial_pos[idx].global_position
	
	if idx == 1:
		pos.x += 150 * [-1, 1][randi() % 2]
	else:
		pos.y += randf_range(-250, 150)
	##
	
	object.global_position = pos
##
