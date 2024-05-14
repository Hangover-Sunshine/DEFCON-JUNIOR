extends Resource
class_name LevelResource

@export_group("Level Information")
@export var Length:float = 5

@export_group("Fighters")
@export var MaxFighters:int = 0
@export var FighterShoot:float = 0.8
@export var FightersAppearAt:float = 0

@export_group("Obstacles & Missiles")
@export var MaxNumberOfMissiles:int = 0
@export var MissileSpeed:int = 350

@export var MaxNumberOfStaticObstaclesOnScreen:int = 0
@export var MaxNumberOfDynamicObstaclesOnScreen:int = 0
