extends Node2D
@onready var missile = $Missile


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize_color()

func randomize_color():
	missile.frame = randi() % 4
