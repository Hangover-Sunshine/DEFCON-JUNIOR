extends CharacterBody2D
class_name Obstruction

@export var MovesHorizontally:bool = false
@export var HorizontalSpeed:float = 250
@export var VerticalSpeed:float = -250

func _physics_process(delta):
	if MovesHorizontally:
		velocity.x = HorizontalSpeed
	##
	
	velocity.y = VerticalSpeed
	
	move_and_slide()
##

