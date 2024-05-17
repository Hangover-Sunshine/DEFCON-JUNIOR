extends Control

@onready var text = $Text_Label
@onready var continue_text = $Continue_Label

@onready var TheVoid = $TheVoid
@onready var ap_mouth = $TheVoid/AP_Mouth
@onready var ap_upper_face = $TheVoid/AP_UpperFace

#Manipulate this guy to run specific cutscene
var chapter = 1

var line = 0
var length = 0
var cur_script = ["INSERT TEXT HERE"]
var script1 = ["Hello", "How are you", "Good", "Goodbye"]
var script2 = ["Hola", "Coma Estas", "Bien", "Choi"]

func _ready():
	assign_script()

func assign_script():
	if chapter == 1:
		cur_script = script1
	elif chapter == 2:
		cur_script = script2
	text.text = cur_script[line]
		
func _input(event):
	if event.is_pressed() and continue_text.visible == true:
		line += 1
		if line < cur_script.size():
			ap_mouth.play("Speak")
			continue_text.visible = false
	next_line()

func next_line():
	if line < cur_script.size():
		text.text = cur_script[line]
	elif line >= cur_script.size():
		text.text = "SCENE END"
		continue_text.visible = false
		
func _on_ap_mouth_animation_finished(anim_name):
	if anim_name == "Speak":
		ap_mouth.play("Neutral")
		continue_text.visible = true
