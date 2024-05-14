extends Node2D

@export var Levels:Array[LevelResource]

@onready var game_timer = $Info/GameTimer
@onready var missile_timer = $Info/MissileTimer
@onready var jet_timer = $Info/JetTimer
@onready var obstacle_timer = $Info/ObstacleTimer
@onready var horizontal_timer = $Info/HorizontalTimer

@onready var rand_position = $RandPosition
@onready var player = $Player

const PLAYER_SPAWN:Vector2 = Vector2(980, -100)

var curr_level:int

var curr_jets:int = 0
var curr_move_obstacles:int = 0
var curr_obstacles:int = 0
var curr_missiles:int = 0

var max_jets:int = 0
var max_move_obstacles:int = 0
var max_obstacles:int = 0
var max_missiles:int = 0

var jets_spawn_at:float
var spawning_jets:bool = false
var missiles_spawn_at:float
var spawning_missiles:bool = false

func load_next_level():
	var level = Levels[curr_level]
	
	# == Max Numbers == #
	max_jets = level.MaxFighters
	max_move_obstacles = level.MaxNumberOfDynamicObstaclesOnScreen
	max_obstacles = level.MaxNumberOfStaticObstaclesOnScreen
	max_missiles = level.MaxNumberOfMissiles
	# == Max Numbers == #
	
	var lvl_len_secs = level.LevelLength * 60
	jets_spawn_at = lvl_len_secs - level.FightersAppearAt * 60
	missiles_spawn_at = lvl_len_secs - level.MissilesAppearAt * 60
	
	game_timer.start(lvl_len_secs)
##

func _ready():
	GlobalSignals.connect("jet_dead", _jet_dead)
	GlobalSignals.connect("missile_dead", _missile_dead)
	GlobalSignals.connect("hobstacle_dead", _hobstacle_dead)
	GlobalSignals.connect("obstacle_dead", _obstacle_dead)
	load_next_level() # TODO: replace this
##

func _process(_delta):
	if spawning_jets == false and max_jets > 0 and game_timer.time_left <= jets_spawn_at:
		spawning_jets = true
		jet_timer.start(randf_range(Levels[curr_level].FighterSpawnTimerRange.x,
									Levels[curr_level].FighterSpawnTimerRange.y))
	##
	if spawning_missiles == false and max_missiles > 0 and game_timer.time_left <= missiles_spawn_at:
		spawning_missiles = true
		missile_timer.start(randf_range(Levels[curr_level].FighterSpawnTimerRange.x,
									Levels[curr_level].FighterSpawnTimerRange.y))
	##
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
	curr_missiles += 1
	
	var missile = Levels[curr_level].generate_missile()
	missile.target = player
	add_child(missile)
	rand_position.get_random_position(missile)
	
	if curr_missiles < max_missiles and missile_timer.is_stopped():
		missile_timer.start(randf_range(Levels[curr_level].FighterSpawnTimerRange.x,
									Levels[curr_level].FighterSpawnTimerRange.y))
	##
##

func _on_jet_timer_timeout():
	curr_jets += 1
	
	var jet = Levels[curr_level].generate_jet()
	jet.player = player
	add_child(jet)
	
	if curr_jets < max_jets and jet_timer.is_stopped():
		jet_timer.start(randf_range(Levels[curr_level].FighterSpawnTimerRange.x,
								Levels[curr_level].FighterSpawnTimerRange.y))
	##
##

func _on_obstacle_timer_timeout():
	# TODO: we have none.
	pass # Replace with function body.
##

func _on_horizontal_timer_timeout():
	var object = Levels[curr_level].generate_moving_obstacle()
	rand_position.get_random_horobj_start(object)
	
	if object.global_position.x > player.global_position.x:
		object.HorizontalSpeed *= -1
	##
	
	add_child(object)
	
	curr_move_obstacles += 1
	
	if curr_move_obstacles < max_move_obstacles and horizontal_timer.is_stopped():
		horizontal_timer.start()
	##
##
