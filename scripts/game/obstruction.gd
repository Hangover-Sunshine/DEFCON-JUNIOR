extends CharacterBody2D
class_name Obstruction

@export var MovesHorizontally:bool = false
@export var HorizontalSpeed:float = 250
@export var VerticalSpeed:float = -250
@export var IsBird:bool = false

var facing_right:bool = false
var dead:bool = false

func _physics_process(delta):
	if dead == false and MovesHorizontally:
		velocity.x = HorizontalSpeed
	##
	
	velocity.y = VerticalSpeed
	
	# move
	move_and_slide()
	
	# TODO: if bird, offset slightly on a sine wave
	#if IsBird:
		#pass
	##
##

func hit():
	# play explosion, sfx, whatever, just die
	$PropGraphic.anim_die()
	$PlayerDetector.queue_free()
	$Hitbox.queue_free()
	dead = true
	velocity.x = 0
	GlobalSignals.emit_signal("hobstacle_dead")
##

func direction_check():
	if HorizontalSpeed > 0:
		facing_right = true
		$PropGraphic.scale.x = -1
	##
##

func _on_player_detector_body_entered(body):
	body.hit()
	hit()
##

func _on_visible_on_screen_notifier_2d_screen_exited():
	GlobalSignals.emit_signal("hobstacle_dead")
	queue_free()
##

func _on_died_anim_complete():
	queue_free()
##
