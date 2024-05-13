extends Node2D

@onready var missile = $FatMissile
@onready var player = $Player

func _ready():
	$RandPosition.get_random_position(missile)
	missile.target = player
##
