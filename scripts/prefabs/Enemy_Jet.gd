extends Node2D

@onready var jet = $Jet
@onready var left = $Jet/Gun/Left
@onready var right = $Jet/Gun/Right

var color = 0

signal died

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize_color()

func randomize_color():
	color = randi() % 4
	jet.frame = color
	left.frame = color
	right.frame = color

func _on_ap_animation_finished(anim_name):
	if anim_name == "Die":
		emit_signal("died")
		
