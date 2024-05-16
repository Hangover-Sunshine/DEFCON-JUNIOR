extends Resource
class_name WeaponResource

enum Pattern {
	CONE,
	SHOT,
	LINE,
	SPRAY
}

@export var SprayPattern:Pattern = Pattern.SHOT
@export var BulletsSpawnedPerFire:int = 1
@export var DegreeAngleOfCone:float = 35
@export var BulletSpeed:float = 350
@export_range(0.2, 0.4) var BulletSpeedVariance:float = 0.2
@export var FireRate:float = 0.4
@export var ExpendAllToReload:bool = false
@export var ReloadRate:float = 0.8
@export var MagSize:int = 3
