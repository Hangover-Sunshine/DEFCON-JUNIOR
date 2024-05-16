extends Node2D
@onready var ap_face = $AP_Face
@onready var ap_rotate = $AP_Rotate
@onready var face_timer = $FaceTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Functions for when player moves.
func to_notmove():
	ap_rotate.play("Down")

func to_right():
	ap_rotate.play("Right")

func to_left():
	ap_rotate.play("Left")

func shoot():
	$Nuke/Body/Face/Mouth.frame = 1
	face_timer.start(0.3)
##

# Functions that manage look of when player is hit
func to_happy():
	ap_face.play("Happy")

func to_pain():
	ap_face.play("Pain")

func _on_face_timer_timeout():
	$Nuke/Body/Face/Mouth.frame = 0
##
