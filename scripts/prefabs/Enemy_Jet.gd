extends Node2D

@onready var jet = $Jet
@onready var left = $Jet/Gun/Left
@onready var right = $Jet/Gun/Right
@onready var ap = $AP
@onready var ap_gun = $Jet/AP_Gun

signal died
var color = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize_color()

# Randomizes look of sprite
func randomize_color():
	color = randi() % 4
	jet.frame = color
	left.frame = color
	right.frame = color

# Plays death animation and shoots signal to free self
func anim_die():
	ap.play("Die")

func fire():
	ap_gun.play("Shoot")
##

func reset_gun():
	ap_gun.play("RESET")
##

func _on_ap_animation_finished(anim_name):
	if anim_name == "Die":
		emit_signal("died")
