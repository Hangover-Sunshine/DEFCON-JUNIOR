extends Node2D
@onready var plane = $Plane


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize_color()

func randomize_color():
	plane.frame = randi() % 5
