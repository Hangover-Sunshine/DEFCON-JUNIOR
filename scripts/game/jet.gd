extends CharacterBody2D
class_name Jet

enum JetState {
	SPAWN,
	SHOOT,
	TELEGRAPH,
	RUSH,
	RESPAWN
}

enum SprayPattern {
	BOTH,
	LEFT_ONLY,
	RIGHT_ONLY,
	MIDDLE
}

@export_category("General Info")
@export var RushSpeed:float = 500
@export var StartingYPosition:float = 930

@export_category("Behaviors")
@export var BobSpeed:float = 400
@export var BobLimits:float = 0.15

@export_group("Bob 1")
@export var BobOnTimer:bool = false
@export var BobTimer:Vector2 = Vector2(1.1, 1.8)

@export_group("Bob 2")
@export var BobLeftAndRight:bool = false

@export_group("Bob 3")
@export var FollowAndBob:bool = false
@export_range(0.05, 0.35) var NearnessToPlayer:float = 0.3

@export_category("Timers")
@export var RushTelegraphTimer:float = 3
@export var StayTimerRange:Vector2 = Vector2(6, 12)
@export var ReturnTimerRange:Vector2 = Vector2(5, 8)
@export var FireTime:float = 0.8

@export_category("Projectile")
@export var Munition:Resource
@export var BulletSpeed:float = 350
@export var BulletLifetime:float = 5
@export var RandomizePattern:bool = false
@export var UsePattern:SprayPattern = SprayPattern.BOTH

# TODO: pattern development
@onready var bullet_patterns = $Patterns

@onready var fire_timer = $FireTimer
@onready var move_timer = $MoveTimer
@onready var bob_timer = $BobTimer

@onready var aoe = $AOE

var player:Player
var bob_limits:Vector2

var jet_state:JetState = JetState.SPAWN

var starting_position:Vector2
var pf_bob_bounds:Vector2
var curr_limits:Vector2

var pattern:int
var spawn_pos

func _ready():
	assert(!(BobLeftAndRight and BobOnTimer), "Too many behaviors!")
	
	#global_position.y = StartingYPosition
	var vp_x_size = get_viewport_rect().size.x
	bob_limits = Vector2(vp_x_size * BobLimits, vp_x_size - vp_x_size * BobLimits)
	starting_position = Vector2(randf_range(bob_limits.x, bob_limits.y), StartingYPosition)
	global_position.x = starting_position.x
	global_position.y = StartingYPosition + 200
	
	if RandomizePattern:
		pass
	else:
		pattern = UsePattern
	##
	
	spawn_pos = $Patterns.get_child(pattern).get_children()
##

func _physics_process(delta):
	if jet_state == JetState.SPAWN:
		global_position = global_position.move_toward(starting_position, 200 * delta)
		
		if global_position.distance_to(starting_position) == 0:
			jet_state = JetState.SHOOT
			fire_timer.start(FireTime)
			
			if BobOnTimer or BobLeftAndRight or FollowAndBob:
				velocity.x = [-1, 1][randi() % 2] * BobSpeed
			##
			
			curr_limits = bob_limits
			
			if BobOnTimer:
				bob_timer.start(randf_range(BobTimer.x, BobTimer.y))
			##
			
			move_timer.start(randf_range(StayTimerRange.x, StayTimerRange.y))
		##
	elif jet_state == JetState.SHOOT:
		if FollowAndBob:
			var mod_by = player.global_position.x * NearnessToPlayer
			curr_limits = Vector2(player.global_position.x - mod_by,
										player.global_position.x + mod_by)
		##
		move_and_slide()
		if global_position.x <= curr_limits.x:
			if BobOnTimer:
				bob_timer.start(randf_range(BobTimer.x, BobTimer.y))
			##
			velocity.x = BobSpeed
		##
		if global_position.x >= curr_limits.y:
			if BobOnTimer:
				bob_timer.start(randf_range(BobTimer.x, BobTimer.y))
			##
			velocity.x = -BobSpeed
		##
	elif jet_state == JetState.TELEGRAPH:
		aoe.custom_minimum_size = aoe.custom_minimum_size.move_toward(Vector2(0, 500),
												(500 / (RushTelegraphTimer - 0.1)) * delta)
	elif jet_state == JetState.RUSH:
		velocity.y = -RushSpeed
		move_and_slide()
	##
##

func _on_move_timer_timeout():
	if jet_state == JetState.SHOOT:
		aoe.visible = true
		aoe.set_custom_minimum_size(Vector2(0,0))
		jet_state = JetState.TELEGRAPH
		velocity.x = 0
		move_timer.start(RushTelegraphTimer)
	elif jet_state == JetState.TELEGRAPH:
		velocity.x = 0
		aoe.visible = false
		fire_timer.stop()
		bob_timer.stop()
		jet_state = JetState.RUSH
	elif jet_state == JetState.RESPAWN:
		jet_state = JetState.SPAWN
	##
##

func _on_fire_timer_timeout():
	for sp in spawn_pos:
		var bullet = Munition.instantiate()
		GlobalSignals.emit_signal("spawn_bullet", bullet)
		bullet.setup(BulletSpeed, 2, 1, BulletLifetime)
		bullet.global_position = sp.global_position
	##
	
	fire_timer.start(FireTime)
##

func _on_bob_timer_timeout():
	var dir = [-1, 1][randi() % 2]
	velocity.x = dir * BobSpeed
	bob_timer.start(randf_range(BobTimer.x, BobTimer.y))
##

func _on_visible_on_screen_notifier_2d_screen_exited():
	jet_state = JetState.RESPAWN
	velocity.y = 0
	starting_position = Vector2(randf_range(bob_limits.x, bob_limits.y), StartingYPosition)
	global_position.x = starting_position.x
	global_position.y = StartingYPosition + 200
	move_timer.start(randf_range(ReturnTimerRange.x, ReturnTimerRange.y))
##

func _on_player_detector_body_entered(body):
	# TODO: play explosion and kill self
	body.hit()
	queue_free()
##

func hit():
	# play explosion, sfx, whatever, just die
	queue_free()
##
