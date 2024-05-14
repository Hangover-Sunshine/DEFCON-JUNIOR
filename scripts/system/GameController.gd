extends Node2D

@export var Levels:Array[LevelResource]

@export var JetPrefab:PackedScene
@export var MissilePrefab:Array[PackedScene]
@export var BalloonPrefab:PackedScene
@export var BirdPrefab:PackedScene
@export var PlanePrefab:PackedScene

@onready var game_timer = $Info/GameTimer
@onready var missile_timer = $Info/MissileTimer
@onready var jet_timer = $Info/JetTimer
@onready var obstacle_timer = $Info/ObstacleTimer
@onready var horizontal_timer = $Info/HorizontalTimer

@onready var rand_position = $RandPosition
@onready var player = $Player

const PLAYER_SPAWN:Vector2 = Vector2(980, -100)

var curr_level:int = 0

var curr_jets:int = 0
var curr_move_obstacles:int = 0
var curr_obstacles:int = 0
var curr_missiles:int = 0

var max_jets:int = 0
var max_move_obstacles:int = 0
var max_obstacles:int = 0
var max_missiles:int = 0

var jet_spawn_amount:Vector2
var missile_spawn_amount:Vector2
var horizontal_object_spawn_amount:Vector2
var static_object_spawn_amount:Vector2

func load_next_level():
	var level = Levels[curr_level]
	
##

func _ready():
	GlobalSignals.connect("jet_dead", _jet_dead)
	GlobalSignals.connect("missile_dead", _missile_dead)
	GlobalSignals.connect("hobstacle_dead", _hobstacle_dead)
	GlobalSignals.connect("obstacle_dead", _obstacle_dead)
##

func _on_game_timer_timeout():
	# TODO: BOOM! :)
	GlobalSignals.emit_signal("level_complete")
##

func _jet_dead():
	curr_jets -= 1
	if jet_timer.is_stopped():
		jet_timer.start()
	##
##

func _missile_dead():
	curr_missiles -= 1
	if missile_timer.is_stopped():
		missile_timer.start()
	##
##

func _hobstacle_dead():
	curr_move_obstacles -= 1
	if horizontal_timer.is_stopped():
		horizontal_timer.start()
	##
##

func _obstacle_dead():
	curr_obstacles -= 1
##

func _on_missile_timer_timeout():
	var indx = randi() % 4
	var missile = MissilePrefab[indx].instantiate()
	missile.target = player
	add_child(missile)
	rand_position.get_random_position(missile)
	curr_missiles += 1
	
	if curr_missiles < max_missiles and missile_timer.is_stopped():
		missile_timer.start()
	##
##

func _on_jet_timer_timeout():
	var jet = JetPrefab.instantiate()
	add_child(jet)
	curr_jets += 1
	
	if curr_jets < max_jets and jet_timer.is_stopped():
		jet_timer.start()
	##
##

func _on_obstacle_timer_timeout():
	# TODO: we have none.
	pass # Replace with function body.
##

func _on_horizontal_timer_timeout():
	var indx = randi() % 3
	var object
	
	if indx == 0:
		object = BalloonPrefab.instantiate()
	elif indx == 1:
		object = BirdPrefab.instantiate()
	else:
		object = PlanePrefab.instantiate()
	##
	
	add_child(object)
	rand_position.get_random_horobj_start(object)
	
	curr_move_obstacles += 1
	
	if curr_move_obstacles < max_move_obstacles and horizontal_timer.is_stopped():
		horizontal_timer.start()
	##
##
