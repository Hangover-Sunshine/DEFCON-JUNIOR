extends Node2D
@onready var missile = $Missile


# Called when the node enters the scene tree for the first time.
func _ready():
	missile.frame = randi() % 4
