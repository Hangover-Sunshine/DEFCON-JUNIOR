extends Node2D

@export var Levels:Array[LevelResource]

@onready var game_timer = $Info/GameTimer
@onready var missile_timer = $Info/MissileTimer
@onready var jet_timer = $Info/JetTimer
@onready var obstacle_timer = $Info/ObstacleTimer
@onready var horizontal_timer = $Info/HorizontalTimer

@onready var rand_position = $RandPosition
@onready var player = $Player
@onready var env_city = $Env_City

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

var timer_level = 0

func load_level():
	var level = Levels[curr_level]
	
	$DummySky.color = level.LightColor
	$Frame_White/Frame_Sky.modulate = level.DarkColor
	$Cloud.color_initial_ramp = level.CloudGradient
	$CanvasLayer/GIU.dark_color = level.DarkColor
	
	# == Max Numbers == #
	max_jets = level.MaxFighters
	max_move_obstacles = level.MaxNumberOfDynamicObstaclesOnScreen
	max_obstacles = level.MaxNumberOfStaticObstaclesOnScreen
	max_missiles = level.MaxNumberOfMissiles
	# == Max Numbers == #
	
	var lvl_len_secs = level.LevelLength * 60
	jets_spawn_at = lvl_len_secs - level.FightersAppearAt * 60
	missiles_spawn_at = lvl_len_secs - level.MissilesAppearAt * 60
	
	if level.MaxNumberOfStaticObstaclesOnScreen > 0:
		obstacle_timer.start(randf_range(level.StaticSpawnTimerRange.x,
											level.StaticSpawnTimerRange.y))
	##
	
	if level.MaxNumberOfDynamicObstaclesOnScreen > 0:
		horizontal_timer.start(randf_range(level.DynamicSpawnTimerRange.x,
											level.DynamicSpawnTimerRange.y))
	##
	
	game_timer.start(lvl_len_secs)
##

func _ready():
	get_tree().paused = false
	GlobalSignals.connect("jet_dead", _jet_dead)
	GlobalSignals.connect("missile_dead", _missile_dead)
	GlobalSignals.connect("hobstacle_dead", _hobstacle_dead)
	GlobalSignals.connect("obstacle_dead", _obstacle_dead)
	$CanvasLayer/GIU.player = player
	$CanvasLayer/GIU.level_timer = game_timer
	$CanvasLayer/GIU.late_ready()
##

func _process(delta):
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
	
	if timer_level == 0 and game_timer.time_left < 30:
		obstacle_timer.stop()
		horizontal_timer.stop()
		timer_level += 1
	##
	
	if timer_level == 1 and game_timer.time_left < 20:
		missile_timer.stop()
		jet_timer.stop()
		GlobalSignals.emit_signal("free_off_screen") # only have everything fire once
		timer_level += 1
	##
	
	if timer_level == 2 and game_timer.time_left < 15:
		GlobalSignals.emit_signal("blow_on_screen") # anything on screen that can should die
		GlobalSignals.emit_signal("bail_out") # tell planes to GTFO
		timer_level += 1
	##
	
	if game_timer.time_left < 2.5:
		player.has_control = false
		env_city.global_position =\
			env_city.global_position.move_toward(Vector2(960, 1090), 400 * delta)
		player.global_position =\
			player.global_position.move_toward(Vector2(960, 1290), 700 * delta)
		if player.global_position.x < 930:
			player.lean_right()
		elif player.global_position.x > 990:
			player.lean_left()
		else:
			player.do_nothing()
		##
	##
##

func _on_game_timer_timeout():
	env_city.get_child(0).play("Nuke")
	$DummyTimerBecauseImLazy.start(0.35)
	await $DummyTimerBecauseImLazy.timeout
	GlobalSignals.emit_signal("level_complete")
##

func _jet_dead():
	curr_jets -= 1
	if jet_timer.is_stopped():
		jet_timer.start(randf_range(Levels[curr_level].FighterSpawnTimerRange.x,
									Levels[curr_level].FighterSpawnTimerRange.y))
	##
##

func _missile_dead():
	curr_missiles -= 1
	if missile_timer.is_stopped():
		missile_timer.start(randf_range(Levels[curr_level].FighterSpawnTimerRange.x,
									Levels[curr_level].FighterSpawnTimerRange.y))
	##
##

func _hobstacle_dead():
	curr_move_obstacles -= 1
	if horizontal_timer.is_stopped():
		horizontal_timer.start(randf_range(Levels[curr_level].DynamicSpawnTimerRange.x,
										Levels[curr_level].DynamicSpawnTimerRange.y))
	##
##

func _obstacle_dead():
	curr_obstacles -= 1
	
	if curr_obstacles < max_obstacles and obstacle_timer.is_stopped():
		obstacle_timer.start(randf_range(Levels[curr_level].StaticSpawnTimerRange.x,
										Levels[curr_level].StaticSpawnTimerRange.y))
	##
##

func _on_missile_timer_timeout():
	var max = max_missiles - curr_missiles
	if max > Levels[curr_level].MissilesRandNumToSpawn.y:
		max = Levels[curr_level].MissilesRandNumToSpawn.y
	##
	var num = randi_range(1, max)
	
	curr_missiles += num
	
	while num > 0:
		var missile = Levels[curr_level].generate_missile()
		missile.target = player
		$Enemies.add_child(missile)
		rand_position.get_random_position(missile)
		num -= 1
	##
	
	if timer_level < 1 and curr_missiles < max_missiles and missile_timer.is_stopped():
		missile_timer.start(randf_range(Levels[curr_level].FighterSpawnTimerRange.x,
									Levels[curr_level].FighterSpawnTimerRange.y))
	##
##

func _on_jet_timer_timeout():
	var max = max_jets - curr_jets
	if max > Levels[curr_level].FightersRandNumToSpawn.y:
		max = Levels[curr_level].FightersRandNumToSpawn.y
	##
	var num = randi_range(1, max)
	
	curr_jets += num
	
	while num > 0:
		var jet = Levels[curr_level].generate_jet()
		jet.player = player
		$Enemies.add_child(jet)
		num -= 1
	##
	
	if timer_level < 1 and curr_jets < max_jets and jet_timer.is_stopped():
		jet_timer.start(randf_range(Levels[curr_level].FighterSpawnTimerRange.x,
								Levels[curr_level].FighterSpawnTimerRange.y))
	##
##

func _on_obstacle_timer_timeout():
	var max = max_obstacles - curr_obstacles
	if max > Levels[curr_level].StaticRandNumToSpawn.y:
		max = Levels[curr_level].StaticRandNumToSpawn.y
	##
	var num = randi_range(1, max)
	curr_obstacles += num
	
	while num > 0:
		var object = Levels[curr_level].generate_static_obstacle()
		$Enemies.add_child(object)
		rand_position.get_random_static_start(object)
		num -= 1
	##
	
	if timer_level == 0 and curr_obstacles < max_obstacles and obstacle_timer.is_stopped():
		obstacle_timer.start(randf_range(Levels[curr_level].StaticSpawnTimerRange.x,
										Levels[curr_level].StaticSpawnTimerRange.y))
	##
##

func _on_horizontal_timer_timeout():
	var max = max_move_obstacles - curr_move_obstacles
	if max > Levels[curr_level].StaticRandNumToSpawn.y:
		max = Levels[curr_level].StaticRandNumToSpawn.y
	##
	var num = randi_range(1, max)
	
	curr_move_obstacles += num
	
	while num > 0:
		var object = Levels[curr_level].generate_moving_obstacle()
		$Enemies.add_child(object)
		rand_position.get_random_horobj_start(object)
		
		if object.global_position.x > player.global_position.x:
			object.HorizontalSpeed *= -1
		##
		
		object.direction_check()
		
		num -= 1
	##
	
	if timer_level == 0 and curr_move_obstacles < max_move_obstacles and horizontal_timer.is_stopped():
		horizontal_timer.start(randf_range(Levels[curr_level].DynamicSpawnTimerRange.x,
										Levels[curr_level].DynamicSpawnTimerRange.y))
	##
##

func get_play_area_limits():
	return [Vector2($Sky.position.x, 0), Vector2($Background3.position.x, 1080)]
##

func get_play_area_x_limits():
	return Vector2($Sky.position.x, $Background3.position.x)
##

func get_play_area_y_limits():
	return Vector2(0, 1080)
##

func get_data():
	var data = {}
	data["level"] = curr_level
	return JSON.stringify(data)
##

func get_player_data():
	return JSON.stringify(player.get_data())
##
