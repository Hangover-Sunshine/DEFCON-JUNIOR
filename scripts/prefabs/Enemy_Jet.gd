extends Node2D

@onready var jet = $Jet
@onready var left = $Jet/Gun/Left
@onready var right = $Jet/Gun/Right

var color = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize_color()

func randomize_color():
	color = randi() % 4
	jet.frame = color
	left.frame = color
	right.frame = color
