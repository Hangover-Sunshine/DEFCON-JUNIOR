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
		pos.y += randf_range(-550, 550) + 50
	else:
		pos.x += randf_range(-550, 550) + 50
	##
	
	missile.global_position = pos
##

func get_random_horobj_start(object):
	var idx = [0, 2][randi() % 2]
	
	var pos:Vector2 = initial_pos[idx].global_position
	pos.y += randf_range(-50, 650) + 50
	
	object.global_position = pos
##

func get_random_static_start(object):
	object.global_position = initial_pos[1].global_position
	object.global_position.x += randf_range(-350, 350) + 50
	object.global_position.y += 50
##
