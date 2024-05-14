extends Node2D
@onready var balloon = $HAB/Balloon
@onready var ap = $AP

signal died

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize_color()

# Randomizes sprite look
func randomize_color():
	balloon.frame = randi() % 9

# Plays death animation and shoots signal to free self
func anim_die():
	ap.play("Die")

func _on_ap_animation_finished(anim_name):
	if anim_name == "Die":
		emit_signal("died")
