extends Node2D

@onready var body = $Skeleton/Body
@onready var wing_fore = $Skeleton/Body/Wing_Fore
@onready var wing_back = $Skeleton/Body/Wing_Back
@onready var head = $Skeleton/Body/Head
@onready var eye = $Skeleton/Body/Head/Eye
@onready var leg = $Skeleton/Body/Leg

var color = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize_color()

func randomize_color():
	color = randi() % 3
	body.frame = color
	wing_fore.frame = color
	wing_back.frame = color
	head.frame = color
	eye.frame = color
	leg.frame = color
