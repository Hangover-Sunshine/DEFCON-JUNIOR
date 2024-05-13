extends CharacterBody2D
class_name Jet

enum JetState {
	SPAWN,
	SHOOT,
	TELEGRAPH,
	RUSH,
	RESPAWN
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

# TODO: pattern development
@onready var bullet_patterns = $Patterns

@onready var fire_timer = $FireTimer
@onready var move_timer = $MoveTimer
@onready var bob_timer = $BobTimer

var player:Player
var bob_limits:Vector2

var jet_state:JetState = JetState.SPAWN

var starting_position:Vector2
var pf_bob_bounds:Vector2
var curr_limits:Vector2

func _ready():
	assert(!(BobLeftAndRight and BobOnTimer), "Too many behaviors!")
	
	#global_position.y = StartingYPosition
	var vp_x_size = get_viewport_rect().size.x
	bob_limits = Vector2(vp_x_size * BobLimits, vp_x_size - vp_x_size * BobLimits)
	print(bob_limits)
	starting_position = Vector2(randf_range(bob_limits.x, bob_limits.y), StartingYPosition)
	global_position.x = starting_position.x
	global_position.y = StartingYPosition + 200
##

func _physics_process(delta):
	if jet_state == JetState.SPAWN:
		global_position = global_position.move_toward(starting_position, 200 * delta)
		
		if global_position.distance_to(starting_position) < 2:
			global_position = starting_position
			jet_state = JetState.SHOOT
			fire_timer.start(FireTime)
			
			velocity.x = [-1, 1][randi() % 2] * BobSpeed
			curr_limits = bob_limits
			if BobOnTimer:
				bob_timer.start(randf_range(BobTimer.x, BobTimer.y))
			##
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
	##
##

func _on_move_timer_timeout():
	pass
##

func _on_fire_timer_timeout():
	print("SPAWN")
	fire_timer.start(FireTime)
##

func _on_bob_timer_timeout():
	var dir = [-1, 1][randi() % 2]
	velocity.x = dir * BobSpeed
	bob_timer.start(randf_range(BobTimer.x, BobTimer.y))
##
