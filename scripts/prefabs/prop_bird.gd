extends Node2D

@onready var body = $Skeleton/Body
@onready var wing_fore = $Skeleton/Body/Wing_Fore
@onready var wing_back = $Skeleton/Body/Wing_Back
@onready var head = $Skeleton/Body/Head
@onready var eye = $Skeleton/Body/Head/Eye
@onready var leg = $Skeleton/Body/Leg
@onready var ap = $AP

signal died
var color = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize_color()

# Randomizes sprite color / type of bird
func randomize_color():
	color = randi() % 3
	body.frame = color
	wing_fore.frame = color
	wing_back.frame = color
	head.frame = color
	eye.frame = color
	leg.frame = color

# Plays death animation and shoots signal to free self
func anim_die():
	if color == 0:
		ap.play("DieA")
	elif color == 1:
		ap.play("DieB")
	elif color == 2:
		ap.play("DieC")

func _on_ap_animation_finished(anim_name):
	if anim_name == "DieA" or anim_name == "DieB" or anim_name == "DieC":
		emit_signal("died")
	
