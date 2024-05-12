extends Node2D
@onready var balloon = $HAB/Balloon


# Called when the node enters the scene tree for the first time.
func _ready():
	balloon.frame = randi() % 9 

