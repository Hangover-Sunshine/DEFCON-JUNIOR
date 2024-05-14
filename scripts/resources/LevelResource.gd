extends Resource
class_name LevelResource

@export_category("Level Information")
@export var Length:float = 5

@export_category("Fighters")
@export var MaxFighters:int = 0
@export var FightersRandNumToSpawn:Vector2i = Vector2i(1, 2)
@export var FighterShoot:float = 0.8
@export var FightersAppearAt:float = 0
@export var FighterSpeedRange:Vector2 = Vector2(400, 600)
@export var FighterSpawnTimerRange:Vector2 = Vector2(3, 5)

@export_group("Behaviors")
@export var AllowTimedBob:bool = false
@export var TimeBetweenBobs:Vector2 = Vector2(1.1, 1.6)
@export var AllowScreenLimitBob:bool = false
@export var AllowTrackPlayerBob:bool = false
@export var TimeBetweenPlayerBobs:Vector2 = Vector2(0.5, 1.3)

@export_category("Missiles")
@export var MaxNumberOfMissiles:int = 0
@export var MissilesRandNumToSpawn:Vector2i = Vector2i(1, 3)
@export var MissileSpeedRange:Vector2 = Vector2(325, 400)
@export var CanMissilesLock:bool = false
@export var MissileLockDistance:Vector2 = Vector2(200, 300)
@export var MissilesAppearAt:float = 0
@export var MissileSpawnTimerRange:Vector2 = Vector2(2, 4)

@export_category("Obstacles")
@export var MaxNumberOfStaticObstaclesOnScreen:int = 0
@export var StaticSpawnTimerRange:Vector2 = Vector2(3, 8)
@export var StaticRandNumToSpawn:Vector2i = Vector2i(1, 3)

@export var MaxNumberOfDynamicObstaclesOnScreen:int = 0
@export var DynamicRandNumToSpawn:Vector2i = Vector2i(1, 3)
@export var DynamicSpawnTimerRange:Vector2 = Vector2(4, 6)
@export var BirdSpeedRange:Vector2 = Vector2(200, 300)
@export var PlaneSpeedRange:Vector2 = Vector2(350, 500)
@export var BalloonSpeedRange:Vector2 = Vector2(100, 170)
