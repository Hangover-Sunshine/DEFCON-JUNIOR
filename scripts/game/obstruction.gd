extends CharacterBody2D
class_name Obstruction

@export var MovesHorizontally:bool = false
@export var HorizontalSpeed:float = 250
@export var VerticalSpeed:float = -250

var facing_right:bool = false

func _ready():
	if HorizontalSpeed > 0:
		facing_right = true
		$Prop_Plane.scale.x = -1
	##
##

func _physics_process(delta):
	if MovesHorizontally:
		velocity.x = HorizontalSpeed
	##
	
	velocity.y = VerticalSpeed
	
	move_and_slide()
##

func hit():
	# play explosion, sfx, whatever, just die
	queue_free()
##

func _on_player_detector_body_entered(body):
	# TODO: fun death
	body.hit()
	queue_free()
##
