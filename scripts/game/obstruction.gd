extends CharacterBody2D
class_name Obstruction

@export var MovesHorizontally:bool = false
@export var HorizontalSpeed:float = 250
@export var VerticalSpeed:float = -250

var facing_right:bool = false

func _ready():
	if VerticalSpeed > 0:
		facing_right = true
	##
##

func hit():
	pass
##

func _physics_process(delta):
	if MovesHorizontally:
		velocity.x = HorizontalSpeed
	##
	
	velocity.y = VerticalSpeed
	
	move_and_slide()
##

