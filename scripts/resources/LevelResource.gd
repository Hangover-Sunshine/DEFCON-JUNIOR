extends Resource
class_name LevelResource

@export_category("Level Information")
@export var LevelLength:float = 5

@export_category("Fighters")
@export var FighterFireRate:Vector2 = Vector2(0.8, 0.8)
@export var FighterBulletSpeed:Vector2 = Vector2(350, 350)
@export var FighterSpeedRange:Vector2 = Vector2(400, 600)

@export_group("Jet Spawn Information")
@export var MaxFighters:int = 0
@export var FightersRandNumToSpawn:Vector2i = Vector2i(1, 2)
@export var FightersAppearAt:float = 0
@export var FighterSpawnTimerRange:Vector2 = Vector2(3, 5)

@export_group("Behaviors")
@export var BobSpeedRange:Vector2 = Vector2(300, 400)
@export var AllowTimedBob:bool = false
@export var TimeBetweenBobs:Vector2 = Vector2(1.1, 1.6)
@export var AllowScreenLimitBob:bool = false
@export var AllowTrackPlayerBob:bool = false
@export var TimeBetweenPlayerBobs:Vector2 = Vector2(0.5, 1.3)

@export_category("Missiles")
@export var MissileSpeedRange:Vector2 = Vector2(325, 400)
@export var MissileLifetimeRange:Vector2 = Vector2(10, 15)

@export_group("Missile Spawn Information")
@export var MaxNumberOfMissiles:int = 0
@export var MissilesRandNumToSpawn:Vector2i = Vector2i(1, 3)
@export var MissilesAppearAt:float = 0
@export var MissileSpawnTimerRange:Vector2 = Vector2(2, 4)

@export_group("Locking")
@export var CanMissilesLock:bool = false
@export var MissileLockDistance:Vector2 = Vector2(200, 300)
@export_range(0, 1) var MissileHasLockingChance:float = 0.5

@export_category("Obstacles")
@export var MaxNumberOfStaticObstaclesOnScreen:int = 0
@export var StaticSpawnTimerRange:Vector2 = Vector2(3, 8)
@export var StaticRandNumToSpawn:Vector2i = Vector2i(1, 3)

@export var MaxNumberOfDynamicObstaclesOnScreen:int = 0
@export var DynamicRandNumToSpawn:Vector2i = Vector2i(1, 3)
@export var DynamicSpawnTimerRange:Vector2 = Vector2(4, 6)
@export var BalloonSpeedRange:Vector2 = Vector2(100, 170)
@export var BirdSpeedRange:Vector2 = Vector2(200, 300)
@export var PlaneSpeedRange:Vector2 = Vector2(350, 500)

const MISSILES:Array[PackedScene] = [
	preload("res://prefabs/entities/missiles/fat_missile.tscn"),
	preload("res://prefabs/entities/missiles/girthy_base_missile.tscn"),
	preload("res://prefabs/entities/missiles/pointed_missile.tscn"),
	preload("res://prefabs/entities/missiles/skinny_dome_missile.tscn")
]

const MOVING_OBSTACLES:Array[PackedScene] = [
	preload("res://prefabs/entities/obstacles/balloon.tscn"),
	preload("res://prefabs/entities/obstacles/bird.tscn"),
	preload("res://prefabs/entities/obstacles/plane.tscn")
]

const STATIC_OBSTACLES:Array[PackedScene] = []

const FIGHTER = preload("res://prefabs/entities/fighter.tscn")

func generate_missile():
	var indx = randi() % len(MISSILES)
	var missile = MISSILES[indx].instantiate()
	missile.Speed = randf_range(MissileSpeedRange.x, MissileSpeedRange.y)
	missile.Lifetime = randf_range(MissileLifetimeRange.x, MissileLifetimeRange.y)
	
	if CanMissilesLock:
		missile.LockDistance = randf_range(MissileLockDistance.x, MissileLockDistance.y)
		missile.TrackPlayer = randf_range(0, 1) <= MissileHasLockingChance
	##
	
	return missile
##

func generate_jet():
	var jet = FIGHTER.instantiate()
	jet.RushSpeed = randf_range(FighterSpeedRange.x, FighterSpeedRange.y)
	jet.BobSpeed = randf_range(BobSpeedRange.x, BobSpeedRange.y)
	jet.FireTime = randf_range(FighterFireRate.x, FighterFireRate.y)
	jet.BulletSpeed = randf_range(FighterBulletSpeed.x, FighterBulletSpeed.y)
	
	var chance = randi() % 4
	
	match chance:
		0: # Timed-bob
			jet.BobOnTimer = true
			jet.BobTimer = TimeBetweenBobs
		1: # Scroll whole way bob
			jet.BobLeftAndRight = true
		2: # Scroll whole way on player
			jet.BobLeftAndRight = true
			jet.FollowAndBob = true
		3: # Scroll on player timed
			jet.FollowAndBob = true
			jet.BobOnTimer = true
			jet.BobTimer = TimeBetweenPlayerBobs
		_:
			printerr("Oops.")
		##
	##
	
	return jet
##

func generate_moving_obstacle():
	var indx = randi() % len(MOVING_OBSTACLES)
	var obst = MOVING_OBSTACLES[indx].instantiate()
	obst.MovesHorizontally = true
	
	match indx:
		0:
			obst.HorizontalSpeed = randf_range(BalloonSpeedRange.x, BalloonSpeedRange.y)
		1:
			obst.HorizontalSpeed = randf_range(BirdSpeedRange.x, BirdSpeedRange.y)
		2:
			obst.HorizontalSpeed = randf_range(PlaneSpeedRange.x, PlaneSpeedRange.y)
		##
	##
	
	return obst
##

func generate_static_obstacle():
	pass
##
