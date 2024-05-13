extends Resource
class_name WeaponResource

enum Pattern {
	CONE,
	SHOT,
	LINE,
	SPRAY
}

@export var SprayPattern:Pattern = Pattern.SHOT
@export var BasePenetration:int = 1
