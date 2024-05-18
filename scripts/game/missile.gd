extends CharacterBody2D
class_name Missile

@export var Speed:float = 350
@export var Lifetime:int = 5
@export var TimeframeToSnapshot:Vector2 = Vector2(6, 10)

@export var TrackPlayer:bool = false
@export var LockDistance:float = 250

@onready var snapshot_timer:Timer = $SnapshotTimer

@onready var indicator = $Indicator

var target:Player
var direction:Vector2

var waiting_for_move:bool = false
var dead:bool = false
var target_acquired:bool = false

var indicator_pos:Vector2
var play_area_size:Array

var free_off_screen:bool = false

func _ready():
	GlobalSignals.connect("blow_on_screen", _blow_on_screen)
	GlobalSignals.connect("free_off_screen", _free_off_screen)
	
	waiting_for_move = true
	snapshot_timer.start(randf_range(TimeframeToSnapshot.x, TimeframeToSnapshot.y))
	snapshot_timer.paused = false
	
	indicator.visible = false
	
	play_area_size = get_parent().get_parent().get_play_area_limits()
	play_area_size[0].x += 80
	play_area_size[0].y += 80
	play_area_size[1].x -= 100
	play_area_size[1].y -= 100
##

func _blow_on_screen():
	hit()
##

func _free_off_screen():
	free_off_screen = true
##

func _process(_delta):
	if indicator.visible == false and waiting_for_move and snapshot_timer.time_left < 2.5:
		indicator.show_indicator()
		indicator.visible = true
		indicator_pos.x = clampf(global_position.x, play_area_size[0].x, play_area_size[1].x)
		indicator_pos.y = clampf(global_position.y, play_area_size[0].y, play_area_size[1].y)
	##
	
	if indicator.visible:
		indicator.global_position = indicator_pos
		indicator.rotation = -rotation
	##
##

func _physics_process(_delta):
	if dead == false and TrackPlayer and snapshot_timer.is_stopped():
		var dist = global_position.distance_to(target.global_position)
		if target_acquired == false and dist > LockDistance:
			direction = global_position.direction_to(target.global_position)
			rotation = atan2(direction.y, direction.x)
		elif dist <= LockDistance:
			target_acquired = true
		##
	##
	
	velocity = direction * Speed
	move_and_slide()
##

func _on_snapshot_timer_timeout():
	direction = global_position.direction_to(target.global_position)
	rotation = atan2(direction.y, direction.x)
	waiting_for_move = false
	indicator.hide_indicator()
##

func _on_visible_on_screen_notifier_2d_screen_exited():
	if free_off_screen:
		queue_free()
		return
	##
	
	if snapshot_timer.is_stopped() == false:
		return
	##
	
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
	
	Lifetime -= 1
	
	if Lifetime == 0:
		GlobalSignals.emit_signal("missile_dead")
		queue_free()
	else:
		target_acquired = false
		GlobalSignals.emit_signal("rand_point_request", self)
		snapshot_timer.start(randf_range(TimeframeToSnapshot.x, TimeframeToSnapshot.y))
		waiting_for_move = true
	##
##

func _on_player_detector_body_entered(body):
	body.hit()
	hit()
##

func hit():
	if $PlayerDetector == null:
		return
	##
	$PropGraphic.anim_die()
	$PlayerDetector.queue_free()
	$Hitbox.queue_free()
	dead = true
	velocity.x = 0
	GlobalSignals.emit_signal("missile_dead")
##

func _on_missile_died():
	queue_free()
##
