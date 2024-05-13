extends CharacterBody2D
class_name Missile

@export var Speed:float = 350
@export var Lifetime:float = 15
@export var TimeframeToSnapshot:Vector2 = Vector2(6, 10)

@export var TrackPlayer:bool = false
@export var SingleShot:bool = false

@onready var snapshot_timer:Timer = $SnapshotTimer
@onready var living_timer:Timer = $LivingTimer

var target:Player
var direction:Vector2

func _ready():
	living_timer.start(Lifetime)
	living_timer.paused = true
	snapshot_timer.start(randf_range(TimeframeToSnapshot.x, TimeframeToSnapshot.y))
##

func _physics_process(delta):
	velocity = direction * Speed
	move_and_slide()
##

func _on_snapshot_timer_timeout():
	direction = global_position.direction_to(target.global_position)
##

func _on_living_timer_timeout():
	# TODO: explode
	queue_free()
##

func _on_visible_on_screen_notifier_2d_screen_exited():
	living_timer.paused = true
	direction = Vector2.ZERO
	
	if global_position.x < 0:
		global_position.x -= 100
	else:
		global_position.x += 100
	##
	
	if global_position.y < 0:
		global_position.y -= 100
	else:
		global_position.y += 100
	##
	
	if SingleShot or living_timer.time_left < 1:
		queue_free()
	else:
		GlobalSignals.emit_signal("rand_point_request", self)
		snapshot_timer.start(randf_range(TimeframeToSnapshot.x, TimeframeToSnapshot.y))
	##
##

func _on_visible_on_screen_notifier_2d_screen_entered():
	living_timer.paused = false
##
