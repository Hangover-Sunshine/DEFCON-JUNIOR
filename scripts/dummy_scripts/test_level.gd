extends Node2D

@onready var missile = $FatMissile
@onready var player = $Player
@onready var fighter = $Fighter

func _ready():
	$RandPosition.get_random_position(missile)
	missile.target = player
	fighter.player = player
##
