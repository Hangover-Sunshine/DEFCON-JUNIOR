extends CharacterBody2D
class_name Projectile

@onready var hit_area = $Area2D

var penetration:int = 1
var timer:float
var time_to_despawn:float

func setup(speed, on_layer, collide_with, tod):
	collision_layer = on_layer
	hit_area.collision_mask = collide_with
	
	self.time_to_despawn = tod
	
	if on_layer == 2:
		$Bullet.modulate = Color.DARK_RED
		velocity = speed * Vector2(0, -1)
	else:
		$Bullet.modulate = Color.DARK_GREEN
		$Bullet.rotation = 0
		velocity = speed * Vector2(0, 1)
	##
##

func _physics_process(delta):
	timer += delta
	
	if timer >= time_to_despawn:
		queue_free()
		return
	##
	
	move_and_slide()
##

func _on_area_2d_body_entered(body):
	body.hit()
	
	penetration -= 1
	
	if penetration == 0:
		queue_free()
	##
##

func hit():
	queue_free()
##
